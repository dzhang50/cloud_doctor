package com.hackathon.clouddoctor;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class Stemmer {

	StemmerCore s;

	public Stemmer() {
		s = new StemmerCore();
	}
	
	public String doStem(String str) {
		char[] w = new char[5001];
		String output = new String();
		
		//FileInputStream in = new FileInputStream(args[i]);
		InputStream in = new ByteArrayInputStream(str.getBytes(StandardCharsets.UTF_8));
		try {
			while(true) {
				int ch = in.read();
				if (Character.isLetter((char) ch)) {
					int j = 0;
					while(true) {
						ch = Character.toLowerCase((char) ch);
						w[j] = (char) ch;
						if (j < 5000) j++;
						ch = in.read();
						if (!Character.isLetter((char) ch))
						{
							/* to test add(char ch) */
							for (int c = 0; c < j; c++) s.add(w[c]);

							/* or, to test add(char[] w, int j) */
							/* s.add(w, j); */

							s.stem();
							{  String u;

							/* and now, to test toString() : */
							u = s.toString();

							/* to test getResultBuffer(), getResultLength() : */
							/* u = new String(s.getResultBuffer(), 0, s.getResultLength()); */

							System.out.print(u);
							output += u;
							}
							break;
						}
					}
				}
				
				if (ch < 0) break;
				System.out.print((char)ch);
				output += (char)ch;
			}
		}
		catch (IOException e)
		{  System.out.println("error reading "+str);
		}
		String wStr = new String(w);
		System.out.println("w: "+ wStr);
		return output;
	}
}

