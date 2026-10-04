package com.tap.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	private final static String URL ="jdbc:mysql://localhost:3306/tap_foods";
	private final static String USERNAME = "root";
	private final static String PASSWORD ="YOUR_PASSWORD";
	static Connection connection ;
	
	public static Connection getConnection()
	{
		try 
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
		    connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			
		}
		catch (ClassNotFoundException e) {	
			e.printStackTrace();
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return connection;
	}

}
