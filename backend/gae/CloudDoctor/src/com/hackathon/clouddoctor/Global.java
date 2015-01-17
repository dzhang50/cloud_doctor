package com.hackathon.clouddoctor;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

public class Global {

	public static MemcacheService cache = MemcacheServiceFactory
			.getMemcacheService("cache");
	public static Document globalDoc;
	public static List<Document> docs;
	public static List<String> docNames;
	
	public static Document idf;

	public static void clearAllCaches() {
		cache.clearAll();
	}

	public static void buildDocs() {
		// Read all documents in folder

		File folder = new File("diseases/");
		File[] listOfFiles = folder.listFiles();
		globalDoc = new Document("global");
		docs = new ArrayList<Document>();
		docNames = new ArrayList<String>();
		docNames.add("global");

		int docIdx = 0;
		for (File file : listOfFiles) {
			if (file.isFile()) {
				System.out.println(file.getName());
				docNames.add(file.getName());

				FileInputStream fin = null;
				try {
					fin = new FileInputStream(file);
				} catch (FileNotFoundException e) {
					System.out.println("ERROR: FILE NOT FOUND!!!");
				}
				BufferedReader fileReader = new BufferedReader(
						new InputStreamReader(fin));
				String line;

				String diseaseName = "";
				String desc = "";
				try {
					diseaseName = fileReader.readLine();
					System.out.println("Disease: " + diseaseName + "\n");
					docs.add(new Document(diseaseName.trim()));

					while ((line = fileReader.readLine()) != null) {
						// System.out.println(line.trim());
						desc += line.trim() + " ";
					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				// System.out.println("Desc: "+desc);
				String cleanDesc = desc.replaceAll("[^a-zA-Z ]", "").toLowerCase();
				Stemmer stem = new Stemmer();
				String stemmedDesc = stem.doStem(cleanDesc);

				List<String> tokens = new ArrayList<String>(Arrays.asList(stemmedDesc.split(" ")));
				int i = 0;
				while(i < tokens.size()) {
					if(tokens.get(i).equals("")) {
						tokens.remove(i);
					}
					else {
						i++;
					}
				}
				
				docs.get(docIdx).numTerms = tokens.size();
				for (String token : tokens) {
					// System.out.println(token);
					if (globalDoc.freqs.containsKey(token)) {
						double val = globalDoc.freqs.get(token);
						globalDoc.freqs.put(token, val + 1.0);
					} else {
						globalDoc.freqs.put(token, 1.0);
					}
					
					// Calculate normalized term frequency per document
					if (docs.get(docIdx).freqs.containsKey(token)) {
						double val = docs.get(docIdx).freqs.get(token);
						docs.get(docIdx).freqs.put(token, val + 1.0/(double)tokens.size());
					} else {
						docs.get(docIdx).freqs.put(token, 1.0/(double)tokens.size());
					}
				}
				docIdx++;
			}
		}
		
		// Set document index
		Global.cache.put("index", docNames);
		
		// Set global document frequency table
		Global.cache.put(globalDoc.name, globalDoc);
		
		System.out.println("Global");
		for (Map.Entry<String, Double> entry : globalDoc.freqs.entrySet()) {
			System.out.println(entry.getKey() + " : " + entry.getValue());
		}

		for (Document doc : docs) {
			Global.cache.put(doc.name, doc);

			//System.out.println(doc.name);
			for (Map.Entry<String, Double> entry : doc.freqs.entrySet()) {
				//System.out.println(entry.getKey() + ": " + entry.getValue());
			}
		}
		
		// Calculate inverse document frequency
		idf = new Document("idf");
		
		int numDocs = docs.size();
		for(Map.Entry<String, Double> entry : globalDoc.freqs.entrySet()) {
			int numDocOccurrences = 0;
			for(Document doc : docs) {
				if(doc.freqs.containsKey(entry.getKey())) {
					numDocOccurrences++;
				}
			}
			double val = 1.0 + Math.log((double)numDocs/(double)numDocOccurrences);
			idf.freqs.put(entry.getKey(), val);
		}
		
		System.out.println("IDF:");
		for(Map.Entry<String, Double> entry : idf.freqs.entrySet()) {
			System.out.println(entry.getKey() + ": "+entry.getValue());
		}
	}

	public static int max(int a, int b) {
		if (a > b) {
			return a;
		} else {
			return b;
		}
	}

	public static int min(int a, int b) {
		if (a < b) {
			return a;
		} else {
			return b;
		}
	}
}
