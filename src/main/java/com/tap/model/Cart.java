package com.tap.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {

	Map<Integer,CartItem>items;
	
	public Cart() {
		
		items = new HashMap<Integer,CartItem>();
	}

	public Map<Integer, CartItem> getItems() {
		return items;
	}

	public void addItem(CartItem cartItem) {
		
		int menuID = cartItem.getMenuID();
		
		if(items.containsKey(cartItem)) 
		{
			CartItem existingCartItem = items.get(menuID);
			existingCartItem.setQty(existingCartItem.getQty()+1);
		}
		else
		{
			items.put(menuID, cartItem);
		}
	}

	public void updateItem(CartItem cartItem) {
		
		
	}

	public void removeItem(CartItem cartItem) {
		// TODO Auto-generated method stub
		
	}
	
	
	
	
}
