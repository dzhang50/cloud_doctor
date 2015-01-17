package com.hackathon.clouddoctor;

import java.util.HashMap;

public class Document implements java.io.Serializable {
	
	private static final long serialVersionUID = 1L;
	
	public String name;
	public Integer numTerms;
	public HashMap<String, Double> freqs;
	
	public Document(String n) {
		name = n;
		numTerms = null;
		freqs = new HashMap<String, Double>();
	}
}
