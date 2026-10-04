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
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        HttpSession session = req.getSession();

        UserDAOImpl userDAOImpl = new UserDAOImpl();

        User user = userDAOImpl.getUserByUseremail(email);

        if (user != null) {

            String dbPassword = user.getPassword();

            if (BCrypt.checkpw(password, dbPassword)) {

                // Store complete user object
                session.setAttribute("user", user);

                // Store logged-in user's ID
                session.setAttribute("userID", user.getUserID());

                // Login successful
                resp.sendRedirect("Restaurant");

            } else {

                System.out.println("PASSWORD IS INCORRECT");

                resp.sendRedirect("login.html");
            }

        } else {

            System.out.println("USER NOT FOUND");

            resp.sendRedirect("login.html");
        }
    }
}