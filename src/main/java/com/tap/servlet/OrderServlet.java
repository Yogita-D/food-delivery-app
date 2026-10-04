package com.tap.servlet;

import java.io.IOException;
import java.sql.Timestamp;

import com.tap.DAOImpl.OrderItemDAOImpl;
import com.tap.DAOImpl.OrderTableDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.OrderItem;
import com.tap.model.OrderTable;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            // Get the current session
            HttpSession session = req.getSession();

            // Get Cart from session
            Cart cart = (Cart) session.getAttribute("cart");

            // Check if cart is empty
            if (cart == null || cart.getItems().isEmpty()) {

                resp.sendRedirect("Cart.jsp");

                return;
            }

            // Get userID from session
            // IMPORTANT:
            // Change this according to how you stored userID during login

            User user = (User) session.getAttribute("user");

            if (user == null) {
                resp.sendRedirect("login.html");
                return;
            }

            int userID = user.getUserID();


            // Get restaurant ID from checkout form
            int restaurantID = Integer.parseInt(
                    req.getParameter("restaurantID")
            );


            // Get payment method
            String paymentMethod = req.getParameter("paymentMode");


            // Calculate subtotal from cart
            double subtotal = 0;

            for (CartItem item : cart.getItems().values()) {

                double itemTotal =
                        item.getPrice() * item.getQty();

                subtotal = subtotal + itemTotal;
            }


            // Delivery charges
            double deliveryCharges = 40;


            // GST 5%
            double gst = subtotal * 0.05;


            // Final total
            double totalAmount =
                    subtotal + deliveryCharges + gst;


            // Order status
            String status = "Pending";


            // Current date and time
            Timestamp orderDate =
                    new Timestamp(System.currentTimeMillis());


            // Create OrderTable object
            OrderTable order = new OrderTable(
                    userID,
                    restaurantID,
                    orderDate,
                    totalAmount,
                    status,
                    paymentMethod
            );


            // Create OrderTable DAO
            OrderTableDAOImpl orderTableDAO =
                    new OrderTableDAOImpl();


            // Insert order into ordertable
            // This method must return generated orderID
            int orderID =
                    orderTableDAO.addOrder(order);


            // Create OrderItem DAO
            OrderItemDAOImpl orderItemDAO =
                    new OrderItemDAOImpl();


            // Loop through all cart items
            for (CartItem item : cart.getItems().values()) {


                // Calculate individual item total
                double itemTotal =
                        item.getPrice() * item.getQty();


                // Create OrderItem object
                OrderItem orderItem = new OrderItem(

                        orderID,

                        item.getMenuID(),

                        item.getQty(),

                        itemTotal
                );


                // Insert item into orderitem table
                orderItemDAO.addOrderItem(orderItem);

            }


            // Clear cart after successful order
            session.removeAttribute("cart");

            session.removeAttribute("restaurantID");


            // Store orderID in session
            // This can be used on success page
            session.setAttribute(
                    "orderID",
                    orderID
            );


            // Store total amount
            session.setAttribute(
                    "orderTotal",
                    totalAmount
            );


            // Redirect to success page
            resp.sendRedirect("OrderSuccess.jsp");


        } catch (Exception e) {

            e.printStackTrace();

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to place order"
            );

        }

    }

}