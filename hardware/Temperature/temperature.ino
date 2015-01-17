#include <Wire.h>

#include <BLE_API.h>
#include <stdlib.h>

#define TXRX_BUF_LEN                      20
#define UART_RX_TIME                      APP_TIMER_TICKS(100, 0)

#define HRM_TIME                             APP_TIMER_TICKS(1, 0)

BLEDevice  ble;

static app_timer_id_t                     m_uart_rx_id; 
static uint8_t rx_buf[TXRX_BUF_LEN];
static uint8_t rx_buf_num = 0;
static uint8_t rx_state = 0;

// RBL TXRX Service
static const uint8_t uart_base_uuid[]     = {0x71, 0x3D, 0, 0, 0x50, 0x3E, 0x4C, 0x75, 0xBA, 0x94, 0x31, 0x48, 0xF1, 0x8D, 0x94, 0x1E};
static const uint8_t uart_tx_uuid[]       = {0x71, 0x3D, 0, 3, 0x50, 0x3E, 0x4C, 0x75, 0xBA, 0x94, 0x31, 0x48, 0xF1, 0x8D, 0x94, 0x1E};
static const uint8_t uart_rx_uuid[]       = {0x71, 0x3D, 0, 2, 0x50, 0x3E, 0x4C, 0x75, 0xBA, 0x94, 0x31, 0x48, 0xF1, 0x8D, 0x94, 0x1E};
static const uint8_t uart_base_uuid_rev[] = {0x1E, 0x94, 0x8D, 0xF1, 0x48, 0x31, 0x94, 0xBA, 0x75, 0x4C, 0x3E, 0x50, 0, 0, 0x3D, 0x71};

uint8_t txPayload[TXRX_BUF_LEN] = {0,};
uint8_t rxPayload[TXRX_BUF_LEN] = {0,};

GattCharacteristic  txCharacteristic(uart_tx_uuid, txPayload, 1, TXRX_BUF_LEN,
                                      GattCharacteristic::BLE_GATT_CHAR_PROPERTIES_WRITE | GattCharacteristic::BLE_GATT_CHAR_PROPERTIES_WRITE_WITHOUT_RESPONSE);
                                      
GattCharacteristic  rxCharacteristic(uart_rx_uuid, rxPayload, 1, TXRX_BUF_LEN,
                                      GattCharacteristic::BLE_GATT_CHAR_PROPERTIES_NOTIFY);
                                      
GattCharacteristic *uartChars[] = {&txCharacteristic, &rxCharacteristic};

GattService         uartService(uart_base_uuid, uartChars, sizeof(uartChars) / sizeof(GattCharacteristic *));

static app_timer_id_t                        m_hrs_timer_id;

bool tmp_on = false;

int tmp102Address = 0x48;

void m_uart_rx_handle(void * p_context)
{   //update characteristic data
    ble.updateCharacteristicValue(rxCharacteristic.getHandle(), rx_buf, rx_buf_num);   
    memset(rx_buf, 0x00,20);
    rx_state = 0;
}

void uartCallBack(void)
{    
    uint32_t err_code = NRF_SUCCESS;
    
    if (rx_state == 0)
    {  
        rx_state = 1;
        err_code = app_timer_start(m_uart_rx_id, UART_RX_TIME, NULL);
        APP_ERROR_CHECK(err_code);   
        rx_buf_num=0;
    }
    while ( Serial.available() )
    {
        rx_buf[rx_buf_num] = Serial.read();
        rx_buf_num++;
    }
}

void disconnectionCallback(void)
{
    ble.startAdvertising();
}

int getTemperature(){
  Wire.requestFrom(tmp102Address,2); 

  byte MSB = Wire.read();
  byte LSB = Wire.read();

  //it's a 12bit int, using two's compliment for negative
  int TemperatureSum = ((MSB << 8) | LSB) >> 4; 

  //float celsius = TemperatureSum*0.0625;
  return TemperatureSum;
}

void onDataWritten(uint16_t charHandle)
{	
    uint8_t buf[TXRX_BUF_LEN];
    uint16_t bytesRead;
	
    if ( charHandle == txCharacteristic.getHandle() ) 
    {
        ble.readCharacteristicValue(txCharacteristic.getHandle(), buf, &bytesRead);
        for (uint8_t i = 0; i < bytesRead; i++)
        {
            Serial.write(buf[i]);
        }
        switch(buf[0])
        {
          case 'S'  :
          {
            //Stop the ECG reads
            tmp_on = false;
            //digitalWrite(3, LOW);
            Serial.println("RXed shutdown");
            break;
          }
          case 'G':
          {
            //Go the ECG reads
            tmp_on = true;
            //digitalWrite(3, HIGH);
            Serial.println("RXed start");
            break;
          }
        }
    }
}

void setup(void)
{
      // initialize the serial communication:
//    pinMode(2, INPUT); // Setup for leads off detection LO +
//    pinMode(0, INPUT); // Setup for leads off detection LO -
//    
    uint32_t err_code = NRF_SUCCESS;
    
    delay(500);
    Serial.begin(9600);
    Wire.begin();
    Serial.irq_attach(uartCallBack);
    
    ble.init();
    err_code = app_timer_create(&m_hrs_timer_id, APP_TIMER_MODE_REPEATED, periodicCallback );
    APP_ERROR_CHECK(err_code);    

    err_code = app_timer_start(m_hrs_timer_id, HRM_TIME, NULL);
    APP_ERROR_CHECK(err_code);	

    ble.onDisconnection(disconnectionCallback);
    ble.onDataWritten(onDataWritten);

    /* setup advertising */
    ble.accumulateAdvertisingPayload(GapAdvertisingData::BREDR_NOT_SUPPORTED);
    ble.setAdvertisingType(GapAdvertisingParams::ADV_CONNECTABLE_UNDIRECTED);
    ble.accumulateAdvertisingPayload(GapAdvertisingData::SHORTENED_LOCAL_NAME,(const uint8_t *)"TXRX", sizeof("TXRX") - 1);
    ble.accumulateAdvertisingPayload(GapAdvertisingData::COMPLETE_LIST_128BIT_SERVICE_IDS,(const uint8_t *)uart_base_uuid_rev, sizeof(uart_base_uuid));

    /* 100ms; in multiples of 0.625ms. */
    ble.setAdvertisingInterval(160); 

    ble.addService(uartService);
    
    //Set Dev_Name
    err_code = RBL_SetDevName("nRF51822_Serial");
    APP_ERROR_CHECK(err_code);
    
    ble.startAdvertising();
    
    err_code = app_timer_create(&m_uart_rx_id,APP_TIMER_MODE_SINGLE_SHOT, m_uart_rx_handle);
    APP_ERROR_CHECK(err_code);

}

void periodicCallback( void * p_context )
{
    
  if(!tmp_on)
  {
    return;
  }
   
    Serial.println("callback");
  
    if (ble.getGapState().connected) 
    {     
        int a_val = getTemperature();
        String val = String(a_val, DEC);
        Serial.println(val);
  
        for(int j = 0; j < 4 - val.length(); j++)
        { 
          rx_buf[rx_buf_num] = '0';
          rx_buf_num++;
        }  

        for (int i = 0; i < val.length(); i++)
        {
          rx_buf[rx_buf_num] = val[i];
          rx_buf_num++;
        }
        
        
    }

    if(rx_buf_num > 15)
    {
      ble.updateCharacteristicValue(rxCharacteristic.getHandle(), rx_buf, rx_buf_num);   
      rx_buf_num = 0;
      memset(rx_buf, 0x00,20);
      rx_state = 0;
    }
  
}



void loop(void)
{
  ble.waitForEvent();
}





