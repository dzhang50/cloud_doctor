package com.hackathon.clouddoctor;

import java.util.HashMap;

public class Document implements java.io.Serializable {
	
	private static final long serialVersionUID = 1L;
	
	public String name;
	public String treatment;
	public Integer numTerms;
	public Double magnitude;
	public HashMap<String, Double> freqs;
	
	public Document(String n, String treat) {
		name = n;
		treatment = treat;
		numTerms = null;
		magnitude = null;
		freqs = new HashMap<String, Double>();
	}
}
