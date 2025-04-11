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
		<form action="${pageContext.request.contextPath}/bookings/save" method="post">
			<div id="bookingModal" class="booking-modal">
				<h3>Book Room</h3>
				<input type="hidden" id="roomId" name="roomId" value="">
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
				<!-- Add this just above the "Confirm Booking" button in your form -->
<div class="validation-summary" id="validationSummary">
  <!-- Validation messages will be added here dynamically -->
</div>
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
	   document.getElementById("roomId").value = id;
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
		   l
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
	
  
  //-------------------
  // Add this code to your existing script section in book.jsp

document.addEventListener("DOMContentLoaded", function() {
  // Get all the necessary form elements
  const bookForm = document.querySelector("form[action*='bookings/save']");
  const maxCapacityInput = document.getElementById("bookMaxCapacity");
  const requestedCapacityInput = document.getElementById("bookCapacity");
  const bookDateInput = document.getElementById("bookDate");
  const bookDurationSelect = document.getElementById("bookDuration");
  const bookFromTimeSelect = document.getElementById("bookFromTime");
  const bookEndTimeInput = document.getElementById("bookEndTime");
  const saveBookingBtn = document.getElementById("saveBooking");

  // Function to create or update validation message
  function showValidationMessage(inputElement, message, isError = true) {
    // Remove any existing validation message for this input
    const existingMessage = inputElement.parentElement.querySelector(".validation-message");
    if (existingMessage) {
      existingMessage.remove();
    }
    
    // Only create a message if one is provided
    if (message) {
      const messageElement = document.createElement("div");
      messageElement.className = isError ? "validation-message error" : "validation-message success";
      messageElement.textContent = message;
      inputElement.parentElement.appendChild(messageElement);
      return messageElement;
    }
    return null;
  }

  // Function to validate capacity
  function validateCapacity() {
    const maxCapacity = parseInt(maxCapacityInput.value);
    const requestedCapacity = parseInt(requestedCapacityInput.value);
    
    // Remove any existing validation messages
    showValidationMessage(requestedCapacityInput, "");
    
    // Check if capacity is empty
    if (!requestedCapacity) {
      showValidationMessage(requestedCapacityInput, "Capacity is required");
      return false;
    }
    
    // Check if requested capacity exceeds max capacity
    if (requestedCapacity > maxCapacity) {
      showValidationMessage(requestedCapacityInput, `Requested capacity exceeds maximum capacity of ${maxCapacity}`);
      return false;
    }
    
    // Check if requested capacity is less than or equal to 0
    if (requestedCapacity <= 0) {
      showValidationMessage(requestedCapacityInput, "Capacity must be greater than zero");
      return false;
    }
    
    // If all checks pass, show success message
    showValidationMessage(requestedCapacityInput, "Valid capacity", false);
    return true;
  }

  // Function to validate booking date
  function validateDate() {
    const selectedDate = bookDateInput.value;
    
    // Remove any existing validation messages
    showValidationMessage(bookDateInput, "");
    
    // Check if date is selected
    if (!selectedDate) {
      showValidationMessage(bookDateInput, "Please select a date");
      return false;
    }
    
    // Check if selected date is not in the past
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const bookingDate = new Date(selectedDate);
    
    if (bookingDate < today) {
      showValidationMessage(bookDateInput, "Cannot book for past dates");
      return false;
    }
    
    return true;
  }

  // Update end time when duration or start time changes
  function updateEndTime() {
    const fromTime = bookFromTimeSelect.value;
    const duration = bookDurationSelect.value;
    bookEndTimeInput.value = calculateEndTime(fromTime, duration);
    
    // Show a success message to confirm the update
    showValidationMessage(bookEndTimeInput, `End time updated to ${bookEndTimeInput.value}`, false);
    
    // Hide the message after 2 seconds
    setTimeout(() => {
      showValidationMessage(bookEndTimeInput, "");
    }, 2000);
  }

  // Calculate end time based on start time and duration
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

  // Validate all fields before form submission
  function validateForm(event) {
    // Check each validation function
    const isCapacityValid = validateCapacity();
    const isDateValid = validateDate();
    
    // If any validation fails, prevent form submission
    if (!isCapacityValid || !isDateValid) {
      event.preventDefault();
      return false;
    }
    
    return true;
  }

  // Add event listeners
  if (requestedCapacityInput) {
    requestedCapacityInput.addEventListener("input", validateCapacity);
    requestedCapacityInput.addEventListener("change", validateCapacity);
  }
  
  if (bookDateInput) {
    bookDateInput.addEventListener("change", validateDate);
  }
  
  if (bookDurationSelect && bookFromTimeSelect) {
    bookDurationSelect.addEventListener("change", updateEndTime);
    bookFromTimeSelect.addEventListener("change", updateEndTime);
  }
  
  // Add form submission event listener
  if (bookForm) {
    bookForm.addEventListener("submit", validateForm);
  }
  
  // Initialize the end time when the page loads
  if (bookDurationSelect && bookFromTimeSelect && bookEndTimeInput) {
    updateEndTime();
  }
});
//Add this code to your existing script section in book.jsp

document.addEventListener("DOMContentLoaded", function() {
  // Get the status filter checkbox and location dropdown
  const statusFilterCheckbox = document.getElementById("status-filter");
  const locationFilter = document.getElementById("location");
  
  // Function to filter rooms based on status and location
  function filterRooms() {
    const showActiveOnly = statusFilterCheckbox.checked;
    const selectedLocation = locationFilter.value;
    
    // Get all room cards
    const roomCards = document.querySelectorAll('.room-card');
    
    roomCards.forEach(card => {
      // Get data attributes from the card
      const isActive = card.getAttribute('data-active') === 'true';
      const location = card.getAttribute('data-location');
      
      // Initialize visibility flag
      let shouldShow = true;
      
      // Apply status filter if checked
      if (showActiveOnly && !isActive) {
        shouldShow = false;
      }
      
      // Apply location filter if not set to "all-loc"
      if (selectedLocation !== 'all-loc' && location !== selectedLocation) {
        shouldShow = false;
      }
      
      // Show or hide the room card
      card.style.display = shouldShow ? 'block' : 'none';
    });
    
    // Check if any rooms are visible after filtering
    const visibleRooms = document.querySelectorAll('.room-card[style="display: block;"]');
    const noRoomsMessage = document.querySelector('.no-rooms');
    
    // If no rooms are visible after filtering, show a message
    if (visibleRooms.length === 0) {
      // Create "no rooms" message if it doesn't exist
      if (!noRoomsMessage) {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'no-rooms';
        messageDiv.innerHTML = '<p>No rooms available with the selected filters. Please try different criteria.</p>';
        document.getElementById('roomList').appendChild(messageDiv);
      } else {
        noRoomsMessage.style.display = 'block';
      }
    } else if (noRoomsMessage) {
      // Hide the "no rooms" message if it exists and there are visible rooms
      noRoomsMessage.style.display = 'none';
    }
  }
  
  // Add event listeners for the filters
  statusFilterCheckbox.addEventListener('change', filterRooms);
  locationFilter.addEventListener('change', filterRooms);
  
  // Initial filter application
  filterRooms();
});

//simply checking if it is booked or not
document.addEventListener("DOMContentLoaded", function() {
	  const bookDateInput = document.getElementById("bookDate");
	  const bookFromTimeSelect = document.getElementById("bookFromTime");
	  
	  // Function to disable past time slots for the current day
	  function updateTimeOptions() {
	    const selectedDate = new Date(bookDateInput.value);
	    const today = new Date();
	    
	    // Reset all options to enabled state first
	    Array.from(bookFromTimeSelect.options).forEach(option => {
	      option.disabled = false;
	    });
	    
	    // Only apply time restrictions if the selected date is today
	    if (selectedDate.toDateString() === today.toDateString()) {
	      const currentHour = today.getHours();
	      
	      // Map of option values to their hour in 24h format
	      const timeMap = {
	        "9:00 AM": 9,
	        "11:00 AM": 11,
	        "1:00 PM": 13,
	        "3:00 PM": 15
	      };
	      
	      // Disable options that have already passed
	      Array.from(bookFromTimeSelect.options).forEach(option => {
	        const optionHour = timeMap[option.value];
	        if (optionHour <= currentHour) {
	          option.disabled = true;
	        }
	      });
	      
	      // If the currently selected option is now disabled, select the first enabled option
	      if (bookFromTimeSelect.selectedOptions[0].disabled) {
	        const firstEnabledOption = Array.from(bookFromTimeSelect.options).find(option => !option.disabled);
	        if (firstEnabledOption) {
	          bookFromTimeSelect.value = firstEnabledOption.value;
	          // Update end time since start time has changed
	          if (typeof updateEndTime === 'function') {
	            updateEndTime();
	          }
	        }
	      }
	    }
	  }
	  
	  // Update time options when date changes
	  bookDateInput.addEventListener("change", updateTimeOptions);
	  
	  // Add to the existing validateDate function to check times as well
	  const originalValidateDate = validateDate;
	  window.validateDate = function() {
	    const basicValidation = typeof originalValidateDate === 'function' ? originalValidateDate() : true;
	    
	    if (!basicValidation) return false;
	    
	    const selectedDate = new Date(bookDateInput.value);
	    const today = new Date();
	    
	    // If it's today and the selected time has passed
	    if (selectedDate.toDateString() === today.toDateString()) {
	      const selectedOption = bookFromTimeSelect.options[bookFromTimeSelect.selectedIndex];
	      if (selectedOption.disabled) {
	        showValidationMessage(bookFromTimeSelect, "This time slot has already passed");
	        return false;
	      }
	    }
	    
	    return true;
	  };
	  
	  // Initialize on page load
	  updateTimeOptions();
	});
  </script>

</body>
</html>