package com.booking.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.booking.model.Booking;

public class BookingDAO {
    // Existing methods
    
    public static List<Booking> getBookings(Connection con) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings ORDER BY date DESC, fromtime DESC";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapBookingFromResultSet(rs));
            }
        }
        return bookings;
    }
    
    public static List<Booking> getUpcomingBookings(Connection con) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE status = 'upcoming' ORDER BY date, fromtime";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapBookingFromResultSet(rs));
            }
        }
        return bookings;
    }
    
    public static List<Booking> getCancelledBookings(Connection con) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE status = 'cancelled' ORDER BY date DESC, fromtime DESC";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapBookingFromResultSet(rs));
            }
        }
        return bookings;
    }
    
    public static Booking getBookingById(Connection con, int bookingId) throws SQLException {
        String sql = "SELECT * FROM Bookings WHERE booking_id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapBookingFromResultSet(rs);
            }
        }
        return null;
    }
    
    public static void addBooking(Connection con, Booking booking) throws SQLException {
        String sql = "INSERT INTO Bookings (employee_id, roomId, date, fromtime, totime, status, capacity) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getEmployeeId());
            ps.setInt(2, booking.getRoomId());
            ps.setDate(3, booking.getBookDate());
            ps.setTime(4, booking.getFromTime());
            ps.setTime(5, booking.getToTime());
            ps.setString(6, booking.getStatus());
            ps.setInt(7, booking.getCapacity());
            
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                booking.setBookingId(rs.getInt(1));
            }
        }
    }
    
    public static void updateBooking(Connection con, Booking booking) throws SQLException {
        String sql = "UPDATE Bookings SET employee_id = ?, roomId = ?, date = ?, fromtime = ?, totime = ?, status = ?, capacity = ? WHERE booking_id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, booking.getEmployeeId());
            ps.setInt(2, booking.getRoomId());
            ps.setDate(3, booking.getBookDate());
            ps.setTime(4, booking.getFromTime());
            ps.setTime(5, booking.getToTime());
            ps.setString(6, booking.getStatus());
            ps.setInt(7, booking.getCapacity());
            ps.setInt(8, booking.getBookingId());
            
            ps.executeUpdate();
        }
    }
    
    public static void cancelBooking(Connection con, int bookingId) throws SQLException {
        String sql = "UPDATE Bookings SET status = 'cancelled' WHERE booking_id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.executeUpdate();
        }
    }
    
    // Add this new method to check for time slot availability
    public static boolean isTimeSlotAvailable(Connection con, int roomId, Date bookingDate, 
                                             Time startTime, Time endTime) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE roomId = ? AND date = ? AND status = 'upcoming' " +
                     "AND ((fromtime <= ? AND totime > ?) OR (fromtime < ? AND totime >= ?) OR (fromtime >= ? AND totime <= ?))";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, bookingDate);
            ps.setTime(3, endTime);
            ps.setTime(4, startTime);
            ps.setTime(5, endTime);
            ps.setTime(6, startTime);
            ps.setTime(7, startTime);
            ps.setTime(8, endTime);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0; // If count is 0, the slot is available
            }
        }
        return true; // Default to available if query fails
    }
    
    private static Booking mapBookingFromResultSet(ResultSet rs) throws SQLException {
        return new Booking(
            rs.getInt("booking_id"),
            rs.getInt("employee_id"),
            rs.getInt("roomId"),
            rs.getDate("date"),
            rs.getTime("fromtime"),
            rs.getTime("totime"),
            rs.getString("status"),
            rs.getInt("capacity")
        );
    }
    //for preventing double booking
    public static boolean hasExistingBooking(Connection con, int roomId, Date bookDate, Time fromTime) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // Updated column names to match the ones used in other queries
            String query = "SELECT COUNT(*) FROM Bookings WHERE roomId = ? AND date = ? AND fromtime = ? AND status != 'cancelled'";
            ps = con.prepareStatement(query);
            ps.setInt(1, roomId);
            ps.setDate(2, bookDate);
            ps.setTime(3, fromTime);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }

}