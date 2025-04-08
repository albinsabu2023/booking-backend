
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
<title>MeetNspace Dashboard</title>
<style>
<%@include file="book.css"%>
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
				<li class="menu-item " data-tooltip="Dashboard"><span
					class="menu-icon">📊</span> <span class="menu-text">Dashboard</span>
			</li>
			</a>
			<a href="${pageContext.request.contextPath}/bookings">
				<li class="menu-item" data-tooltip="View Bookings"><span
					class="menu-icon">🔍</span> <span class="menu-text">Booking
						History</span></li>
			</a>
			<a href="${pageContext.request.contextPath}/room">
				<li class="menu-item active" data-tooltip="Add Room Details"><span
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
			<!-- Add this right after your content-header div, before the content-body -->
			
			<h3>Book Your Room Now</h3>
			<div>
    <label for="location">Location</label>
    <select name="location" id="location">
        <option value="all-loc" class="loc">All Locations</option>
        <option value="TCS-CENTRE-KOCHI" class="loc">TCS-CENTRE-KOCHI</option>
        <option value="TCS-MUMBAI" class="loc">TCS-MUMBAI</option>
        <option value="TCS-VISMAYA" class="loc">TCS-VISMAYA</option>
        <option value="TCS-CHENAI" class="loc">TCS-CHENAI</option>
    </select>
</div>

			<label class="switch">
				<p>All rooms</p> <input type="checkbox" id="status-filter">
				<span class="slider"></span>
				<p>Active Rooms</p>
			</label>

		</div>
		<div class="content-body">
			<div id="roomList">

				<%
				// Assuming 'rooms' is an ArrayList of room objects available in the request scope
				Connection con = DBConnect.getConnection();
				List<Room> rooms = RoomDAO.getRooms(con);
				if (rooms != null && !rooms.isEmpty()) {
					for (Room room : rooms) {
				%>
				<div class="room-card" data-room-id="<%=room.getId()%>"
					data-location="<%=room.getLocation()%>"
					data-active="<%=room.isActive()%>">
					<div class="room-header">
						<h4><%=room.getName()%></h4>
						<span
							class="room-status <%=room.isActive() ? "active" : "inactive"%>">
							<%=room.isActive() ? "Available" : "Unavailable"%>
						</span>
					</div>
					<div class="room-details">
						<div class="room-info">
							<p>
								<strong>Location:</strong>
								<%=room.getLocation()%></p>
							<p>
								<strong>Capacity:</strong>
								<%=room.getCapacity()%>
								persons
							</p>
							<p>
								<strong>Features:</strong>
								<%=room.getSpecifications()%></p>
						</div>
						<%-- <div class="room-image">
							<img src="/resources/images/rooms/<%=room.getImageUrl()%>"
								alt="<%=room.getName()%>">
						</div> --%>
					</div>
					<div class="room-footer">
						<button class="book-btn" id="book-btn"
							style="<%=room.isActive() ? "display:hidden" : "display:block"%>"
							onclick="openBookingModal(<%=room.getId()%>, '<%=room.getName()%>', '<%=room.getLocation()%>', <%=room.getCapacity()%>)">
							Book Now</button>
					</div>
				</div>
				<%
				}
				} else {
				%>
				<div class="no-rooms">
					<p>No rooms available. Please try another location or check
						back later.</p>
				</div>
				<%
				}
				%>
			</div>
		</div>

		<!-- for booking each room -->
		<form action="${pageContext.request.contextPath}/bookingst/save" method="post">
			<div id="bookingModal" class="booking-modal">
				<h3>Book Room</h3>
				<input type="hidden" id="bookIndex" name="roomId" value="">
				<div class="booking-id" id="bookingIdDisplay"></div>

				<div class="form-item">
					<label>Room Name:</label> <input type="text" id="bookRoomName"
						readonly> <label>Location:</label> <input type="text"
						id="bookLocation" readonly>
						
				</div>

				<div class="form-item">
					<label>Max Capacity:</label> <input type="text"
						id="bookMaxCapacity" readonly> <label>Required
						Capacity:</label> <input type="number" id="bookCapacity" min="1"
						name="requiredCapacity">
				</div>

				<div class="form-item">
					<label>Select Date:</label> <input type="date" id="bookDate"
						name="bookingDate"> <label>From Time:</label> <select
						id="bookFromTime" name="fromTime">
						<option value="9:00 AM">9:00 AM</option>
						<option value="11:00 AM">11:00 AM</option>
						<option value="1:00 PM">1:00 PM</option>
						<option value="3:00 PM">3:00 PM</option>
					</select>
				</div>

				<div class="form-item">
					<label>Duration:</label> <select id="bookDuration" name="duration">
						<option value="1">1 hour</option>
						<option value="1.5">1.5 hours</option>
						<option value="2">2 hours</option>
						<option value="2.5">2.5 hours</option>
						<option value="3">3 hours</option>
					</select> <label>End Time:</label> <input type="text" id="bookEndTime"
						readonly name="endTime">
				</div>
				<div class="checkbox-container">
					<input type="checkbox" id="snacksRequired" name="snacksRequired">
					<label for="snacksRequired">Snacks Required</label>
				</div>

				<button id="saveBooking" type="submit">Confirm Booking</button>
				<button id="closeBooking">Cancel</button>
			</div>
		</form>
		<!-- Popup message div -->
		<div class="overlay" id="overlay"></div>
		<div class="popup" id="popup">
			<div class="popup-content" id="popup-content">
				<!-- Message content would be added dynamically -->
			</div>
			<button class="popup-close" id="popup-close">OK</button>
		</div>

	</div>

	<script>
    // Get elements
    document.addEventListener("DOMContentLoaded", function () {
        let today = new Date().toISOString().split("T")[0];
        document.getElementById("bookDate").setAttribute("min", today);
        
        // Success and error messages would be handled by JavaScript
    });
    
    const sidebar = document.getElementById('sidebar');
    const content = document.getElementById('content');
    const toggleBtn = document.getElementById('toggleSidebar');
    const mobileToggle = document.getElementById('mobileToggle');
    const menuItems = document.querySelectorAll('.menu-item');
    
    // Toggle sidebar
    toggleBtn.addEventListener('click', () => {
      sidebar.classList.toggle('collapsed');
      content.classList.toggle('expanded');
    });
    
    // Mobile toggle
    mobileToggle.addEventListener('click', () => {
      sidebar.classList.toggle('mobile-open');
    });
    
    // Add click event to menu items
    menuItems.forEach(item => {
      item.addEventListener('click', function() {
        // Remove active class from all menu items
        menuItems.forEach(item => item.classList.remove('active'));
        
        // Add active class to clicked item
        this.classList.add('active');
        
        // Close sidebar on mobile after clicking
        if (window.innerWidth <= 768) {
          sidebar.classList.remove('mobile-open');
        }
      });
    });
    
    // Handle window resize
    window.addEventListener('resize', () => {
      if (window.innerWidth <= 768) {
        sidebar.classList.remove('collapsed');
        content.classList.remove('expanded');
      }
    });
    
    
    function showPopup(message) {
      document.getElementById("popup-content").textContent = message;
      document.getElementById("overlay").style.display = "block";
      document.getElementById("popup").style.display = "block";
    }
    let bookingModal=document.getElementById("bookingModal");
    
   function openBookingModal(id,name,location,capacity){
	   console.log(id,name,location);
	   bookingModal.style.display="block";
	   document.getElementById("bookRoomName").value = name;
	    document.getElementById("bookLocation").value = location;
	    document.getElementById("bookMaxCapacity").value = capacity;
   }
   document.getElementById("closeBooking")
   .addEventListener("click", function () {
     document.getElementById("bookingModal").style.display = "none";
     
   });
   	
   		//code for updating the endTime before submission
    
   		const bookDurationSelect = document.getElementById("bookDuration");
		const bookFromTimeSelect = document.getElementById("bookFromTime");
		const bookEndTimeInput = document.getElementById("bookEndTime");
    
		function updateEndTime() {
		    const fromTime = bookFromTimeSelect.value;
		    const duration = bookDurationSelect.value;
		    bookEndTimeInput.value = calculateEndTime(fromTime, duration);
		}
		
		function calculateEndTime(fromTime, duration) {
		   const timeMap = {
		     "9:00 AM": 9,
		     "11:00 AM": 11,
		     "1:00 PM": 13,
		     "3:00 PM": 15,
		   };

		   let startHour = timeMap[fromTime];
		   let durationFloat = parseFloat(duration);

		   // Calculate total hours and minutes
		   let totalHours = Math.floor(startHour + durationFloat);
		   let totalMinutes = (durationFloat % 1) * 60;

		   // Format time
		   let period = totalHours >= 12 ? "PM" : "AM";
		   let formattedHour = totalHours > 12 ? totalHours - 12 : totalHours;
		   formattedHour = formattedHour === 0 ? 12 : formattedHour; // Handle 12 AM/PM
		   let formattedMinutes = totalMinutes > 0 ? ":" + totalMinutes : ":00";

		   return `${formattedHour}${formattedMinutes} ${period}`;
		 }
   		  
		
		// checking requested capacity greater than actual capacity
		  const maxCapacity = parseInt(document.getElementById("bookMaxCapacity").value);
    	  const requestedCapacity = parseInt(document.getElementById("bookCapacity").value);
    	  
    	  
    	  
      //popu showing and closing function
       const popup = document.getElementById("popup");
  const popupContent = document.getElementById("popup-content");
  const popupClose = document.getElementById("popup-close");
  const overlay = document.getElementById("overlay");
      function showPopup(message, isError = false) {
    popupContent.textContent = message;
    popup.className = "popup " + (isError ? "popup-error" : "popup-success");
    popup.style.display = "block";
    overlay.style.display = "block";
  }

  // Close popup event
  popupClose.addEventListener("click", function () {
    popup.style.display = "none";
    overlay.style.display = "none";
  });
	
  </script>

</body>
</html>