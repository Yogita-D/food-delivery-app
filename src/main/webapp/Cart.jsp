<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.Cart"%>
<%@ page import="com.tap.model.CartItem"%>
<%@ page import="com.tap.model.Menu"%>
<%@ page import="com.tap.DAOImpl.MenuDAOImpl"%>

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

    // 250.0 -> "250"   |   249.5 -> "249.50"
    private String money(double v) {
        if (v == Math.floor(v)) return String.valueOf((long) v);
        return String.format("%.2f", v);
    }
%>

<%
    Cart cart = (Cart) session.getAttribute("cart");

    boolean hasItems = (cart != null && !cart.getItems().isEmpty());

    int restaurantID = 0;
    int totalQty = 0;
    double grandTotal = 0;

    if (hasItems) {
        for (CartItem ci : cart.getItems().values()) {
            restaurantID = ci.getRestaurantID();
            totalQty += ci.getQty();
            grandTotal += ci.getPrice() * ci.getQty();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Your Cart</title>

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

/*================ PAGE TITLE ================*/

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
    grid-template-columns:1fr 340px;
    gap:25px;
    align-items:start;
}

/*================ CART ITEMS ================*/

.items{
    display:flex;
    flex-direction:column;
    gap:16px;
}

.item{
    background:white;
    border-radius:14px;
    padding:18px 20px;
    display:flex;
    align-items:center;
    gap:18px;
    box-shadow:0 3px 10px rgba(0,0,0,0.12);
}

.thumb{
    width:70px;
    height:70px;
    border-radius:12px;
    background:linear-gradient(135deg,#ffd9c9,#ffb27d);
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:32px;
    flex-shrink:0;
    position:relative;
    overflow:hidden;
}

.thumb img{
    position:absolute;
    inset:0;
    width:100%;
    height:100%;
    object-fit:cover;
}

.info{
    flex:1;
    min-width:0;
}

.info h3{
    font-size:18px;
    margin-bottom:4px;
}

.unit{
    color:#777;
    font-size:14px;
}

.qty-box{
    display:flex;
    align-items:center;
    border:2px solid #ff6b35;
    border-radius:10px;
    overflow:hidden;
}

.qty-box form{ display:flex; }

.qty-box button{
    width:36px;
    height:38px;
    border:none;
    background:white;
    color:#ff6b35;
    font-size:20px;
    font-weight:700;
    cursor:pointer;
}

.qty-box button:hover{ background:#ffe3d6; }

.qty-box span{
    min-width:34px;
    text-align:center;
    font-weight:600;
}

.line-total{
    min-width:80px;
    text-align:right;
    color:#ff6b35;
    font-size:19px;
    font-weight:700;
}

.remove-btn{
    background:none;
    border:none;
    color:#d32f2f;
    font-size:20px;
    cursor:pointer;
    padding:6px 8px;
    border-radius:8px;
}

.remove-btn:hover{ background:#fdeaea; }

/*================ SUMMARY ================*/

.summary{
    background:white;
    border-radius:14px;
    padding:24px;
    box-shadow:0 3px 10px rgba(0,0,0,0.12);
    position:sticky;
    top:80px;
}

.summary h2{
    font-size:20px;
    margin-bottom:16px;
}

.row{
    display:flex;
    justify-content:space-between;
    padding:8px 0;
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

.checkout-btn,
.more-btn{
    display:block;
    width:100%;
    padding:14px;
    border-radius:10px;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    text-align:center;
    text-decoration:none;
}

.checkout-btn{
    margin-top:20px;
    background:#ff6b35;
    color:white;
    border:none;
    transition:0.2s;
}

.checkout-btn:hover{ background:#e85a28; }

.more-btn{
    margin-top:12px;
    background:white;
    color:#ff6b35;
    border:2px solid #ff6b35;
}

.more-btn:hover{ background:#ffe3d6; }

.note{
    margin-top:14px;
    text-align:center;
    font-size:12px;
    color:#888;
}

/*================ EMPTY CART ================*/

.empty{
    width:92%;
    max-width:600px;
    margin:-25px auto 60px;
    background:white;
    border-radius:16px;
    padding:50px 30px;
    text-align:center;
    box-shadow:0 3px 10px rgba(0,0,0,0.12);
}

.empty .big{ font-size:70px; }

.empty h2{
    margin:12px 0 8px;
    color:#444;
}

.empty p{
    color:#888;
    margin-bottom:24px;
}

.empty a{
    display:inline-block;
    background:#ff6b35;
    color:white;
    text-decoration:none;
    padding:13px 30px;
    border-radius:10px;
    font-weight:600;
}

.empty a:hover{ background:#e85a28; }

@media (max-width:850px){

    .layout{ grid-template-columns:1fr; }
    .summary{ position:static; }
    .topbar{ padding:12px 16px; }

    .item{
        flex-wrap:wrap;
    }

    .info{ flex:1 1 55%; }
}

</style>

</head>

<body>

<!-- ================= TOP BAR ================= -->

<div class="topbar">
    <a class="brand" href="Restaurant">🍔 Food Delivery App</a>
    <a href="Restaurant">Home</a>
</div>


<!-- ================= TITLE ================= -->

<section class="title">
    <h1>🛒 Your Cart</h1>
    <% if (hasItems) { %>
        <p><%= totalQty %> item<%= totalQty == 1 ? "" : "s" %> ready to order</p>
    <% } else { %>
        <p>Nothing here yet</p>
    <% } %>
</section>


<% if (hasItems) { %>

<div class="layout">

    <!-- ============ ITEMS ============ -->

    <div class="items">

    <%
        MenuDAOImpl menuDAO = new MenuDAOImpl();

        for (CartItem item : cart.getItems().values()) {

            double itemTotal = item.getPrice() * item.getQty();

            // Look up the dish photo from the menu table
            Menu menuInfo = menuDAO.getMenu(item.getMenuID());
            String imagePath = (menuInfo != null) ? menuInfo.getImagePath() : null;
            boolean hasImage = imagePath != null && !imagePath.trim().isEmpty();
    %>

        <div class="item">

            <div class="thumb">
                🍽️
                <% if (hasImage) { %>
                    <img src="<%= esc(imagePath) %>" alt="<%= esc(item.getName()) %>"
                         onerror="this.style.display='none'">
                <% } %>
            </div>

            <div class="info">
                <h3><%= esc(item.getName()) %></h3>
                <div class="unit">₹<%= money(item.getPrice()) %> each</div>
            </div>

            <!-- QUANTITY -->

            <div class="qty-box">

                <!-- MINUS: at quantity 1 it removes the item instead of going to 0 -->

                <form action="cartServlet" method="post">

                    <input type="hidden" name="menuID" value="<%= item.getMenuID() %>">
                    <input type="hidden" name="restaurantID" value="<%= item.getRestaurantID() %>">

                    <% if (item.getQty() > 1) { %>
                        <input type="hidden" name="qty" value="<%= item.getQty() - 1 %>">
                        <input type="hidden" name="action" value="update">
                    <% } else { %>
                        <input type="hidden" name="action" value="remove">
                    <% } %>

                    <button type="submit" title="Decrease">−</button>

                </form>

                <span><%= item.getQty() %></span>

                <!-- PLUS -->

                <form action="cartServlet" method="post">

                    <input type="hidden" name="menuID" value="<%= item.getMenuID() %>">
                    <input type="hidden" name="restaurantID" value="<%= item.getRestaurantID() %>">
                    <input type="hidden" name="qty" value="<%= item.getQty() + 1 %>">
                    <input type="hidden" name="action" value="update">

                    <button type="submit" title="Increase">+</button>

                </form>

            </div>

            <div class="line-total">₹<%= money(itemTotal) %></div>

            <!-- REMOVE -->

            <form action="cartServlet" method="post">

                <input type="hidden" name="menuID" value="<%= item.getMenuID() %>">
                <input type="hidden" name="restaurantID" value="<%= item.getRestaurantID() %>">
                <input type="hidden" name="action" value="remove">

                <button type="submit" class="remove-btn" title="Remove item">🗑️</button>

            </form>

        </div>

    <%
        }
    %>

    </div>


    <!-- ============ SUMMARY ============ -->

    <aside class="summary">

        <h2>Order Summary</h2>

        <div class="row">
            <span>Items (<%= totalQty %>)</span>
            <span>₹<%= money(grandTotal) %></span>
        </div>

        <div class="row total">
            <span>Grand Total</span>
            <span>₹<%= money(grandTotal) %></span>
        </div>

        <form action="Checkout.jsp" method="get">
            <button type="submit" class="checkout-btn">Proceed to Checkout →</button>
        </form>

        <a class="more-btn" href="menu?restaurantId=<%= restaurantID %>">+ Add More Items</a>

        <div class="note">🔒 Safe and secure checkout</div>

    </aside>

</div>

<% } else { %>

<!-- ================= EMPTY CART ================= -->

<div class="empty">

    <div class="big">🛒</div>

    <h2>Your cart is empty</h2>

    <p>Looks like you haven't added anything yet. Let's fix that!</p>

    <a href="Restaurant">Browse Restaurants</a>

</div>

<% } %>

</body>
</html>
