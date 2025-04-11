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
        #popup-cancel{
          color:black;
          background-color:red;
        }
        #popup-confirm{
          color:black;
          background-color:green;
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
                                <a href="#" class="action-btn cancel-btn" onclick="event.preventDefault(); showPopup('Do you want to cancel?', function() { window.location.href='${pageContext.request.contextPath}/bookings/cancel?id=<%= booking.getBookingId() %>'; });">Cancel</a>
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
        <div class="overlay" id="overlay" style="display: none;"></div>
<div class="popup" id="popup" style="display: none;">
    <div class="popup-content" id="popup-content"></div>
    <div style="text-align: right; margin-top: 10px;">
        <button class="popup-close" id="popup-confirm">OK</button>
        <button class="popup-close" id="popup-cancel">Cancel</button>
    </div>
</div>
        
    </div>

    <script>
    const overlay = document.getElementById('overlay');
    const popupBox = document.getElementById('popup');
    const popupContent = document.getElementById('popup-content');
    const confirmBtn = document.getElementById('popup-confirm');
    const cancelBtn = document.getElementById('popup-cancel');

    function showPopup(message, onConfirm) {
        popupContent.innerText = message;
        overlay.style.display = 'block';
        popupBox.style.display = 'block';

        // Remove previous event listener
        confirmBtn.onclick = function () {
            hidePopup();
            if (typeof onConfirm === 'function') {
                onConfirm();
            }
        };

        cancelBtn.onclick = hidePopup;
    }

    function hidePopup() {
        overlay.style.display = 'none';
        popupBox.style.display = 'none';
    }

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
     // Add this code to your existing script section in bookings_list.jsp

        document.addEventListener("DOMContentLoaded", function() {
            // Get the search form and input
            const searchForm = document.querySelector(".search-form");
            const searchInput = searchForm.querySelector("input[name='bookingId']");
            
            // Add event listener for form submission
            searchForm.addEventListener("submit", function(event) {
                // Prevent the default form submission
                event.preventDefault();
                
                // Get the search term and convert to lowercase for case-insensitive comparison
                const searchTerm = searchInput.value.trim().toLowerCase();
                
                // Get all booking rows in the table (excluding the header row)
                const bookingRows = document.querySelectorAll(".booking-table tbody tr");
                
                // Variable to track if any matches were found
                let matchesFound = false;
                
                // Loop through each row
                bookingRows.forEach(row => {
                    // Get the booking ID cell (first column)
                    const bookingIdCell = row.querySelector("td:first-child");
                    
                    if (bookingIdCell) {
                        const bookingId = bookingIdCell.textContent.trim().toLowerCase();
                        
                        // Check if the booking ID contains the search term
                        if (bookingId.includes(searchTerm)) {
                            row.style.display = ""; // Show the row
                            matchesFound = true;
                        } else {
                            row.style.display = "none"; // Hide the row
                        }
                    }
                });
                
                // Show a message if no matches were found
                const noResultsRow = document.querySelector(".no-results-row");
                
                if (!matchesFound) {
                    if (!noResultsRow) {
                        // Create a new row for the "no results" message
                        const tbody = document.querySelector(".booking-table tbody");
                        const newRow = document.createElement("tr");
                        newRow.className = "no-results-row";
                        newRow.innerHTML = `<td colspan="8" style="text-align: center;">No bookings found with ID containing "${searchTerm}"</td>`;
                        tbody.appendChild(newRow);
                    } else {
                        noResultsRow.style.display = ""; // Show the existing "no results" row
                        noResultsRow.querySelector("td").textContent = `No bookings found with ID containing "${searchTerm}"`;
                    }
                } else if (noResultsRow) {
                    noResultsRow.style.display = "none"; // Hide the "no results" row if matches were found
                }
            });
            
            // Add a reset button to clear the search
            const searchContainer = document.querySelector(".search-container");
            const resetButton = document.createElement("button");
            resetButton.textContent = "Reset";
            resetButton.className = "reset-btn";
            resetButton.style.marginLeft = "10px";
            resetButton.style.padding = "8px 15px";
            resetButton.style.backgroundColor = "#6c757d";
            resetButton.style.color = "white";
            resetButton.style.border = "none";
            resetButton.style.borderRadius = "4px";
            resetButton.style.cursor = "pointer";
            
            searchContainer.querySelector("div").appendChild(resetButton);
            
            // Add event listener for reset button
            resetButton.addEventListener("click", function() {
                searchInput.value = ""; // Clear the search input
                
                // Show all rows
                const bookingRows = document.querySelectorAll(".booking-table tbody tr");
                bookingRows.forEach(row => {
                    if (!row.classList.contains("no-results-row")) {
                        row.style.display = ""; // Show all normal rows
                    }
                });
                
                // Hide the "no results" row if it exists
                const noResultsRow = document.querySelector(".no-results-row");
                if (noResultsRow) {
                    noResultsRow.style.display = "none";
                }
            });
            
            // Add an event listener for real-time filtering (optional)
            searchInput.addEventListener("input", function() {
                // Trigger form submission for real-time filtering
                if (this.value.trim().length >= 2 || this.value.trim().length === 0) {
                    const event = new Event("submit", { cancelable: true });
                    searchForm.dispatchEvent(event);
                }
            });
        });
    </script>
</body>
</html>