package com.booking.model;

public class Room {
    private int id;
    private String name;
    private String location;
    private int capacity;
    private boolean active;
    private String specifications;

    // Default constructor
    public Room() {
    }

    // Parameterized constructor
    public Room(int id, String name, String location, int capacity, boolean active, String specifications) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.capacity = capacity;
        this.active = active;
        this.specifications = specifications;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getSpecifications() {
        return specifications;
    }

    public void setSpecifications(String specifications) {
        this.specifications = specifications;
    }

    @Override
    public String toString() {
        return "Room [id=" + id + ", name=" + name + ", location=" + location + ", capacity=" + capacity + ", active="
                + active + ", specifications=" + specifications + "]";
    }
}