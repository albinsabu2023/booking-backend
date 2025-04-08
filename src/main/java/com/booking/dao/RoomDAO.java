package com.booking.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.booking.model.Room;

public class RoomDAO {
    
    /**
     * Retrieves rooms available at the specified time
     * @param connection Database connection
     * @param date Booking date
     * @param startTime Start time
     * @param endTime End time
     * @return List of available Room objects
     */
    public static List<Room> getAvailableRooms(Connection connection, String date, String startTime, String endTime) {
        List<Room> availableRooms = new ArrayList<>();
        
        try {
            String query = "SELECT * FROM Rooms r WHERE r.status = 'active' AND r.roomId NOT IN (SELECT b.roomId FROM Bookings b WHERE b.date = ? AND ((b.fromtime <= ? AND b.totime > ?) OR (b.fromtime < ? AND b.totime >= ?)));";
            		
            
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, date);
            stmt.setString(2, endTime);
            stmt.setString(3, startTime);
            stmt.setString(4, endTime);
            stmt.setString(5, startTime);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
               
                room.setId(rs.getInt("roomId"));
                room.setName(rs.getString("name"));
                room.setLocation(rs.getString("location"));
                room.setCapacity(rs.getInt("capacity"));
                room.setActive(true); // since we filtered by status = 'active'
                room.setSpecifications(rs.getString("specifications"));
                System.out.println(room);
                availableRooms.add(room);
            }
            
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return availableRooms;
    }

    /**
     * Retrieves all rooms from the database
     * @param connection Database connection
     * @return List of Room objects
     */
    public static List<Room> getRooms(Connection connection) {
        List<Room> rooms = new ArrayList<>();
        
        try {
            String query = "SELECT * FROM Rooms";
            PreparedStatement stmt = connection.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("roomId"));
                room.setName(rs.getString("name"));
                room.setLocation(rs.getString("location"));
                room.setCapacity(rs.getInt("capacity"));
                
                // Convert status string to boolean
                String status = rs.getString("status");
                room.setActive("active".equalsIgnoreCase(status));
                
                room.setSpecifications(rs.getString("specifications"));
                
                rooms.add(room);
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Retrieves rooms filtered by location
     * @param connection Database connection
     * @param location Location to filter by
     * @return List of Room objects matching the location
     */
    public static List<Room> getRoomsByLocation(Connection connection, String location) {
        List<Room> rooms = new ArrayList<>();
        
        try {
            String query = "SELECT * FROM Rooms WHERE location = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, location);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("roomId"));
                room.setName(rs.getString("name"));
                room.setLocation(rs.getString("location"));
                room.setCapacity(rs.getInt("capacity"));
                
                // Convert status string to boolean
                String status = rs.getString("status");
                room.setActive("active".equalsIgnoreCase(status));
                
                room.setSpecifications(rs.getString("specifications"));
                
                rooms.add(room);
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Retrieves active/available rooms
     * @param connection Database connection
     * @return List of active Room objects
     */
    public static List<Room> getActiveRooms(Connection connection) {
        List<Room> rooms = new ArrayList<>();
        
        try {
            String query = "SELECT * FROM Rooms WHERE status = 'active'";
            PreparedStatement stmt = connection.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("roomId"));
                room.setName(rs.getString("name"));
                room.setLocation(rs.getString("location"));
                room.setCapacity(rs.getInt("capacity"));
                room.setActive(true);
                room.setSpecifications(rs.getString("specifications"));
                
                rooms.add(room);
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Get room details by ID
     * @param connection Database connection
     * @param roomId Room ID to retrieve
     * @return Room object or null if not found
     */
    public static Room getRoomById(Connection connection, int roomId) {
        Room room = null;
        
        try {
            String query = "SELECT * FROM Rooms WHERE roomId = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                room = new Room();
                room.setId(rs.getInt("roomId"));
                room.setName(rs.getString("name"));
                room.setLocation(rs.getString("location"));
                room.setCapacity(rs.getInt("capacity"));
                
                // Convert status string to boolean
                String status = rs.getString("status");
                room.setActive("active".equalsIgnoreCase(status));
                
                room.setSpecifications(rs.getString("specifications"));
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return room;
    }
    
    /**
     * Get all unique locations from the rooms table
     * @param connection Database connection
     * @return List of location strings
     */
    public static List<String> getAllLocations(Connection connection) {
        List<String> locations = new ArrayList<>();
        
        try {
            String query = "SELECT DISTINCT location FROM Rooms ORDER BY location";
            PreparedStatement stmt = connection.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                locations.add(rs.getString("location"));
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    /**
     * Update the status of a room
     * @param connection Database connection
     * @param roomId Room ID to update
     * @param status New status ('active' or 'under maintenance')
     * @return true if update was successful
     */
    public static boolean updateRoomStatus(Connection connection, int roomId, String status) {
        boolean success = false;
        
        try {
            String query = "UPDATE Rooms SET status = ? WHERE roomId = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, status);
            stmt.setInt(2, roomId);
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return success;
    }
    
    /**
     * Add a new room to the database
     * @param connection Database connection
     * @param room Room object to add
     * @return true if the insert was successful
     */
    public static boolean addRoom(Connection connection, Room room) {
        boolean success = false;
        
        try {
            String query = "INSERT INTO Rooms (name, location, capacity, status, specifications) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, room.getName());
            stmt.setString(2, room.getLocation());
            stmt.setInt(3, room.getCapacity());
            stmt.setString(4, room.isActive() ? "active" : "under maintenance");
            stmt.setString(5, room.getSpecifications());
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return success;
    }
    
    /**
     * Check if a room is available at the specified time
     * @param connection Database connection
     * @param roomId Room ID to check
     * @param date Date to check
     * @param startTime Start time
     * @param endTime End time
     * @return true if the room is available
     */
    public static boolean isRoomAvailable(Connection connection, int roomId, String date, String startTime, String endTime) {
        boolean available = true;
        
        try {
            // This query checks if there are any overlapping bookings
            String query = "SELECT COUNT(*) FROM Bookings WHERE room_id = ? AND booking_date = ? " +
                          "AND ((from_time <= ? AND end_time > ?) OR (from_time < ? AND end_time >= ?))";
            
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, roomId);
            stmt.setString(2, date);
            stmt.setString(3, endTime);
            stmt.setString(4, startTime);
            stmt.setString(5, endTime);
            stmt.setString(6, startTime);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                available = false;
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            available = false;
        }
        
        return available;
    }
}