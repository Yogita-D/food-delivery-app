<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.Cart"%>
<%@ page import="com.tap.model.CartItem"%>
<%@ page import="com.tap.model.User"%>

<%!
    // Escape text before printing it into HTML
    private String esc(Object o) {
        if (o == null) return "";
        return o.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String money(double v) {
        return String.format("%.2f", v);
    }
%>

<%
    // Must be logged in
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }

    // Cart must have items
    Cart cart = (Cart) session.getAttribute("cart");

    if (cart == null || cart.getItems().isEmpty()) {
        response.sendRedirect("Cart.jsp");
        return;
    }

    int restaurantID = 0;
    int totalQty = 0;
    double subtotal = 0;

    for (CartItem ci : cart.getItems().values()) {
        restaurantID = ci.getRestaurantID();
        totalQty += ci.getQty();
        subtotal += ci.getPrice() * ci.getQty();
    }

    // IMPORTANT: these two must match OrderServlet.java
    double deliveryCharges = 40;
    double gst = subtotal * 0.05;

    double total = subtotal + deliveryCharges + gst;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Checkout</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',Arial,sans-serif;
}

body{
    background:#f5f5f5;
    color:#333;
}

/*================ TOP BAR ================*/

.topbar{
    position:sticky;
    top:0;
    z-index:100;
    background:#ff6b35;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:12px 40px;
    box-shadow:0 2px 10px rgba(0,0,0,0.2);
}

.topbar a{
    background:white;
    color:#ff6b35;
    text-decoration:none;
    padding:8px 18px;
    border-radius:6px;
    font-size:14px;
    font-weight:600;
}

.topbar a:hover{ background:#ffe3d6; }

.topbar .brand{
    background:none;
    color:white;
    font-size:20px;
    font-weight:700;
    padding:0;
}

.topbar .brand:hover{ background:none; }

/*================ TITLE ================*/

.title{
    background:linear-gradient(135deg,#ff6b35,#ff9a5c);
    color:white;
    text-align:center;
    padding:35px 20px 45px;
}

.title h1{ font-size:34px; }

.title p{
    margin-top:6px;
    opacity:0.95;
}

/*================ LAYOUT ================*/

.layout{
    width:92%;
    max-width:1100px;
    margin:-25px auto 40px;
    display:grid;
    grid-template-columns:1fr 360px;
    gap:25px;
    align-items:start;
}

.box{
    background:white;
    border-radius:14px;
    padding:24px;
    box-shadow:0 3px 10px rgba(0,0,0,0.12);
    margin-bottom:20px;
}

.box h2{
    font-size:19px;
    margin-bottom:16px;
}

.box h2 span{
    display:inline-block;
    background:#ff6b35;
    color:white;
    width:28px;
    height:28px;
    line-height:28px;
    text-align:center;
    border-radius:50%;
    font-size:14px;
    margin-right:8px;
}

/*================ DELIVERY ================*/

.address{
    background:#fff3ee;
    border-radius:10px;
    padding:16px 18px;
    line-height:1.7;
}

.address b{ font-size:17px; }

.address .addr{ color:#555; }

.hint{
    margin-top:10px;
    font-size:12px;
    color:#888;
}

/*================ PAYMENT ================*/

.pay-options{
    display:grid;
    gap:12px;
}

.pay-option input{
    position:absolute;
    opacity:0;
}

.pay-option{
    position:relative;
}

.pay-card{
    display:flex;
    align-items:center;
    gap:14px;
    border:2px solid #e5e5e5;
    border-radius:12px;
    padding:14px 18px;
    cursor:pointer;
    transition:0.2s;
}

.pay-card:hover{ border-color:#ffb27d; }

.pay-card .icon{
    font-size:28px;
    width:44px;
    height:44px;
    background:#fff3ee;
    border-radius:10px;
    display:flex;
    align-items:center;
    justify-content:center;
}

.pay-card .text b{ display:block; }

.pay-card .text small{ color:#888; }

.pay-card .tick{
    margin-left:auto;
    width:22px;
    height:22px;
    border:2px solid #ccc;
    border-radius:50%;
}

.pay-option input:checked + .pay-card{
    border-color:#ff6b35;
    background:#fff8f4;
}

.pay-option input:checked + .pay-card .tick{
    border-color:#ff6b35;
    background:#ff6b35;
    box-shadow:inset 0 0 0 4px white;
}

.pay-option input:focus-visible + .pay-card{
    outline:3px solid #ffb27d;
}

/*================ SUMMARY ================*/

.summary{
    position:sticky;
    top:80px;
}

.sum-items{
    max-height:220px;
    overflow-y:auto;
    margin-bottom:12px;
}

.sum-item{
    display:flex;
    justify-content:space-between;
    gap:10px;
    padding:7px 0;
    font-size:14px;
    color:#555;
}

.sum-item b{ color:#333; }

.row{
    display:flex;
    justify-content:space-between;
    padding:7px 0;
    color:#555;
}

.row.total{
    border-top:2px dashed #ddd;
    margin-top:10px;
    padding-top:16px;
    font-size:20px;
    font-weight:700;
    color:#333;
}

.row.total span:last-child{ color:#ff6b35; }

.place-btn{
    display:block;
    width:100%;
    margin-top:20px;
    padding:15px;
    border:none;
    border-radius:10px;
    background:#ff6b35;
    color:white;
    font-size:17px;
    font-weight:600;
    cursor:pointer;
    transition:0.2s;
}

.place-btn:hover{ background:#e85a28; }

.place-btn:disabled{
    background:#ccc;
    cursor:not-allowed;
}

.back{
    display:block;
    text-align:center;
    margin-top:14px;
    color:#ff6b35;
    text-decoration:none;
    font-weight:600;
    font-size:14px;
}

.note{
    margin-top:12px;
    text-align:center;
    font-size:12px;
    color:#888;
}

@media (max-width:850px){
    .layout{ grid-template-columns:1fr; }
    .summary{ position:static; }
    .topbar{ padding:12px 16px; }
}

</style>

</head>

<body>

<!-- ================= TOP BAR ================= -->

<div class="topbar">
    <a class="brand" href="Restaurant">🍔 Food Delivery App</a>
    <a href="Cart.jsp">← Back to cart</a>
</div>


<!-- ================= TITLE ================= -->

<section class="title">
    <h1>Checkout</h1>
    <p>Almost there, <%= esc(user.getUserName()) %>! Just one more step. 🎉</p>
</section>


<!-- ================= FORM ================= -->

<form action="OrderServlet" method="post" id="orderForm">

<input type="hidden" name="restaurantID" value="<%= restaurantID %>">

<div class="layout">

    <!-- ============ LEFT ============ -->

    <div>

        <div class="box">

            <h2><span>1</span>Delivery details</h2>

            <div class="address">
                <b><%= esc(user.getUserName()) %></b><br>
                <span class="addr">📍 <%= esc(user.getAddress()) %></span><br>
                <span class="addr">✉️ <%= esc(user.getEmail()) %></span>
            </div>

            <div class="hint">Delivering to your profile address.</div>

        </div>

        <div class="box">

            <h2><span>2</span>Payment method</h2>

            <div class="pay-options">

                <label class="pay-option">
                    <input type="radio" name="paymentMode" value="UPI" checked>
                    <div class="pay-card">
                        <div class="icon">📱</div>
                        <div class="text"><b>UPI</b><small>Google Pay, PhonePe, Paytm</small></div>
                        <div class="tick"></div>
                    </div>
                </label>

                <label class="pay-option">
                    <input type="radio" name="paymentMode" value="Card">
                    <div class="pay-card">
                        <div class="icon">💳</div>
                        <div class="text"><b>Credit / Debit Card</b><small>Visa, Mastercard, RuPay</small></div>
                        <div class="tick"></div>
                    </div>
                </label>

                <label class="pay-option">
                    <input type="radio" name="paymentMode" value="Cash on Delivery">
                    <div class="pay-card">
                        <div class="icon">💵</div>
                        <div class="text"><b>Cash on Delivery</b><small>Pay when your food arrives</small></div>
                        <div class="tick"></div>
                    </div>
                </label>

            </div>

        </div>

    </div>


    <!-- ============ SUMMARY ============ -->

    <aside class="box summary">

        <h2>Order summary</h2>

        <div class="sum-items">

        <% for (CartItem item : cart.getItems().values()) { %>

            <div class="sum-item">
                <span><%= esc(item.getName()) %> × <%= item.getQty() %></span>
                <b>₹<%= money(item.getPrice() * item.getQty()) %></b>
            </div>

        <% } %>

        </div>

        <div class="row">
            <span>Subtotal (<%= totalQty %> item<%= totalQty == 1 ? "" : "s" %>)</span>
            <span>₹<%= money(subtotal) %></span>
        </div>

        <div class="row">
            <span>Delivery charges</span>
            <span>₹<%= money(deliveryCharges) %></span>
        </div>

        <div class="row">
            <span>GST (5%)</span>
            <span>₹<%= money(gst) %></span>
        </div>

        <div class="row total">
            <span>To pay</span>
            <span>₹<%= money(total) %></span>
        </div>

        <button type="submit" class="place-btn" id="placeBtn">Place Order · ₹<%= money(total) %></button>

        <a class="back" href="Cart.jsp">← Edit cart</a>

        <div class="note">🔒 Safe and secure checkout</div>

    </aside>

</div>

</form>

<script>

/* Stop double clicks from placing the same order twice */

document.getElementById("orderForm").addEventListener("submit", function () {
    var btn = document.getElementById("placeBtn");
    btn.disabled = true;
    btn.textContent = "Placing your order...";
});

</script>

</body>
</html>
