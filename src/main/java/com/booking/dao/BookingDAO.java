package com.booking.dao;
import java.sql.*;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;
import com.booking.model.Booking;

public class BookingDAO {
    private final static String GET_ALL_BOOKINGS = "SELECT * FROM bookings";
    private final static String GET_BOOKING_BY_ID = "SELECT * FROM bookings WHERE booking_id = ?";
    private final static String GET_UPCOMING_BOOKINGS = "SELECT * FROM bookings WHERE date >= ? AND status != 'Cancelled'";
    private final static String GET_CANCELLED_BOOKINGS = "SELECT * FROM bookings WHERE status = 'Cancelled'";
    private final static String INSERT_BOOKING = "INSERT INTO bookings (employee_id, roomId, date, fromtime, totime, status, capacity) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private final static String UPDATE_BOOKING = "UPDATE bookings SET employee_id=?, roomId=?, date=?, fromtime=?, totime=?, capacity=? WHERE booking_id=?";
    private final static String CANCEL_BOOKING = "UPDATE bookings SET status='Cancelled' WHERE booking_id=?";
    
    public static List<Booking> getBookings(Connection con) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(GET_ALL_BOOKINGS);
        
        while(rs.next()) {
            int bId = rs.getInt("booking_id");
            int eId = rs.getInt("employee_id");
            int rId = rs.getInt("roomId");
            Date bDate = rs.getDate("date");
            Time fTime = rs.getTime("fromtime");
            Time tTime = rs.getTime("totime");
            String status = rs.getString("status");
            int capacity = rs.getInt("capacity");
            
            Booking b = new Booking(bId, eId, rId, bDate, tTime, fTime, status, capacity);
            bookings.add(b);
        }
        
        return bookings;
    }
    
    public static Booking getBookingById(Connection con, int bookingId) throws SQLException {
        PreparedStatement ps = con.prepareStatement(GET_BOOKING_BY_ID);
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()) {
            int bId = rs.getInt("booking_id");
            int eId = rs.getInt("employee_id");
            int rId = rs.getInt("roomId");
            Date bDate = rs.getDate("date");
            Time fTime = rs.getTime("fromtime");
            Time tTime = rs.getTime("totime");
            String status = rs.getString("status");
            int capacity = rs.getInt("capacity");
            
            return new Booking(bId, eId, rId, bDate, tTime, fTime, status, capacity);
        }
        
        return null;
    }
    
    public static List<Booking> getUpcomingBookings(Connection con) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        PreparedStatement ps = con.prepareStatement(GET_UPCOMING_BOOKINGS);
        ps.setDate(1, Date.valueOf(LocalDate.now()));
        ResultSet rs = ps.executeQuery();
        
        while(rs.next()) {
            int bId = rs.getInt("booking_id");
            int eId = rs.getInt("employee_id");
            int rId = rs.getInt("roomId");
            Date bDate = rs.getDate("date");
            Time fTime = rs.getTime("fromtime");
            Time tTime = rs.getTime("totime");
            String status = rs.getString("status");
            int capacity = rs.getInt("capacity");
            
            Booking b = new Booking(bId, eId, rId, bDate, tTime, fTime, status, capacity);
            bookings.add(b);
        }
        
        return bookings;
    }
    
    public static List<Booking> getCancelledBookings(Connection con) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        PreparedStatement ps = con.prepareStatement(GET_CANCELLED_BOOKINGS);
        ResultSet rs = ps.executeQuery();
        
        while(rs.next()) {
            int bId = rs.getInt("booking_id");
            int eId = rs.getInt("employee_id");
            int rId = rs.getInt("roomId");
            Date bDate = rs.getDate("date");
            Time fTime = rs.getTime("fromtime");
            Time tTime = rs.getTime("totime");
            String status = rs.getString("status");
            int capacity = rs.getInt("capacity");
            
            Booking b = new Booking(bId, eId, rId, bDate, tTime, fTime, status, capacity);
            bookings.add(b);
        }
        
        return bookings;
    }
    
    public static void addBooking(Connection con, Booking booking) throws SQLException {
        PreparedStatement ps = con.prepareStatement(INSERT_BOOKING, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, booking.getEmpId());
        ps.setInt(2, booking.getRoomId());
        ps.setDate(3, booking.getBookDate());
        ps.setTime(4, booking.getFromTime());
        ps.setTime(5, booking.getToTime());
        ps.setString(6, booking.getStatus());
        ps.setInt(7, booking.getCapacity());
        
        ps.executeUpdate();
        
        // Get the generated ID
        ResultSet rs = ps.getGeneratedKeys();
        if(rs.next()) {
            booking.setBookingId(rs.getInt(1));
        }
    }
    
    public static void updateBooking(Connection con, Booking booking) throws SQLException {
        PreparedStatement ps = con.prepareStatement(UPDATE_BOOKING);
        ps.setInt(1, booking.getEmpId());
        ps.setInt(2, booking.getRoomId());
        ps.setDate(3, booking.getBookDate());
        ps.setTime(4, booking.getFromTime());
        ps.setTime(5, booking.getToTime());
        ps.setInt(6, booking.getCapacity());
        ps.setInt(7, booking.getBookingId());
        
        ps.executeUpdate();
    }
    
    public static void cancelBooking(Connection con, int bookingId) throws SQLException {
        PreparedStatement ps = con.prepareStatement(CANCEL_BOOKING);
        ps.setInt(1, bookingId);
        ps.executeUpdate();
    }
}