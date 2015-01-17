package com.hackathon.clouddoctor;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class CloudDoctorServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		System.out.println("CloudDoctor DoGet");

		String action = req.getParameter("action");
		String query = req.getParameter("query");
		if(query != null) {query.trim();}
		System.out.println("Action: "+action+", query: "+query);

		if(action.equals("diag")) {
			System.out.println("Diagnose query = "+query);
			
			String cleanQuery = query.replaceAll("[^a-zA-Z ]", "").toLowerCase();
			
			Stemmer stem = new Stemmer();
			String stemmedQuery = stem.doStem(cleanQuery);
			System.out.println("Answer: "+stemmedQuery);
			
			
			
			resp.setContentType("text/plain");
			resp.getWriter().println(stemmedQuery);
		}
		else if(action.equals("build")) {
			// Read all documents in folder
		
			File folder = new File("diseases/");
			File[] listOfFiles = folder.listFiles();
			Document globalDoc = new Document("global");
			
			for (File file : listOfFiles) {
			    if (file.isFile()) {
			        System.out.println(file.getName());
			    	
					FileInputStream fin = null;
					try {
						fin = new FileInputStream(file);
					} catch (FileNotFoundException e) {
						System.out.println("ERROR: FILE NOT FOUND!!!");
					}
					BufferedReader fileReader = new BufferedReader(new InputStreamReader(
							fin));
					String line;
					
					String diseaseName = fileReader.readLine();
					System.out.println("Disease: "+diseaseName+"\n");
					
					String desc = "";
					while ((line = fileReader.readLine()) != null) {
						//System.out.println(line.trim());
						desc += line.trim() + " ";
					}
					//System.out.println("Desc: "+desc);
					String cleanDesc = desc.replaceAll("[^a-zA-Z ]", "").toLowerCase();
					Stemmer stem = new Stemmer();
					String stemmedDesc = stem.doStem(cleanDesc);
					
					String[] tokens = stemmedDesc.split(" ");
					
					for(String token : tokens) {
						//System.out.println(token);
						if(globalDoc.freqs.containsKey(token)) {
							int val = globalDoc.freqs.get(token);
							globalDoc.freqs.put(token, val+1);
						}
						else {
							globalDoc.freqs.put(token, 1);
						}
					}
					
			    }
			}
			
			for (Map.Entry<String, Integer> entry : globalDoc.freqs.entrySet()) {
			    System.out.println(entry.getKey()+" : "+entry.getValue());
			}
		}
	}
}

