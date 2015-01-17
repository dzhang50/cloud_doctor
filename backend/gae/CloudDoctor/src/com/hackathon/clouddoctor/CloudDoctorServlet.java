package com.hackathon.clouddoctor;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class CloudDoctorServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		System.out.println("CloudDoctor DoGet");

		String action = req.getParameter("action");
		String query = req.getParameter("query").trim();
		System.out.println("Action: "+action+", query: "+query);

		if(action.equals("diag")) {
			System.out.println("Diagnose query = "+query);
			Stemmer stem = new Stemmer();
			String stemmedQuery = stem.doStem(query);
			System.out.println("Answer: "+stemmedQuery);
			resp.setContentType("text/plain");
			resp.getWriter().println(stemmedQuery);
		}
	}
}

