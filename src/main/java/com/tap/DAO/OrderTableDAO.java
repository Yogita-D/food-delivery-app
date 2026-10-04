package com.tap.DAO;

import java.util.List;
import com.tap.model.OrderTable;

public interface OrderTableDAO {

	int addOrder(OrderTable order);

	OrderTable getOrder(int orderID);

	void updateOrder(OrderTable order);

	void deleteOrder(int orderID);

	List<OrderTable> getAllOrder();
}