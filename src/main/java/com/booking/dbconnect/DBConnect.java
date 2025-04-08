package com.booking.dbconnect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
	private static Connection con=null;
	public static Connection getConnection() {
		if(con==null) {
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				con=DriverManager.getConnection("jdbc:mysql://localhost:3306/bookingsytstem","root","hello123");
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				System.out.println("class Not found");
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				System.out.println(" cannot create conn object");
				e.printStackTrace();
			}
						
		}
		return con;

	}
}
