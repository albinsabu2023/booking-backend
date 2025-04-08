

-- Create Users Table
CREATE TABLE Users (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) CHECK (role IN ('user', 'admin')) DEFAULT 'user',
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Insert Queries
INSERT INTO Users (employee_id, name, password, role) VALUES 
(1, 'Admin User', 'admin123', 'admin'),
(2, 'Regular Employee', 'user123', 'user');

-- Create Rooms Table
CREATE TABLE Rooms (
    roomId INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('active', 'under maintenance')) DEFAULT 'active',
    specifications VARCHAR(500),
    floor INT,
    equipment_available VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Sample Data into Rooms
INSERT INTO Rooms (roomId, name, location, capacity, status, specifications) VALUES 
(101, 'Conference Room A', 'Main Building, 1st Floor', 20, 'active', 'Projector, Whiteboard'),
(102, 'Meeting Room B', 'Main Building, 2nd Floor', 10, 'active', 'Video Conferencing Equipment'),
(103, 'Training Room', 'East Wing, Ground Floor', 30, 'under maintenance', 'Large Screen, Sound System');

-- Create Bookings Table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    employee_id INT,
    roomId INT,
    date DATE NOT NULL,
    fromtime TIME NOT NULL,
    totime TIME NOT NULL,
    status VARCHAR(20) CHECK (status IN ('upcoming', 'completed', 'cancelled')) DEFAULT 'upcoming',
    purpose VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Users(employee_id),
    FOREIGN KEY (roomId) REFERENCES Rooms(roomId)
);

-- Add Unique Constraint for Booking Time Slots
ALTER TABLE Bookings ADD CONSTRAINT unique_booking UNIQUE (roomId, date, fromtime, totime);

-- Insert Sample Data into Bookings
INSERT INTO Bookings (employee_id, roomId, date, fromtime, totime, status, purpose) VALUES 
(2, 101, '2024-03-27', '09:00:00', '11:00:00', 'upcoming', 'Team Meeting'),
(2, 102, '2024-03-28', '14:00:00', '15:30:00', 'upcoming', 'Client Presentation');

-- Create Feedbacks Table
CREATE TABLE Feedbacks (
    feedback_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    employee_id INT,
    feedback VARCHAR(1000) NOT NULL,
    comment VARCHAR(1000),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    status VARCHAR(20) CHECK (status IN ('in progress', 'resolved')) DEFAULT 'in progress',
    type VARCHAR(20) CHECK (type IN ('complaint', 'suggestion')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Users(employee_id)
);

-- Insert Sample Data into Feedbacks
INSERT INTO Feedbacks (employee_id, feedback, comment, rating, type) VALUES 
(2, 'Room equipment needs upgrade', 'Projector is not working properly', 3, 'complaint'),
(2, 'Suggestion for more meeting spaces', 'We need more small meeting rooms', 4, 'suggestion');

-- Create ResolvedFeedbacks Table
CREATE TABLE ResolvedFeedbacks (
    resolved_feedback_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    feedback_id INT,
    employee_id INT,
    feedback VARCHAR(1000) NOT NULL,
    comment VARCHAR(1000),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    status VARCHAR(20) CHECK (status IN ('resolved')) DEFAULT 'resolved',
    type VARCHAR(20) CHECK (type IN ('complaint', 'suggestion')) NOT NULL,
    resolved_comment VARCHAR(1000),
    resolved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Users(employee_id)
);

-- Show all tables
SELECT * FROM SYS.SYSTABLES WHERE TABLETYPE='T';
