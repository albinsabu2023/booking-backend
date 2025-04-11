package com.booking.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

import com.booking.dao.BookingDAO;
import com.booking.dao.RoomDAO;
import com.booking.dbconnect.DBConnect;
import com.booking.model.Booking;
import com.booking.model.Room;

@WebServlet("/bookings/*")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
   
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        Connection con = DBConnect.getConnection();
        
        try {
            if(action == null || action.equals("/")) {
                // Default action - redirect to list
                response.sendRedirect(request.getContextPath() + "/bookings/list");
            } else if(action.equals("/list")) {
                List<Booking> bookings = BookingDAO.getBookings(con);
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/booking/history.jsp").forward(request, response);
            } else if(action.equals("/upcoming")) {
                List<Booking> upcomingBookings = BookingDAO.getUpcomingBookings(con);
                request.setAttribute("bookings", upcomingBookings);
                request.setAttribute("listType", "upcoming");
                request.getRequestDispatcher("/booking/history.jsp").forward(request, response);
            } else if(action.equals("/cancelled")) {
                List<Booking> cancelledBookings = BookingDAO.getCancelledBookings(con);
                request.setAttribute("bookings", cancelledBookings);
                request.setAttribute("listType", "cancelled");
                request.getRequestDispatcher("/booking/history.jsp").forward(request, response);
            } else if(action.equals("/add")) {
                response.sendRedirect(request.getContextPath() + "/booking/book.jsp");
            } else if(action.equals("/preview")) {
                response.sendRedirect(request.getContextPath() + "/booking/preview.jsp");
            } else if(action.equals("/edit")) {
                int bookingId = Integer.parseInt(request.getParameter("id"));
                Booking booking = BookingDAO.getBookingById(con, bookingId);
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/booking/edit.jsp").forward(request, response);
            } else if(action.equals("/cancel")) {
                int bookingId = Integer.parseInt(request.getParameter("id"));
                BookingDAO.cancelBooking(con, bookingId);
                response.sendRedirect(request.getContextPath() + "/bookings/list");
            }  else if(action.equals("/check-availability")) {
                response.setContentType("text/plain");
                
                try {
                    // Validate parameters
                    String roomIdStr = request.getParameter("roomId");
                    String dateStr = request.getParameter("date");
                    String fromTimeStr = request.getParameter("fromTime");
                    String durationStr = request.getParameter("duration");
                    
                    // Check if any parameters are missing
                    if (roomIdStr == null || dateStr == null || fromTimeStr == null || durationStr == null) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Missing required parameters");
                        return;
                    }
                    
                    // Parse parameters with proper error handling
                    int roomId;
                    try {
                        roomId = Integer.parseInt(roomIdStr);
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Invalid room ID format");
                        return;
                    }
                    
                    Date bookDate;
                    try {
                        bookDate = Date.valueOf(dateStr);
                    } catch (IllegalArgumentException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Invalid date format. Use YYYY-MM-DD");
                        return;
                    }
                    
                    Time fromTime;
                    try {
                        fromTime = Time.valueOf(convertTo24HourFormat(fromTimeStr));
                    } catch (Exception e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Invalid from time format");
                        return;
                    }
                    
                    double durationHours;
                    try {
                        durationHours = Double.parseDouble(durationStr);
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Invalid duration format");
                        return;
                    }
                    
                    // Calculate end time based on from time and duration
                    int durationMillis = (int)(durationHours * 60 * 60 * 1000);
                    Time toTime = new Time(fromTime.getTime() + durationMillis);
                    
                    // Check availability
                    boolean isAvailable = BookingDAO.isTimeSlotAvailable(con, roomId, bookDate, fromTime, toTime);
                    
                    response.getWriter().write(isAvailable ? "available" : "unavailable");
                } catch (Exception e) {
                    // Log the exception
                    e.printStackTrace();
                    
                    // Return a generic error response
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("Server error checking availability");
                }
            }else {
                System.out.println("No matching route for: " + action);
                response.sendRedirect(request.getContextPath() + "/bookings/list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        Connection con = DBConnect.getConnection();
        HttpSession session = request.getSession(false);
        
        try {
            if (action.equals("/save")) {
                // Get parameters from form
            	
            	
            	
                int employeeId = session != null && session.getAttribute("employeeId") != null ? 
                    (Integer)session.getAttribute("employeeId") : 2; // Default to 200 if not logged in
                    
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                String dateStr = request.getParameter("bookingDate");
                Date bookDate = Date.valueOf(dateStr);
                
                String fromTimeStr = request.getParameter("fromTime");
                double duration = Double.parseDouble(request.getParameter("duration"));
                
                // Calculate end time
                Time fromTime = Time.valueOf(convertTo24HourFormat(fromTimeStr));
                int durationMillis = (int)(duration * 60 * 60 * 1000);
                Time toTime = new Time(fromTime.getTime() + durationMillis);
                
                int capacity = Integer.parseInt(request.getParameter("requiredCapacity"));
                
                // First check if the time slot is available
                boolean alreadyBooked = BookingDAO.hasExistingBooking(con, roomId, bookDate, fromTime);

                if (alreadyBooked) {
                    // If the slot is already booked, send back an error
                    request.setAttribute("error", "This time slot is already booked. Please choose another time.");
                    request.setAttribute("roomId", roomId);
                    
                    // Get room details for redisplay
                    Room room = RoomDAO.getRoomById(con, roomId);
                    request.setAttribute("room", room);
                    
                    // Forward back to the booking form
                    request.getRequestDispatcher("/booking/book.jsp").forward(request, response);
                    return;
                }
                
                // Time slot is available, create new booking
                Booking booking = new Booking(0, employeeId, roomId, bookDate, fromTime, toTime, "upcoming", capacity);
                BookingDAO.addBooking(con, booking);
                
                // Set success message
                if (session != null) {
                    session.setAttribute("successMessage", "Booking confirmed successfully!");
                }
                
                response.sendRedirect(request.getContextPath() + "/bookings/preview");
            } else if (action.equals("/update")) {
                // Get parameters from form
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                String dateStr = request.getParameter("bookingDate");
                Date bookDate = Date.valueOf(dateStr);
                
                String fromTimeStr = request.getParameter("fromTime");
                String toTimeStr = request.getParameter("toTime");
                
                Time fromTime = Time.valueOf(convertTo24HourFormat(fromTimeStr));
                Time toTime = Time.valueOf(convertTo24HourFormat(toTimeStr));
                int capacity = Integer.parseInt(request.getParameter("requiredCapacity"));
                String status = request.getParameter("status");
                
                // If status not provided, keep it as "upcoming"
                if (status == null || status.isEmpty()) {
                    status = "upcoming";
                }
                
                // Get the original booking to check if times have changed
                Booking originalBooking = BookingDAO.getBookingById(con, bookingId);
                boolean needsAvailabilityCheck = 
                    !originalBooking.getBookDate().equals(bookDate) ||
                    !originalBooking.getFromTime().equals(fromTime) ||
                    !originalBooking.getToTime().equals(toTime);
                
                // Only check availability if the booking details have changed
                if (needsAvailabilityCheck) {
                    boolean isAvailable = BookingDAO.isTimeSlotAvailable(con, roomId, bookDate, fromTime, toTime);
                    
                    if (!isAvailable) {
                        // If not available, send back an error
                        request.setAttribute("error", "The selected time slot is not available. Please choose another time.");
                        request.setAttribute("booking", originalBooking);
                        request.getRequestDispatcher("/booking/edit.jsp").forward(request, response);
                        return;
                    }
                }
                
                // Time slot is available or unchanged, update the booking
                Booking booking = new Booking(bookingId, employeeId, roomId, bookDate, fromTime, toTime, status, capacity);
                BookingDAO.updateBooking(con, booking);
                
                // Set success message
                if (session != null) {
                    session.setAttribute("successMessage", "Booking updated successfully!");
                }
                
                response.sendRedirect(request.getContextPath() + "/bookings/list");
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // Helper method to convert time from 12-hour format to 24-hour format for SQL
    public static String convertTo24HourFormat(String time12Hour) {
        try {
            // Handle null or empty strings
            if (time12Hour == null || time12Hour.trim().isEmpty()) {
                throw new IllegalArgumentException("Time value cannot be empty");
            }
            
            // If already in 24-hour format (e.g., "14:00" or "14:00:00")
            if (time12Hour.matches("\\d{1,2}:\\d{2}(:\\d{2})?")) {
                // Ensure the format has a leading zero if needed
                String[] parts = time12Hour.split(":");
                int hours = Integer.parseInt(parts[0]);
                int minutes = Integer.parseInt(parts[1]);
                
                // Return in proper SQL time format (HH:mm:ss)
                if (parts.length == 3) {
                    return String.format("%02d:%02d:%02d", hours, minutes, Integer.parseInt(parts[2]));
                } else {
                    return String.format("%02d:%02d:00", hours, minutes);
                }
            }

            // Parse the 12-hour format and convert to 24-hour
            SimpleDateFormat inputFormat = new SimpleDateFormat("h:mm a", Locale.ENGLISH);
            SimpleDateFormat outputFormat = new SimpleDateFormat("HH:mm:ss");
            
            return outputFormat.format(inputFormat.parse(time12Hour.trim()));
        } catch (ParseException e) {
            e.printStackTrace();
            throw new IllegalArgumentException("Invalid time format: " + time12Hour);
        }
    }
}