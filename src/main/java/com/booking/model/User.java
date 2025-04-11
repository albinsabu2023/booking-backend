package com.booking.model;

public class User {
	private int employeeId;
	private String name;
	private String password;
	
	
	public User(int employeeId, String name, String password) {
		super();
		this.employeeId = employeeId;
		this.name = name;
		this.password = password;
	}
	public int getEmployeeId() {
		return employeeId;
	}
	public void setEmployeeId(int employeeId) {
		this.employeeId = employeeId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	
}
