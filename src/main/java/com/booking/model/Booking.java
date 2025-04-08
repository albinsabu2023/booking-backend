package com.booking.model;

import java.sql.*;


public class Booking {
	private int bookingId;
	private int empId;
	private int roomId;
	private Date bookDate;
	private Time fromTime;
	private Time toTime;
	private String status;
	private int capacity;
	
	
	
	public Booking(int bookingId, int empId, int roomId, Date bookDate, Time fromTime, Time toTime, String status,int capacity) {
		super();
		this.bookingId = bookingId;
		this.empId = empId;
		this.roomId = roomId;
		this.bookDate = bookDate;
		this.fromTime = fromTime;
		this.toTime = toTime;
		this.status = status;
		this.capacity=capacity;
	}
	
	public int getBookingId() {
		return bookingId;
	}
	public void setBookingId(int bookingId) {
		this.bookingId = bookingId;
	}
	public int getEmpId() {
		return empId;
	}
	public void setEmpId(int empId) {
		this.empId = empId;
	}
	public int getRoomId() {
		return roomId;
	}
	public void setRoomId(int roomId) {
		this.roomId = roomId;
	}
	public Date getBookDate() {
		return bookDate;
	}
	public void setBookDate(Date bookDate) {
		this.bookDate = bookDate;
	}
	public Time getFromTime() {
		return fromTime;
	}
	public void setFromTime(Time fromTime) {
		this.fromTime = fromTime;
	}
	public Time getToTime() {
		return toTime;
	}
	public void setToTime(Time toTime) {
		this.toTime = toTime;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public int getCapacity() {
		return capacity;
	}
	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}
	@Override
	public String toString() {
		return "Booking [bookingId=" + bookingId + ", empId=" + empId + ", roomId=" + roomId + ", bookDate=" + bookDate
				+ ", fromTime=" + fromTime + ", toTime=" + toTime + ", status=" + status + ",capacity" +capacity ;
	}
	
	
}