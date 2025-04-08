<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script>
        function calculateEndTime() {
            const fromTimeInput = document.getElementById('fromTime');
            const durationInput = document.getElementById('duration');
            const toTimeInput = document.getElementById('toTime');

            if (fromTimeInput.value && durationInput.value) {
                const fromTime = fromTimeInput.value;
                const durationMinutes = parseInt(durationInput.value);

                let [hours, minutes] = fromTime.split(':').map(Number);

                minutes += durationMinutes;
                hours += Math.floor(minutes / 60);
                minutes = minutes % 60;

                const formattedHours = hours.toString().padStart(2, '0');
                const formattedMinutes = minutes.toString().padStart(2, '0');

                toTimeInput.value = `${formattedHours}:${formattedMinutes}`;
            }
        }

        window.onload = function() {
            const fromTimeInput = document.getElementById('fromTime');
            const toTimeInput = document.getElementById('toTime');
            const durationInput = document.getElementById('duration');

            if (fromTimeInput.value && toTimeInput.value) {
                const [fromHours, fromMinutes] = fromTimeInput.value.split(':').map(Number);
                const [toHours, toMinutes] = toTimeInput.value.split(':').map(Number);

                let durationMinutes = (toHours * 60 + toMinutes) - (fromHours * 60 + fromMinutes);
                if (durationMinutes < 0) {
                    durationMinutes += 1440;
                }

                durationInput.value = durationMinutes;
            }
        };
    </script>
</head>
<body>
    <div class="container">
        <h1>
            <c:choose>
                <c:when test="${not empty booking}">
                    Edit Booking
                </c:when>
                <c:otherwise>
                    New Booking
                </c:otherwise>
            </c:choose>
        </h1>

        <form method="post" action="${pageContext.request.contextPath}/bookings/<c:out value='${not empty booking ? "update" : "save"}'/>">
            
            <c:if test="${not empty booking}">
                <input type="hidden" name="bookingId" value="${booking.id}" />
            </c:if>

            <div class="form-group">
                <label for="employeeId">Employee ID:</label>
                <input type="number" id="employeeId" name="employeeId" value="${not empty booking ? booking.employeeId : ''}" required>
            </div>

            <div class="form-group">
                <label for="roomId">Room ID:</label>
                <input type="number" id="roomId" name="roomId" value="${not empty booking ? booking.roomId : ''}" required>
            </div>

            <div class="form-group">
                <label for="bookingDate">Booking Date:</label>
                <input type="date" id="bookingDate" name="bookingDate" value="${not empty booking ? booking.bookingDate : ''}" required>
            </div>

            <div class="form-group">
                <label for="fromTime">Start Time:</label>
                <input type="time" id="fromTime" name="fromTime" value="${not empty booking ? booking.fromTime : ''}" required onchange="calculateEndTime()">
            </div>

            <div class="form-group">
                <label for="duration">Duration (minutes):</label>
                <input type="number" id="duration" name="duration" min="15" step="15"
                       value="${not empty booking ? booking.duration : 60}" onchange="calculateEndTime()">
            </div>

            <div class="form-group">
                <label for="toTime">End Time:</label>
                <input type="time" id="toTime" name="toTime" value="${not empty booking ? booking.toTime : ''}" required>
            </div>

            <div class="form-group">
                <label for="requiredCapacity">Required Capacity:</label>
                <input type="number" id="requiredCapacity" name="requiredCapacity"
                       value="${not empty booking ? booking.requiredCapacity : 1}" required min="1">
            </div>

            <div class="form-group">
                <label for="status">Status:</label>
                <select id="status" name="status">
                    <option value="upcoming" <c:if test="${booking.status == 'upcoming'}">selected</c:if>>Upcoming</option>
                    <option value="completed" <c:if test="${booking.status == 'completed'}">selected</c:if>>Completed</option>
                    <option value="cancelled" <c:if test="${booking.status == 'cancelled'}">selected</c:if>>Cancelled</option>
                </select>
            </div>

            <div class="buttons">
                <button type="submit" class="btn primary">
                    <c:out value="${not empty booking ? 'Update' : 'Save'}" /> Booking
                </button>
                <a href="${pageContext.request.contextPath}/bookings/list" class="btn">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
