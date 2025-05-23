<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Receipt</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/preview.css">
    <link rel="stylesheet" href="./preview.css">
</head>
<body>
    <!-- Sidebar -->
   <div class="sidebar" id="sidebar">
    <div class="sidebar-header">
      <div class="sidebar-title">meetNspace</div>
      <button class="toggle-btn" id="toggleSidebar">
        ≡
      </button>
    </div>
    
    <ul class="menu-list">
      <a href="#">
      <li class="menu-item " data-tooltip="Dashboard">
        <span class="menu-icon">📊</span>
        <span class="menu-text">Dashboard</span>
      </li>
      </a>
      <a href="history.html">
      <li class="menu-item active" data-tooltip="View Bookings">
        <span class="menu-icon">🔍</span>
        <span class="menu-text">Booking History</span>
      </li>
      </a>
      <a href="book.html">
      <li class="menu-item" data-tooltip="Add Room Details">
        <span class="menu-icon">➕</span>
        <span class="menu-text">Create Booking</span>
      </li>
    </a>
      <a href="#">
      <li class="menu-item" data-tooltip="Feedbacks">
        <span class="menu-icon">📝</span>
        <span class="menu-text">Feedbacks</span>
      </li>
    </a>
      <div class="divider"></div>
      <a href="#">
      <li class="menu-item" data-tooltip="Profile">
        <span class="menu-icon">👤</span>
        <span class="menu-text">Profile</span>
      </li>
      </a>
      
      <div class="divider"></div>
      <a href="#">
      <li class="menu-item" data-tooltip="Logout">
        <span class="menu-icon">↩️</span>
        <span class="menu-text">Logout</span>
      </li>
      </a>
    </ul>
  </div>
  

    <!-- Main Content -->
    <div class="main-content">
        <div class="receipt-container" id="receipt">
            <!-- Receipt content will be inserted here by JavaScript -->
        </div>
    </div>

    <script src="preview.js">
       
    </script>
</body>
</html>