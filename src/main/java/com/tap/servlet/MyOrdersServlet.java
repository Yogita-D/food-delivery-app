package com.tap.servlet;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.OrderTableDAOImpl;
import com.tap.model.OrderTable;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MyOrdersServlet")
public class MyOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Get current session
        HttpSession session = req.getSession(false);

        // Check if session exists
        if (session == null) {

            resp.sendRedirect("login.html");

            return;
        }

        // Get logged-in user from session
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {

            resp.sendRedirect("login.html");

            return;
        }

        // Get user ID from User object
        int userID = user.getUserID();

        // Create DAO
        OrderTableDAOImpl orderTableDAO =
                new OrderTableDAOImpl();

        // Get orders of logged-in user
        List<OrderTable> orders =
                orderTableDAO.getOrdersByUserID(userID);

        // Send orders to JSP
        req.setAttribute("orders", orders);

        // Forward to MyOrders.jsp
        req.getRequestDispatcher("/MyOrders.jsp")
                .forward(req, resp);
    }
}
