package com.hackathon.clouddoctor;

public class Diagnostic {
	String disease;
	String prescription;
	double confidence;
	
	Diagnostic(){}
	
	Diagnostic(String d, String p, double c) {
		disease = d;
		prescription = p;
		confidence = c;
	}
}
