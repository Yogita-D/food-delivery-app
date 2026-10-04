package com.tap.servlet;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String name = req.getParameter("name");
		String password = req.getParameter("password");
		String email = req.getParameter("email");
		String address = req.getParameter("address");
		String role = req.getParameter("role");
		
		String hashpw = BCrypt.hashpw(password, BCrypt.gensalt(12));
		
		User user = new User(name,email ,hashpw ,address,role);
		
		UserDAOImpl userDAOImpl = new UserDAOImpl();
		int i = userDAOImpl.addUser(user);
		
		if(i == 1)
		{
		    resp.sendRedirect("login.html");
		}
		else
		{
		    resp.sendRedirect("register.html");
		}
		
	}
	
	

}
