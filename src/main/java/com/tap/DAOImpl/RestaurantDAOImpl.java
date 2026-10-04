package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.utility.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    String INSERT_QUERY = "INSERT INTO restaurant(name,cuisineType,deliveryTime,address,rating,isActive,imagePath) "
            + "VALUES(?,?,?,?,?,?,?)";

    String GET_QUERY = "SELECT * FROM restaurant WHERE restaurantID = ?";

    String DELETE_QUERY = "DELETE FROM restaurant WHERE restaurantID = ?";

    String GET_ALL_QUERY = "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setDouble(5, restaurant.getRating());
            pstmt.setBoolean(6, restaurant.isActive());
            pstmt.setString(7, restaurant.getImagePath());

            int i = pstmt.executeUpdate();
            System.out.println(i);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantID) {

        Restaurant restaurant = null;

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(GET_QUERY);
            pstmt.setInt(1, restaurantID);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                restaurant = extractRestaurantFromResultSet(rs);

            }

            return restaurant;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        String UPDATE_QUERY = "UPDATE restaurant SET name=?, cuisineType=?, deliveryTime=?, address=?, rating=?, isActive=?, imagePath=? WHERE restaurantID=?";

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setDouble(5, restaurant.getRating());
            pstmt.setBoolean(6, restaurant.isActive());
            pstmt.setString(7, restaurant.getImagePath());
            pstmt.setInt(8, restaurant.getRestaurantID());

            int i = pstmt.executeUpdate();
            System.out.println(i);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantID) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);

            pstmt.setInt(1, restaurantID);

            int i = pstmt.executeUpdate();

            if (i > 0) {
                System.out.println("Restaurant deleted successfully");
            } else {
                System.out.println("No Restaurant found with ID : " + restaurantID);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurant() {

        ArrayList<Restaurant> list = new ArrayList<>();

        Connection connection = DBConnection.getConnection();

        try {

            Statement stmt = connection.createStatement();

            ResultSet rs = stmt.executeQuery(GET_ALL_QUERY);

            while (rs.next()) {

                Restaurant restaurant = extractRestaurantFromResultSet(rs);
                list.add(restaurant);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static Restaurant extractRestaurantFromResultSet(ResultSet rs) throws SQLException {

        int restaurantID = rs.getInt("restaurantID");
        String name = rs.getString("name");
        String cuisineType = rs.getString("cuisineType");
        int deliveryTime = rs.getInt("deliveryTime");
        String address = rs.getString("address");
        double rating = rs.getDouble("rating");
        boolean isActive = rs.getBoolean("isActive");
        String imagePath = rs.getString("imagePath");

        Restaurant restaurant = new Restaurant(
                restaurantID,
                name,
                cuisineType,
                deliveryTime,
                address,
                rating,
                isActive,
                imagePath);

        return restaurant;
    }
}