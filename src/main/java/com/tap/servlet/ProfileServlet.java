package com.tap.servlet;

import java.io.IOException;

import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Get logged-in user from session
        User user = (User) session.getAttribute("user");

        // Check whether user is logged in
        if (user == null) {
            resp.sendRedirect("login.html");
            return;
        }

        // Send user object to profile.jsp
        req.setAttribute("user", user);

        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }
}