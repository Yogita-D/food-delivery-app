package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderTableDAO;
import com.tap.model.OrderTable;
import com.tap.utility.DBConnection;

public class OrderTableDAOImpl implements OrderTableDAO {

    String INSERT_QUERY = "INSERT INTO ordertable(userID, restaurantID, orderDate, totalAmount, status, paymentMethod) "
            + "VALUES(?,?,?,?,?,?)";

    String GET_QUERY = "SELECT * FROM ordertable WHERE orderID = ?";

    String UPDATE_QUERY = "UPDATE ordertable SET userID=?, restaurantID=?, orderDate=?, "
            + "totalAmount=?, status=?, paymentMethod=? WHERE orderID=?";

    String DELETE_QUERY = "DELETE FROM ordertable WHERE orderID=?";

    String GET_ALL_QUERY = "SELECT * FROM ordertable";
    
    String GET_BY_USER_ID_QUERY =
            "SELECT * FROM ordertable WHERE userID = ? ORDER BY orderDate DESC";


    // Add Order and return generated Order ID
    public int addOrder(OrderTable order) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(
                    INSERT_QUERY,
                    Statement.RETURN_GENERATED_KEYS
            );

            pstmt.setInt(1, order.getUserID());
            pstmt.setInt(2, order.getRestaurantID());

            // Use order date from object
            pstmt.setTimestamp(3, order.getOrderDate());

            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMethod());

            int i = pstmt.executeUpdate();

            System.out.println("Order inserted: " + i);

            // Get generated orderID
            ResultSet rs = pstmt.getGeneratedKeys();

            if (rs.next()) {

                int orderID = rs.getInt(1);

                System.out.println("Generated Order ID: " + orderID);

                return orderID;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }


    @Override
    public OrderTable getOrder(int orderID) {

        OrderTable order = null;

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(GET_QUERY);

            pstmt.setInt(1, orderID);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                order = extractOrderFromResultSet(rs);

            }

            return order;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }


    @Override
    public void updateOrder(OrderTable order) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);

            pstmt.setInt(1, order.getUserID());
            pstmt.setInt(2, order.getRestaurantID());
            pstmt.setTimestamp(3, order.getOrderDate());
            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMethod());
            pstmt.setInt(7, order.getOrderID());

            int i = pstmt.executeUpdate();

            System.out.println(i);

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    @Override
    public void deleteOrder(int orderID) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);

            pstmt.setInt(1, orderID);

            int i = pstmt.executeUpdate();

            if (i > 0) {

                System.out.println("Order deleted successfully");

            } else {

                System.out.println("No Order found with ID : " + orderID);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    @Override
    public List<OrderTable> getAllOrder() {

        ArrayList<OrderTable> list = new ArrayList<>();

        Connection connection = DBConnection.getConnection();

        try {

            Statement stmt = connection.createStatement();

            ResultSet rs = stmt.executeQuery(GET_ALL_QUERY);

            while (rs.next()) {

                OrderTable order = extractOrderFromResultSet(rs);

                list.add(order);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }


    public static OrderTable extractOrderFromResultSet(ResultSet rs)
            throws SQLException {

        int orderID = rs.getInt("orderID");
        int userID = rs.getInt("userID");
        int restaurantID = rs.getInt("restaurantID");

        Timestamp orderDate =
                rs.getTimestamp("orderDate");

        double totalAmount =
                rs.getDouble("totalAmount");

        String status =
                rs.getString("status");

        String paymentMethod =
                rs.getString("paymentMethod");


        OrderTable order = new OrderTable(
                orderID,
                userID,
                restaurantID,
                orderDate,
                totalAmount,
                status,
                paymentMethod
        );

        return order;
    }
    
    public List<OrderTable> getOrdersByUserID(int userID) {

        List<OrderTable> orders = new ArrayList<>();

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt =
                    connection.prepareStatement(GET_BY_USER_ID_QUERY);

            pstmt.setInt(1, userID);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                OrderTable order =
                        extractOrderFromResultSet(rs);

                orders.add(order);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return orders;
    }
}