package com.hackathon.clouddoctor;

public class Triple<X, Y, Z> {
	public X first;
	public Y second;
	public Z third;

	public Triple(X x, Y y, Z z) {
		this.first = x;
		this.second = y;
		this.third = z;
	}
	public Triple() {
		
	}
	
	@Override
	public String toString() {
		return "["+first+", "+second+", "+third+"]";
	}
}
