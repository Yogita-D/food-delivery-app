package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderItemDAO;
import com.tap.model.OrderItem;
import com.tap.utility.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

	String INSERT_QUERY = "INSERT INTO orderitem(orderID,menuID,quantity,itemTotal) VALUES(?,?,?,?)";

	String GET_QUERY = "SELECT * FROM orderitem WHERE orderItemID = ?";

	String UPDATE_QUERY = "UPDATE orderitem SET orderID=?, menuID=?, quantity=?, itemTotal=? WHERE orderItemID=?";

	String DELETE_QUERY = "DELETE FROM orderitem WHERE orderItemID=?";

	String GET_ALL_QUERY = "SELECT * FROM orderitem";

	@Override
	public void addOrderItem(OrderItem orderItem) {

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);

			pstmt.setInt(1, orderItem.getOrderID());
			pstmt.setInt(2, orderItem.getMenuID());
			pstmt.setInt(3, orderItem.getQuantity());
			pstmt.setDouble(4, orderItem.getItemTotal());

			int i = pstmt.executeUpdate();
			System.out.println(i);

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public OrderItem getOrderItem(int orderItemID) {

		OrderItem orderItem = null;

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(GET_QUERY);

			pstmt.setInt(1, orderItemID);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				orderItem = extractOrderItemFromResultSet(rs);

			}

			return orderItem;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public void updateOrderItem(OrderItem orderItem) {

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);

			pstmt.setInt(1, orderItem.getOrderID());
			pstmt.setInt(2, orderItem.getMenuID());
			pstmt.setInt(3, orderItem.getQuantity());
			pstmt.setDouble(4, orderItem.getItemTotal());
			pstmt.setInt(5, orderItem.getOrderItemID());

			int i = pstmt.executeUpdate();

			System.out.println(i);

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteOrderItem(int orderItemID) {

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);

			pstmt.setInt(1, orderItemID);

			int i = pstmt.executeUpdate();

			if (i > 0) {
				System.out.println("Order Item deleted successfully");
			} else {
				System.out.println("No Order Item found with ID : " + orderItemID);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<OrderItem> getAllOrderItems() {

		ArrayList<OrderItem> list = new ArrayList<>();

		Connection connection = DBConnection.getConnection();

		try {

			Statement stmt = connection.createStatement();

			ResultSet rs = stmt.executeQuery(GET_ALL_QUERY);

			while (rs.next()) {

				OrderItem orderItem = extractOrderItemFromResultSet(rs);

				list.add(orderItem);

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	public static OrderItem extractOrderItemFromResultSet(ResultSet rs) throws SQLException {

		int orderItemID = rs.getInt("orderItemID");
		int orderID = rs.getInt("orderID");
		int menuID = rs.getInt("menuID");
		int quantity = rs.getInt("quantity");
		double itemTotal = rs.getDouble("itemTotal");

		OrderItem orderItem = new OrderItem(orderItemID, orderID, menuID, quantity, itemTotal);

		return orderItem;
	}
}
