package com.hackathon.clouddoctor;

import java.util.HashMap;

public class Document implements java.io.Serializable {
	
	private static final long serialVersionUID = 1L;
	
	public String name;
	public HashMap<String, Integer> freqs;
	
	public Document(String n) {
		name = n;
		freqs = new HashMap<String, Integer>();
	}
}
