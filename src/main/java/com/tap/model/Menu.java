package com.tap.model;

public class Menu {


		private int menuID;
		private int restaurantID;
		private String itemName;
		private String description;
		private double price;
		private boolean isAvailable;
		private double ratings;
		private String imagePath;

		// Default Constructor
		public Menu() {

		}

		// Constructor without menuID
		public Menu(int restaurantID, String itemName, String description, double price,
				boolean isAvailable, double ratings, String imagePath) {
			super();
			this.restaurantID = restaurantID;
			this.itemName = itemName;
			this.description = description;
			this.price = price;
			this.isAvailable = isAvailable;
			this.ratings = ratings;
			this.imagePath = imagePath;
		}

		// Constructor with menuID
		public Menu(int menuID, int restaurantID, String itemName, String description,
				double price, boolean isAvailable, double ratings, String imagePath) {
			super();
			this.menuID = menuID;
			this.restaurantID = restaurantID;
			this.itemName = itemName;
			this.description = description;
			this.price = price;
			this.isAvailable = isAvailable;
			this.ratings = ratings;
			this.imagePath = imagePath;
		}

		// Getters and Setters

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

		public String getItemName() {
			return itemName;
		}

		public void setItemName(String itemName) {
			this.itemName = itemName;
		}

		public String getDescription() {
			return description;
		}

		public void setDescription(String description) {
			this.description = description;
		}

		public double getPrice() {
			return price;
		}

		public void setPrice(double price) {
			this.price = price;
		}

		public boolean isAvailable() {
			return isAvailable;
		}

		public void setAvailable(boolean isAvailable) {
			this.isAvailable = isAvailable;
		}

		public double getRatings() {
			return ratings;
		}

		public void setRatings(double ratings) {
			this.ratings = ratings;
		}

		public String getImagePath() {
			return imagePath;
		}

		public void setImagePath(String imagePath) {
			this.imagePath = imagePath;
		}

		@Override
		public String toString() {
			return "Menu [menuID=" + menuID + ", restaurantID=" + restaurantID + ", itemName=" + itemName
					+ ", description=" + description + ", price=" + price + ", isAvailable="
					+ isAvailable + ", ratings=" + ratings + ", imagePath=" + imagePath + "]";
		}

	

}
