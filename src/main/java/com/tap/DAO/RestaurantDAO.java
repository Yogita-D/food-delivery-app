package com.tap.DAO;

import java.util.List;

import com.tap.model.Restaurant;

public interface RestaurantDAO {

	    void addRestaurant(Restaurant restaurant);

	    Restaurant getRestaurant(int restaurantID);

	    void updateRestaurant(Restaurant restaurant);

	    void deleteRestaurant(int restaurantID);

	    List<Restaurant> getAllRestaurant();

}

