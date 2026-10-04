package com.tap.DAOImpl;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.UserDAO;
import com.tap.model.User;
import com.tap.utility.DBConnection;

public class UserDAOImpl implements UserDAO{
	
	String INSERT_QUERY = "INSERT INTO user(userName,email,password,address,role,createdDate,lastLoginDate) "
	+ "VALUES(?,?,?,?,?,?,?)";

	String GET_QUERY = "SELECT * FROM User where userID = ?";
	
	String DELETE_QUERY = "DELETE FROM user WHERE userID = ?";
	
	String GET_USER_BY_EMAIL = "SELECT * FROM user WHERE email = ?";
	
	@Override
	public int addUser(User user) {
	Connection	connection = DBConnection.getConnection();
	
	try {
		PreparedStatement pstmt= connection.prepareStatement(INSERT_QUERY);
		
		pstmt.setString(1, user.getUserName());
		pstmt.setString(2, user.getEmail());
		pstmt.setString(3, user.getPassword());
		pstmt.setString(4, user.getAddress());
		pstmt.setString(5, user.getRole());
		pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
		pstmt.setTimestamp(7,new Timestamp(System.currentTimeMillis()));
		
		int i = pstmt.executeUpdate();
		System.out.println(i);
		return i;
		
	} 
	catch (SQLException e) {
		e.printStackTrace();
	}
	return 0;
	}

	@Override
	public User getUser(int userID) {
	
		User user = null;
	Connection connection	= DBConnection.getConnection();
	
	try {
		PreparedStatement pstmt = connection.prepareStatement(GET_QUERY);
		pstmt.setInt(1, userID);
		
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			int id = rs.getInt("userID");
			String name = rs.getString("userName");
			String email = rs.getString("email");
			String password = rs.getString("password");
			String address = rs.getString("address");
			String role = rs.getString("role");
			Timestamp createdDate= rs.getTimestamp("createdDate");
			Timestamp lastLoginDate = rs.getTimestamp("lastLoginDate");
			
			user = new User(id,name,email,password,address,role,createdDate,lastLoginDate);
			
		}
		return user;
		
	} catch (SQLException e) {
	
		e.printStackTrace();
	}
	return null;
	}

	@Override
	public void updateUser(User user) {
		String UPDATE_USER ="UPDATE USER SET userName= ?, password = ?, email = ?, address = ?, lastLoginDate = ?"
				+ "WHERE userID = ?";
		
		Connection connection	= DBConnection.getConnection();
		
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_USER);
			
			pstmt.setString(1, user.getUserName());
			pstmt.setString(3, user.getEmail());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(4, user.getAddress());
			pstmt.setTimestamp(5,new Timestamp(System.currentTimeMillis()));
			pstmt.setInt(6, user.getUserID());
			
			
			int i = pstmt.executeUpdate();
			System.out.println(i);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteUser(int userID) {
		 Connection connection = DBConnection.getConnection();

		    try {

		        PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);

		        pstmt.setInt(1, userID);

		        int i = pstmt.executeUpdate();

		        if (i > 0) {
		            System.out.println("User deleted successfully");
		        } else {
		            System.out.println("No user found with ID: " + userID);
		        }

		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
	}

	@Override
	public List<User> getAllUser() {
		
		String GET_ALL_USER = "SELECT * FROM user";
		ArrayList<User> list = new ArrayList<User>();
		
		Connection connection	= DBConnection.getConnection();
		try {
		Statement stmt = connection.createStatement();
		ResultSet rs = stmt.executeQuery(GET_ALL_USER);
		
		while(rs.next())
		{
			User user = extractUserFromResultSet(rs);
			list.add(user);
		}
		}
		catch(SQLException e){
			e.printStackTrace();
		}
		return list;
		
	}
	
	
	
	public static User extractUserFromResultSet(ResultSet rs) throws SQLException
	{
		
			int id = rs.getInt("userID");
			String name = rs.getString("userName");
			String email = rs.getString("email");
			String password = rs.getString("password");
			String address = rs.getString("address");
			String role = rs.getString("role");
			Timestamp createdDate= rs.getTimestamp("createdDate");
			Timestamp lastLoginDate = rs.getTimestamp("lastLoginDate");
			
			User user = new User(id,name,email,password,address,role,createdDate,lastLoginDate);
			return user;
		
	}
	
	public User getUserByUseremail(String email) {

	    User user = null;

	    Connection connection = DBConnection.getConnection();

	    try {

	        PreparedStatement pstmt =
	                connection.prepareStatement(GET_USER_BY_EMAIL);

	        pstmt.setString(1, email);

	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {

	            user = extractUserFromResultSet(rs);

	        }

	    } catch (SQLException e) {

	        e.printStackTrace();

	    }

	    return user;
	}

}
