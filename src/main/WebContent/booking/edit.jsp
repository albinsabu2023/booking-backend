<%@page import="com.booking.model.Booking"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Booking booking = (Booking) request.getAttribute("booking");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= (booking != null) ? "Edit Booking" : "New Booking" %></title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ffffff;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 40px auto;
            background-color: #f9f9f9;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 30px 40px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }

        input[type="number"],
        input[type="date"],
        input[type="time"],
        select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
            font-size: 14px;
            border-radius: 8px;
            border: none;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn.primary {
            background-color: #007bff;
            color: white;
        }

        .btn.primary:hover {
            background-color: #0056b3;
        }

        .btn {
            background-color: #ddd;
            color: #333;
        }

        .btn:hover {
            background-color: #ccc;
        }

        @media (max-width: 600px) {
            .buttons {
                flex-direction: column;
                gap: 10px;
            }

            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1><%= (booking != null) ? "Edit Booking" : "New Booking" %></h1>

        <form method="post" action="${pageContext.request.contextPath}/bookings/<%= (booking != null) ? "update" : "save" %>" onsubmit="return validateForm()">

            <% if (booking != null) { %>
                <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
            <% } %>

            <div class="form-group">
                <label for="employeeId">Employee ID:</label>
                <input type="number" id="employeeId" name="employeeId"
                       value="<%= (booking != null) ? booking.getEmployeeId() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="roomId">Room ID:</label>
                <input type="number" id="roomId" name="roomId"
                       value="<%= (booking != null) ? booking.getRoomId() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="bookingDate">Booking Date:</label>
                <input type="date" id="bookingDate" name="bookingDate"
                       value="<%= (booking != null) ? booking.getBookDate() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="fromTime">Start Time:</label>
                <input type="time" id="fromTime" name="fromTime"
                       value="<%= (booking != null) ? booking.getFromTime() : "" %>" required onchange="calculateEndTime()">
            </div>

            <div class="form-group">
                <label for="toTime">End Time:</label>
                <input type="time" id="toTime" name="toTime"
                       value="<%= (booking != null) ? booking.getToTime() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="requiredCapacity">Required Capacity:</label>
                <input type="number" id="requiredCapacity" name="requiredCapacity"
                       value="<%= (booking != null) ? booking.getCapacity() : 1 %>" required min="1">
            </div>

            <div class="form-group">
                <label for="status">Status:</label>
                <select id="status" name="status">
                    <%
                        String status = (booking != null) ? booking.getStatus() : "";
                    %>
                    <option value="upcoming" <%= "upcoming".equals(status) ? "selected" : "" %>>Upcoming</option>
                    <option value="completed" <%= "completed".equals(status) ? "selected" : "" %>>Completed</option>
                    <option value="cancelled" <%= "cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                </select>
            </div>

            <div class="buttons">
                <button type="submit" class="btn primary">
                    <%= (booking != null) ? "Update" : "Save" %> Booking
                </button>
                <a href="${pageContext.request.contextPath}/bookings/list" class="btn">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
