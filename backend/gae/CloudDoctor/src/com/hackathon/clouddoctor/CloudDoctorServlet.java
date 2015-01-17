package com.hackathon.clouddoctor;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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
			List<String> tokens = new ArrayList<String>(Arrays.asList(stemmedQuery.split(" ")));
			int i = 0;
			while(i < tokens.size()) {
				if(tokens.get(i).equals("")) {
					tokens.remove(i);
				}
				else {
					i++;
				}
			}
			
			// If this server hasn't built docs yet, build docs
			if((Global.globalDoc == null) || (Global.docs == null) || (Global.docNames == null)) {
				Global.buildDocs();
			}
			
			Document queryDoc = new Document("query");
			for(String token : tokens) {
					// System.out.println(token);
					if (queryDoc.freqs.containsKey(token)) {
						double val = queryDoc.freqs.get(token);
						queryDoc.freqs.put(token, val + 1.0);
					} else {
						queryDoc.freqs.put(token, 1.0);
					}
			}
			
		
			
			resp.setContentType("text/plain");
			resp.getWriter().println(stemmedQuery);
		}
		else if(action.equals("build")) {
			try {
				Global.buildDocs();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}

