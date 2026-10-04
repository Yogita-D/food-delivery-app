<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.OrderTable"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>My Orders</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    background: #f5f5f5;
}

/* ================= HEADER ================= */

header {
    background: #ff6b35;
    color: white;
    height: 100px;

    display: flex;
    align-items: center;
    justify-content: center;

    position: relative;
}

header h1 {
    font-size: 30px;
}

/* ================= BACK BUTTON ================= */

.back-btn {
    position: absolute;
    left: 30px;
    top: 30px;

    background: white;
    color: #ff6b35;

    text-decoration: none;

    padding: 10px 20px;

    border-radius: 5px;

    font-weight: bold;
}

.back-btn:hover {
    background: #eeeeee;
}

/* ================= CONTAINER ================= */

.container {

    width: 90%;

    max-width: 1000px;

    margin: 30px auto;
}

/* ================= ORDER CARD ================= */

.order-card {

    background: white;

    margin-bottom: 20px;

    padding: 25px;

    border-radius: 10px;

    box-shadow:
        0 3px 10px rgba(0,0,0,0.15);
}

/* ================= ORDER HEADER ================= */

.order-header {

    display: flex;

    justify-content: space-between;

    align-items: center;

    padding-bottom: 15px;

    border-bottom: 1px solid #eeeeee;
}

.order-header h2 {

    color: #333;

    font-size: 20px;
}

/* ================= STATUS ================= */

.status {

    padding: 7px 15px;

    border-radius: 20px;

    font-weight: bold;

    color: white;

    background: #ff6b35;
}

/* ================= DETAILS ================= */

.order-details {

    display: grid;

    grid-template-columns:
        repeat(auto-fit, minmax(200px, 1fr));

    gap: 15px;

    padding-top: 20px;
}

.detail {

    color: #555;

    font-size: 16px;
}

.detail b {

    color: #333;
}

/* ================= EMPTY ORDERS ================= */

.empty-orders {

    background: white;

    text-align: center;

    padding: 50px;

    border-radius: 10px;

    box-shadow:
        0 3px 10px rgba(0,0,0,0.15);
}

.empty-orders h2 {

    color: #555;

    margin-bottom: 20px;
}

.browse-btn {

    display: inline-block;

    background: #ff6b35;

    color: white;

    text-decoration: none;

    padding: 12px 25px;

    border-radius: 5px;

    font-weight: bold;
}

.browse-btn:hover {

    background: #e85a28;
}

</style>

</head>


<body>


<!-- ================= HEADER ================= -->

<header>

    <a href="Restaurant" class="back-btn">
        ← Back
    </a>

    <h1>
        My Orders
    </h1>

</header>


<!-- ================= ORDERS ================= -->

<div class="container">


<%

List<OrderTable> orders =
    (List<OrderTable>) request.getAttribute("orders");


if (orders != null && !orders.isEmpty()) {


    for (OrderTable order : orders) {

%>


<div class="order-card">


    <!-- ORDER HEADER -->

    <div class="order-header">

        <h2>
            Order #<%= order.getOrderID() %>
        </h2>

        <span class="status">
            <%= order.getStatus() %>
        </span>

    </div>


    <!-- ORDER DETAILS -->

    <div class="order-details">


        <div class="detail">

            <b>Order Date:</b>

            <%= order.getOrderDate() %>

        </div>


        <div class="detail">

            <b>Total Amount:</b>

            ₹<%= String.format("%.2f",
                    order.getTotalAmount()) %>

        </div>


        <div class="detail">

            <b>Payment Method:</b>

            <%= order.getPaymentMethod() %>

        </div>


        <div class="detail">

            <b>Restaurant ID:</b>

            <%= order.getRestaurantID() %>

        </div>


    </div>


</div>


<%

    }

} else {

%>


<!-- ================= NO ORDERS ================= -->


<div class="empty-orders">

    <h2>
        You haven't placed any orders yet.
    </h2>

    <a href="Restaurant" class="browse-btn">
        Browse Restaurants
    </a>

</div>


<%

}

%>


</div>


</body>

</html>