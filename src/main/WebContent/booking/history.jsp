<%@page import="com.booking.dbconnect.DBConnect"%>
<%@page import="com.booking.dao.*"%>
<%@page import="com.booking.model.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>MeetNspace - Booking History</title>
    <style><%@ include file="book.css" %></style>
    <style>
        .tab-navigation {
            display: flex;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }
        
        .tab-link {
            padding: 10px 20px;
            margin-right: 5px;
            cursor: pointer;
            border: 1px solid #ddd;
            border-bottom: none;
            background-color: #f1f1f1;
            border-radius: 5px 5px 0 0;
            text-decoration: none;
            color: #333;
        }
        
        .tab-link.active {
            background-color: #4CAF50;
            color: white;
        }
        
        .booking-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .booking-table th, .booking-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        
        .booking-table th {
            background-color: #f2f2f2;
            color: #333;
        }
        
        .booking-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .action-btn {
            padding: 5px 10px;
            margin-right: 5px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        
        .edit-btn {
            background-color: #2196F3;
            color: white;
        }
        
        .cancel-btn {
            background-color: #f44336;
            color: white;
        }
        
        .status-active {
            color: green;
            font-weight: bold;
        }
        
        .status-cancelled {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-title">meetNspace</div>
            <button class="toggle-btn" id="toggleSidebar">≡</button>
        </div>

        <ul class="menu-list">
            <a href="/dashboard">
                <li class="menu-item" data-tooltip="Dashboard"><span
                    class="menu-icon">📊</span> <span class="menu-text">Dashboard</span>
                </li>
            </a>
            <a href="${pageContext.request.contextPath}/bookings/list">
                <li class="menu-item active" data-tooltip="View Bookings"><span
                    class="menu-icon">🔍</span> <span class="menu-text">Booking
                        History</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/bookings/add">
                <li class="menu-item" data-tooltip="Add Room Details"><span
                    class="menu-icon">➕</span> <span class="menu-text">Create
                        Booking</span></li>
            </a>
            <a href="/feedback">
                <li class="menu-item" data-tooltip="Feedbacks"><span
                    class="menu-icon">📝</span> <span class="menu-text">Feedbacks</span>
                </li>
            </a>
            <div class="divider"></div>
            <a href="/profile">
                <li class="menu-item" data-tooltip="Profile"><span
                    class="menu-icon">👤</span> <span class="menu-text">Profile</span>
                </li>
            </a>

            <div class="divider"></div>
            <a href="/logout">
                <li class="menu-item" data-tooltip="Logout"><span
                    class="menu-icon">↩️</span> <span class="menu-text">Logout</span></li>
            </a>
        </ul>
    </div>

    <button class="mobile-toggle" id="mobileToggle">☰</button>

    <div class="content" id="content">
        <div class="content-header">
            <h3>Booking History</h3>
        </div>
        <div class="search-container" style="margin-bottom: 20px;">
				<form action="${pageContext.request.contextPath}/bookings/search"
					method="get" class="search-form">
					<div style="display: flex; max-width: 500px;">
						<input type="text" name="bookingId"
							placeholder="Search by Booking ID..."
							style="flex: 1; padding: 8px; border: 1px solid #ddd; border-radius: 4px 0 0 4px;">
						<button type="submit"
							style="background-color: #4CAF50; color: white; padding: 8px 15px; border: none; border-radius: 0 4px 4px 0; cursor: pointer;">
							Search</button>
					</div>
				</form>
			</div>
        <div class="content-body">
            <!-- Tab Navigation -->
            <div class="tab-navigation">
                <a href="${pageContext.request.contextPath}/bookings/list" class="tab-link <%= request.getAttribute("listType") == null ? "active" : "" %>">All Bookings</a>
                <a href="${pageContext.request.contextPath}/bookings/upcoming" class="tab-link <%= "upcoming".equals(request.getAttribute("listType")) ? "active" : "" %>">Upcoming</a>
                <a href="${pageContext.request.contextPath}/bookings/cancelled" class="tab-link <%= "cancelled".equals(request.getAttribute("listType")) ? "active" : "" %>">Cancelled</a>
            </div>
            
            <!-- Booking Table -->
            <table class="booking-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Room ID</th>
                        <th>Date</th>
                        <th>From Time</th>
                        <th>To Time</th>
                        <th>Capacity</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                    if (bookings != null && !bookings.isEmpty()) {
                        for (Booking booking : bookings) {
                    %>
                    <tr>
                        <td><%= booking.getBookingId() %></td>
                        <td><%= booking.getRoomId() %></td>
                        <td><%= booking.getBookDate() %></td>
                        <td><%= booking.getFromTime() %></td>
                        <td><%= booking.getToTime() %></td>
                        <td><%= booking.getCapacity() %></td>
                        <td class="status-<%= booking.getStatus().toLowerCase() %>"><%= booking.getStatus() %></td>
                        <td>
                            <% if (!"Cancelled".equals(booking.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/bookings/edit?id=<%= booking.getBookingId() %>" class="action-btn edit-btn">Edit</a>
                                <a href="${pageContext.request.contextPath}/bookings/cancel?id=<%= booking.getBookingId() %>" class="action-btn cancel-btn" onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel</a>
                            <% } else { %>
                                <span>No actions available</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" style="text-align: center;">No bookings found</td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Toggle sidebar functionality
        document.addEventListener("DOMContentLoaded", function () {
            const sidebar = document.getElementById('sidebar');
            const content = document.getElementById('content');
            const toggleBtn = document.getElementById('toggleSidebar');
            const mobileToggle = document.getElementById('mobileToggle');
            
            // Toggle sidebar
            toggleBtn.addEventListener('click', () => {
                sidebar.classList.toggle('collapsed');
                content.classList.toggle('expanded');
            });
            
            // Mobile toggle
            mobileToggle.addEventListener('click', () => {
                sidebar.classList.toggle('mobile-open');
            });
        });
    </script>
</body>
</html>