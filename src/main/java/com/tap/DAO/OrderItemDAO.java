package com.tap.DAO;

import java.util.List;
import com.tap.model.OrderItem;

public interface OrderItemDAO {

	void addOrderItem(OrderItem orderItem);

	OrderItem getOrderItem(int orderItemID);

	void updateOrderItem(OrderItem orderItem);

	void deleteOrderItem(int orderItemID);

	List<OrderItem> getAllOrderItems();
}