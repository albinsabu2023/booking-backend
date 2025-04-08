package com.booking.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class DashboardServlet
 */
@WebServlet("/profile/*")
public class DashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action=request.getPathInfo();
		System.out.println("action-->"+action);
		if(action.equals("/userDashboard")) {
			response.sendRedirect(request.getContextPath()+"/dashboard/userDashboard.jsp");
		}else if(action.equals("/adminDashboard")) {
			response.sendRedirect(request.getContextPath()+"/dashboard/adminDashboard.jsp");
		}else {
			System.out.println("no conditions are working");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("post called");
	}

}
