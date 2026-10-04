package com.tap.DAO;

import java.util.List;

import com.tap.model.User;

public interface UserDAO {

	int addUser(User user);
	User getUser(int userID);
	void updateUser(User user);
	void deleteUser(int userID);
	List<User> getAllUser();
	
}
