package com.hackathon.clouddoctor;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@SuppressWarnings("serial")
public class CloudDoctorServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		System.out.println("CloudDoctor DoGet");

		String action = req.getParameter("action");
		String query = req.getParameter("query");
		if (query != null) {
			query.trim();
		}
		String tempStr = req.getParameter("temp");
		String heartRateStr = req.getParameter("heartrate");
		String respRateStr = req.getParameter("resprate");
		
		System.out.println("Action: " + action + ", query: " + query);

		if (action.equals("diag")) {
			System.out.println("Diagnose query = " + query);

			resp.setContentType("application/json");
			List<Diagnostic> diagnostics = new ArrayList<Diagnostic>();
			if(respRateStr != null) {
				double respRate = Double.parseDouble(respRateStr);
				
				if(respRate > 22.0) {
					// Tachypnea, go to ER for oxygen therapy
					diagnostics.add(new Diagnostic("Tachypnea", "", 0.9));
				}
			}
			
			if(tempStr != null) {
				double temp = Double.parseDouble(tempStr);
				
				if(temp > 100.3) {
					// Fever, prescribe Tylenol to prevent febrile seizures
					diagnostics.add(new Diagnostic("Fever", "Tylenol", 0.9));
				}
			}
			
			if(heartRateStr != null) {
				double heartRate = Double.parseDouble(heartRateStr);
				
				if(heartRate > 120.0) {
					// Tachycardia, likely caused by dehydration (ask about dry mouth)
					// Prescribe Pedialyte
					diagnostics.add(new Diagnostic("Tachycardia", "Pedialyte", 0.9));
				}
			}
			
			String cleanQuery = query.replaceAll("[^a-zA-Z ]", "").toLowerCase();

			Stemmer stem = new Stemmer();
			String stemmedQuery = stem.doStem(cleanQuery);
			System.out.println("Answer: " + stemmedQuery);
			List<String> tokens = new ArrayList<String>(
					Arrays.asList(stemmedQuery.split(" ")));
			int i = 0;
			while (i < tokens.size()) {
				if (tokens.get(i).equals("")) {
					tokens.remove(i);
				} else {
					i++;
				}
			}

			// If this server hasn't built docs yet, build docs
			if ((Global.globalDoc == null) || (Global.docs == null) || (Global.docNames == null)) {
				Global.buildDocs();
			}

			Document queryDoc = new Document("query", "");
			for (String token : tokens) {
				// System.out.println(token);
				if (queryDoc.freqs.containsKey(token)) {
					double val = queryDoc.freqs.get(token);
					queryDoc.freqs.put(token,
							val + 1.0 / (double) tokens.size());
				} else {
					queryDoc.freqs.put(token, 1.0 / (double) tokens.size());
				}
			}

			List<Triple<String, String, Double>> scores = new ArrayList<Triple<String, String, Double>>();
			ArrayList<ArrayList<Tuple<String, Double>>> individualScores = new ArrayList<ArrayList<Tuple<String, Double>>>();
			int scoreIdx = 0;
			// System.out.println(entry.getKey() + ": " + entry.getValue());
			for (Document doc : Global.docs) {
				if(doc.name.equals("")) {
					continue;
				}
				double tfidf = 0.0;
				ArrayList<Tuple<String, Double>> breakdown = new ArrayList<Tuple<String, Double>>();
				for (Map.Entry<String, Double> entry : queryDoc.freqs.entrySet()) {
					if (doc.freqs.containsKey(entry.getKey())) {
						// TODO: Cosine Similarity
						tfidf += (entry.getValue() * (doc.freqs.get(entry.getKey()) * Global.idf.freqs.get(entry.getKey()) * (1.0/Global.globalDoc.freqs.get(entry.getKey()))));
						breakdown.add(new Tuple(entry.getKey(), entry.getValue() * doc.freqs.get(entry.getKey())));
					}
				}
				scores.add(new Triple<String, String, Double>(doc.name, doc.treatment, tfidf));
				individualScores.add(breakdown);
			}
			
			List<Triple<String, String, Double>> sortedScores = new ArrayList<Triple<String, String, Double>>(scores);
			Collections.sort(sortedScores, new Comparator<Triple<String, String, Double>>() {
				public int compare(Triple<String, String, Double> s1,
						Triple<String, String, Double> s2) {
					if (s1.third < s2.third)
						return 1;
					if (s1.third > s2.third)
						return -1;
					return 0;
				}
			});

			//resp.getWriter().println(stemmedQuery);
			//resp.getWriter().println(scores);
			//resp.getWriter().println(individualScores);
			
			for(Triple<String, String, Double> entry : sortedScores) {
				diagnostics.add(new Diagnostic(entry.first, entry.second, entry.third));
			}
			Gson gson = new GsonBuilder().create();
            String json = gson.toJson(diagnostics);
			resp.getWriter().println(json);
			
		} else if (action.equals("build")) {
			try {
				Global.buildDocs();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
