package com.tap.model;

public class CartItem {
	
	private int menuID;
	private int restaurantID;
	private String name;
	private double price;
	private int qty;


	public CartItem(int menuID, int restaurantID, String name, double price, int qty) {
		super();
		this.menuID = menuID;
		this.restaurantID = restaurantID;
		this.name = name;
		this.price = price;
		this.qty = qty;
	}
	
	
	public int getMenuID() {
		return menuID;
	}


	public void setMenuID(int menuID) {
		this.menuID = menuID;
	}


	public int getRestaurantID() {
		return restaurantID;
	}


	public void setRestaurantID(int restaurantID) {
		this.restaurantID = restaurantID;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public double getPrice() {
		return price;
	}


	public void setPrice(double price) {
		this.price = price;
	}


	public int getQty() {
		return qty;
	}


	public void setQty(int qty) {
		this.qty = qty;
	}


	@Override
	public String toString() {
		return "CartItem [menuID=" + menuID + ", restaurantID=" + restaurantID + ", name=" + name + ", price=" + price
				+ ", qty=" + qty + "]";
	}

	

}
