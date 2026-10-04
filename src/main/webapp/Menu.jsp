<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Menu"%>
<%@ page import="com.tap.model.Cart"%>
<%@ page import="com.tap.model.CartItem"%>

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
    List<Menu> allMenu = (List<Menu>) request.getAttribute("allMenu");

    int restaurantID = (allMenu != null && !allMenu.isEmpty())
            ? allMenu.get(0).getRestaurantID() : 0;

    // Items already in the cart (only counted if they belong to this restaurant)
    int cartCount = 0;
    double cartTotal = 0;

    Cart cart = (Cart) session.getAttribute("cart");

    if (cart != null && !cart.getItems().isEmpty()) {
        for (CartItem ci : cart.getItems().values()) {
            if (ci.getRestaurantID() == restaurantID) {
                cartCount += ci.getQty();
                cartTotal += ci.getPrice() * ci.getQty();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Restaurant Menu</title>

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
    padding-bottom:90px;
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

/*================ HERO ================*/

.hero{
    background:linear-gradient(135deg,#ff6b35,#ff9a5c);
    color:white;
    text-align:center;
    padding:45px 20px 55px;
    position:relative;
    overflow:hidden;
}

.hero::before{
    content:"";
    position:absolute;
    width:280px;
    height:280px;
    border-radius:50%;
    background:rgba(255,255,255,0.10);
    top:-110px;
    right:-60px;
}

.hero > *{ position:relative; z-index:1; }

.hero h1{
    font-size:38px;
    margin-bottom:8px;
}

.hero p{
    font-size:17px;
    opacity:0.95;
    margin-bottom:24px;
}

.search-box{
    max-width:520px;
    margin:0 auto;
}

.search-box input{
    width:100%;
    padding:15px 22px;
    border:none;
    border-radius:40px;
    font-size:16px;
    outline:none;
    box-shadow:0 6px 20px rgba(0,0,0,0.2);
}

/*================ TOOLS ================*/

.tools{
    width:90%;
    max-width:1200px;
    margin:25px auto 0;
    display:flex;
    flex-wrap:wrap;
    align-items:center;
    gap:20px;
    font-size:14px;
}

.tools select{
    padding:8px 12px;
    border:1px solid #ccc;
    border-radius:6px;
    font-size:14px;
    background:white;
}

.tools label{ cursor:pointer; }

#resultCount{
    margin-left:auto;
    color:#777;
}

/*================ MENU GRID ================*/

.container{
    width:90%;
    max-width:1200px;
    margin:20px auto 40px;
    display:grid;
    grid-template-columns:repeat(auto-fill,minmax(350px,1fr));
    gap:22px;
}

.card{
    background:white;
    border-radius:16px;
    overflow:hidden;
    display:flex;
    box-shadow:0 3px 10px rgba(0,0,0,0.12);
    transition:0.3s;
}

.card:hover{
    transform:translateY(-5px);
    box-shadow:0 12px 25px rgba(0,0,0,0.2);
}

.img-wrap{
    position:relative;
    width:120px;
    min-height:100%;
    flex-shrink:0;
    overflow:hidden;
    background:linear-gradient(135deg,#ffd9c9,#ffb27d);
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:46px;
}

.img-wrap img{
    position:absolute;
    inset:0;
    width:100%;
    height:100%;
    object-fit:cover;
    transition:0.4s;
}

.card:hover .img-wrap img{ transform:scale(1.1); }

.badge{
    position:absolute;
    top:8px;
    left:8px;
    z-index:2;
    background:#ff6b35;
    color:white;
    font-size:11px;
    font-weight:600;
    padding:3px 10px;
    border-radius:20px;
    box-shadow:0 2px 6px rgba(0,0,0,0.3);
}

.content{
    flex:1;
    padding:16px 18px;
    display:flex;
    flex-direction:column;
}

.content h2{
    font-size:18px;
    margin-bottom:4px;
}

.rating-pill{
    align-self:flex-start;
    background:#1d9a6c;
    color:white;
    font-size:12px;
    font-weight:600;
    padding:2px 9px;
    border-radius:6px;
    margin-bottom:8px;
}

.desc{
    color:#777;
    font-size:13px;
    line-height:1.5;
    margin-bottom:12px;
    display:-webkit-box;
    -webkit-line-clamp:2;
    -webkit-box-orient:vertical;
    overflow:hidden;
}

.bottom{
    margin-top:auto;
}

.price{
    color:#ff6b35;
    font-size:22px;
    font-weight:700;
    margin-bottom:10px;
}

.add-row{
    display:flex;
    align-items:center;
    gap:10px;
}

.stepper{
    display:flex;
    align-items:center;
    border:2px solid #ff6b35;
    border-radius:8px;
    overflow:hidden;
}

.stepper button{
    width:32px;
    height:34px;
    border:none;
    background:white;
    color:#ff6b35;
    font-size:18px;
    font-weight:700;
    cursor:pointer;
}

.stepper button:hover{ background:#ffe3d6; }

.stepper span{
    min-width:28px;
    text-align:center;
    font-weight:600;
}

.addBtn{
    flex:1;
    white-space:nowrap;
    padding:9px 10px;
    background:#ff6b35;
    color:white;
    border:none;
    border-radius:8px;
    font-size:14px;
    font-weight:600;
    cursor:pointer;
    transition:0.2s;
}

.addBtn:hover{ background:#e85a28; }

/* Unavailable items */

.card.unavailable .img-wrap img{ filter:grayscale(1); }
.card.unavailable .price{ color:#999; }

.soldout{
    display:block;
    text-align:center;
    background:#eee;
    color:#999;
    padding:9px;
    border-radius:8px;
    font-size:14px;
    font-weight:600;
}

.no-results{
    grid-column:1 / -1;
    text-align:center;
    padding:50px 20px;
    color:#777;
    font-size:18px;
}

/*================ FLOATING CART BAR ================*/

.cartbar{
    position:fixed;
    left:50%;
    bottom:20px;
    transform:translateX(-50%);
    width:90%;
    max-width:700px;
    background:#333;
    color:white;
    border-radius:14px;
    padding:14px 22px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    box-shadow:0 8px 25px rgba(0,0,0,0.35);
    z-index:200;
}

.cartbar a{
    background:#ff6b35;
    color:white;
    text-decoration:none;
    padding:9px 20px;
    border-radius:8px;
    font-weight:600;
}

.cartbar a:hover{ background:#e85a28; }

@media (max-width:600px){
    .topbar{ padding:12px 16px; }
    .hero h1{ font-size:28px; }
    .card{ flex-direction:column; }
    .img-wrap{ width:100%; height:160px; min-height:160px; }
    #resultCount{ margin-left:0; width:100%; }
}

</style>

</head>

<body>

<!-- ================= TOP BAR ================= -->

<div class="topbar">
    <a class="brand" href="Restaurant">← Back to restaurants</a>
    <a href="Cart.jsp">🛒 Cart</a>
</div>


<!-- ================= HERO ================= -->

<section class="hero">

    <h1>Pick your favourites 😋</h1>
    <p>Freshly made, hot and delivered to your door.</p>

    <div class="search-box">
        <input type="text" id="searchInput" placeholder="🔍  Search dishes...">
    </div>

</section>


<!-- ================= TOOLS ================= -->

<div class="tools">

    <div>
        Sort by:
        <select id="sortSelect">
            <option value="default">Recommended</option>
            <option value="rating">Rating: High to Low</option>
            <option value="low">Price: Low to High</option>
            <option value="high">Price: High to Low</option>
        </select>
    </div>

    <label>
        <input type="checkbox" id="availableOnly"> Available only
    </label>

    <span id="resultCount"></span>

</div>


<!-- ================= MENU ITEMS ================= -->

<div class="container" id="menuContainer">

<%
    if (allMenu != null && !allMenu.isEmpty()) {

        int position = 0;

        for (Menu menu : allMenu) {

            position++;

            boolean bestseller = menu.getRatings() >= 4.5;
            boolean hasImage = menu.getImagePath() != null && !menu.getImagePath().trim().isEmpty();
%>

<div class="card <%= menu.isAvailable() ? "" : "unavailable" %>"
     data-name="<%= esc(menu.getItemName()).toLowerCase() %>"
     data-desc="<%= esc(menu.getDescription()).toLowerCase() %>"
     data-price="<%= menu.getPrice() %>"
     data-rating="<%= menu.getRatings() %>"
     data-available="<%= menu.isAvailable() %>"
     data-pos="<%= position %>">

    <div class="img-wrap">

        🍽️

        <% if (hasImage) { %>
            <img src="<%= esc(menu.getImagePath()) %>"
                 alt="<%= esc(menu.getItemName()) %>"
                 onerror="this.style.display='none'">
        <% } %>

        <% if (bestseller) { %><span class="badge">⭐ Bestseller</span><% } %>

    </div>

    <div class="content">

        <h2><%= esc(menu.getItemName()) %></h2>

        <% if (menu.getRatings() > 0) { %>
            <span class="rating-pill">★ <%= menu.getRatings() %></span>
        <% } %>

        <p class="desc"><%= esc(menu.getDescription()) %></p>

        <div class="bottom">

            <div class="price">₹<%= money(menu.getPrice()) %></div>

            <% if (menu.isAvailable()) { %>

            <form action="cartServlet" method="post" class="add-row">

                <input type="hidden" name="menuID" value="<%= menu.getMenuID() %>">
                <input type="hidden" name="restaurantID" value="<%= menu.getRestaurantID() %>">
                <input type="hidden" name="qty" value="1" class="qtyInput">
                <input type="hidden" name="action" value="add">

                <div class="stepper">
                    <button type="button" class="minus">−</button>
                    <span class="qtyText">1</span>
                    <button type="button" class="plus">+</button>
                </div>

                <button type="submit" class="addBtn">Add to Cart</button>

            </form>

            <% } else { %>

                <span class="soldout">Currently unavailable</span>

            <% } %>

        </div>

    </div>

</div>

<%
        }

    } else {
%>

<div class="no-results">😕 No menu items available for this restaurant yet.</div>

<%
    }
%>

</div>


<!-- ================= FLOATING CART BAR ================= -->

<% if (cartCount > 0) { %>

<div class="cartbar">
    <span>🛒 <b><%= cartCount %></b> item<%= cartCount == 1 ? "" : "s" %> &nbsp;|&nbsp; ₹<%= money(cartTotal) %></span>
    <a href="Cart.jsp">View Cart →</a>
</div>

<% } %>


<!-- ================= SCRIPT ================= -->

<script>

(function () {

    var container   = document.getElementById("menuContainer");
    var cards       = Array.prototype.slice.call(container.querySelectorAll(".card"));
    var searchEl    = document.getElementById("searchInput");
    var sortEl      = document.getElementById("sortSelect");
    var availableEl = document.getElementById("availableOnly");
    var countEl     = document.getElementById("resultCount");

    var emptyMsg = document.createElement("div");
    emptyMsg.className = "no-results";
    emptyMsg.textContent = "😕 No dishes match your search.";
    emptyMsg.style.display = "none";
    container.appendChild(emptyMsg);

    /* ---------- quantity stepper (min 1, max 10) ---------- */

    container.addEventListener("click", function (e) {

        var minus = e.target.closest(".minus");
        var plus  = e.target.closest(".plus");

        if (!minus && !plus) return;

        var form  = e.target.closest("form");
        var input = form.querySelector(".qtyInput");
        var text  = form.querySelector(".qtyText");

        var qty = parseInt(input.value, 10);

        if (plus  && qty < 10) qty++;
        if (minus && qty > 1)  qty--;

        input.value = qty;
        text.textContent = qty;
    });

    /* ---------- search / sort / filter ---------- */

    function apply() {

        var q = searchEl.value.trim().toLowerCase();
        var visible = [];

        cards.forEach(function (card) {

            var matchSearch = !q
                || card.dataset.name.indexOf(q) !== -1
                || card.dataset.desc.indexOf(q) !== -1;

            var matchAvail = !availableEl.checked || card.dataset.available === "true";

            var show = matchSearch && matchAvail;

            card.style.display = show ? "" : "none";

            if (show) visible.push(card);
        });

        var mode = sortEl.value;

        visible.sort(function (a, b) {
            if (mode === "rating") return parseFloat(b.dataset.rating) - parseFloat(a.dataset.rating);
            if (mode === "low")    return parseFloat(a.dataset.price)  - parseFloat(b.dataset.price);
            if (mode === "high")   return parseFloat(b.dataset.price)  - parseFloat(a.dataset.price);
            return parseInt(a.dataset.pos, 10) - parseInt(b.dataset.pos, 10);
        });

        visible.forEach(function (card) { container.insertBefore(card, emptyMsg); });

        emptyMsg.style.display = (visible.length === 0 && cards.length > 0) ? "block" : "none";

        countEl.textContent = cards.length
            ? visible.length + " dish" + (visible.length === 1 ? "" : "es")
            : "";
    }

    searchEl.addEventListener("input", apply);
    sortEl.addEventListener("change", apply);
    availableEl.addEventListener("change", apply);

    apply();

})();

</script>

</body>
</html>
