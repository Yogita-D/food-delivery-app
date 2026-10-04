package com.tap.DAO;

import java.util.List;

import com.tap.model.Menu;

public interface MenuDAO {
	
	void addMenu(Menu menu);
	Menu getMenu(int menuID);
	void updateMenu(Menu menu);
	void deleteMenu(int menuID);
	List<Menu> getAllMenu();
	List<Menu> getAllMenusByRestaurant(int restaurantID);

}
