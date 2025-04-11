package com.booking.model;

import java.sql.Date;
import java.sql.Time;

public class Booking {
    private int bookingId;
    private int employeeId;
    private int roomId;
    private Date bookDate;
    private Time fromTime;
    private Time toTime;
    private String status;
    private int capacity;

    public Booking(int bookingId, int employeeId, int roomId, Date bookDate, Time fromTime, Time toTime, String status, int capacity) {
        this.bookingId = bookingId;
        this.employeeId = employeeId;
        this.roomId = roomId;
        this.bookDate = bookDate;
        this.fromTime = fromTime;
        this.toTime = toTime;
        this.status = status;
        this.capacity = capacity;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
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
}