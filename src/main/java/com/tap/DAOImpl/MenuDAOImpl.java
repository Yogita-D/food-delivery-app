package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDAO;
import com.tap.model.Menu;
import com.tap.utility.DBConnection;

public class MenuDAOImpl implements MenuDAO {

	String INSERT_QUERY = "INSERT INTO menu(restaurantID,itemName,description,price,isAvailable,ratings,imagePath) VALUES(?,?,?,?,?,?,?)";

	String GET_QUERY = "SELECT * FROM menu WHERE menuID = ?";

	String UPDATE_QUERY = "UPDATE menu SET restaurantID=?, itemName=?, description=?, price=?, isAvailable=?, ratings=?, imagePath=? WHERE menuID=?";

	String DELETE_QUERY = "DELETE FROM menu WHERE menuID=?";

	String GET_ALL_QUERY = "SELECT * FROM menu";

	// NEW QUERY
	String GET_BY_RESTAURANT_QUERY = "SELECT * FROM menu WHERE restaurantID=?";

	@Override
	public void addMenu(Menu menu) {

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);

			pstmt.setInt(1, menu.getRestaurantID());
			pstmt.setString(2, menu.getItemName());
			pstmt.setString(3, menu.getDescription());
			pstmt.setDouble(4, menu.getPrice());
			pstmt.setBoolean(5, menu.isAvailable());
			pstmt.setDouble(6, menu.getRatings());
			pstmt.setString(7, menu.getImagePath());

			int i = pstmt.executeUpdate();
			System.out.println(i);

		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	@Override
	public Menu getMenu(int menuID) {

		Menu menu = null;

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(GET_QUERY);

			pstmt.setInt(1, menuID);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				menu = extractMenuFromResultSet(rs);

			}

			return menu;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public void updateMenu(Menu menu) {

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);

			pstmt.setInt(1, menu.getRestaurantID());
			pstmt.setString(2, menu.getItemName());
			pstmt.setString(3, menu.getDescription());
			pstmt.setDouble(4, menu.getPrice());
			pstmt.setBoolean(5, menu.isAvailable());
			pstmt.setDouble(6, menu.getRatings());
			pstmt.setString(7, menu.getImagePath());
			pstmt.setInt(8, menu.getMenuID());

			int i = pstmt.executeUpdate();

			System.out.println(i);

		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	@Override
	public void deleteMenu(int menuID) {

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);

			pstmt.setInt(1, menuID);

			int i = pstmt.executeUpdate();

			if (i > 0) {
				System.out.println("Menu deleted successfully");
			} else {
				System.out.println("No Menu found with ID : " + menuID);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	@Override
	public List<Menu> getAllMenu() {

		ArrayList<Menu> list = new ArrayList<>();

		Connection connection = DBConnection.getConnection();

		try {

			Statement stmt = connection.createStatement();

			ResultSet rs = stmt.executeQuery(GET_ALL_QUERY);

			while (rs.next()) {

				Menu menu = extractMenuFromResultSet(rs);

				list.add(menu);

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	// NEW METHOD
	@Override
	public List<Menu> getAllMenusByRestaurant(int restaurantID) {

		ArrayList<Menu> list = new ArrayList<>();

		Connection connection = DBConnection.getConnection();

		try {

			PreparedStatement pstmt = connection.prepareStatement(GET_BY_RESTAURANT_QUERY);

			pstmt.setInt(1, restaurantID);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Menu menu = extractMenuFromResultSet(rs);

				list.add(menu);

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	public static Menu extractMenuFromResultSet(ResultSet rs) throws SQLException {

		int menuID = rs.getInt("menuID");
		int restaurantID = rs.getInt("restaurantID");
		String itemName = rs.getString("itemName");
		String description = rs.getString("description");
		double price = rs.getDouble("price");
		boolean isAvailable = rs.getBoolean("isAvailable");
		double ratings = rs.getDouble("ratings");
		String imagePath = rs.getString("imagePath");

		Menu menu = new Menu(menuID, restaurantID, itemName, description, price, isAvailable, ratings, imagePath);

		return menu;
	}

}