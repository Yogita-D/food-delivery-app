<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>
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
%>

<%
    // Logged-in user (null if nobody is logged in)
    User loggedUser = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Restaurants</title>

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

/*================ NAVBAR (sticky) ================*/

.topbar{
    position:sticky;
    top:0;
    z-index:100;
    background:#ff6b35;
    color:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:12px 40px;
    box-shadow:0 2px 10px rgba(0,0,0,0.2);
}

.brand{
    font-size:22px;
    font-weight:700;
    text-decoration:none;
    color:white;
}

.navbar{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
}

.navbar a{
    background:white;
    color:#ff6b35;
    text-decoration:none;
    padding:8px 18px;
    border-radius:6px;
    font-size:14px;
    font-weight:600;
    transition:0.2s;
}

.navbar a:hover{
    background:#ffe3d6;
}

/*================ HERO ================*/

.hero{
    background:linear-gradient(135deg,#ff6b35,#ff9a5c);
    color:white;
    text-align:center;
    padding:60px 20px 70px;
    position:relative;
    overflow:hidden;
}

.hero::before,
.hero::after{
    content:"";
    position:absolute;
    border-radius:50%;
    background:rgba(255,255,255,0.10);
}

.hero::before{ width:320px; height:320px; top:-120px; right:-80px; }
.hero::after { width:260px; height:260px; bottom:-120px; left:-60px; }

.hero > *{ position:relative; z-index:1; }

.hero .greeting{
    font-size:16px;
    opacity:0.95;
    margin-bottom:8px;
}

.hero h1{
    font-size:42px;
    line-height:1.2;
    margin-bottom:12px;
}

.hero p.sub{
    font-size:18px;
    opacity:0.95;
    margin-bottom:28px;
}

.search-box{
    max-width:560px;
    margin:0 auto;
}

.search-box input{
    width:100%;
    padding:16px 22px;
    border:none;
    border-radius:40px;
    font-size:16px;
    outline:none;
    box-shadow:0 6px 20px rgba(0,0,0,0.2);
}

/*================ OFFER STRIP ================*/

.offer{
    background:#333;
    color:white;
    text-align:center;
    padding:12px 20px;
    font-size:15px;
}

.offer b{
    color:#ffb27d;
}

/*================ FILTERS ================*/

.filters{
    width:90%;
    max-width:1300px;
    margin:30px auto 0;
}

.filters h3{
    font-size:20px;
    margin-bottom:14px;
}

.chips{
    display:flex;
    flex-wrap:wrap;
    gap:10px;
}

.chip{
    border:2px solid #ff6b35;
    background:white;
    color:#ff6b35;
    padding:8px 20px;
    border-radius:30px;
    cursor:pointer;
    font-size:14px;
    font-weight:600;
    transition:0.2s;
}

.chip:hover{
    background:#ffe3d6;
}

.chip.active{
    background:#ff6b35;
    color:white;
}

.tools{
    display:flex;
    flex-wrap:wrap;
    align-items:center;
    gap:20px;
    margin-top:18px;
    font-size:14px;
}

.tools select{
    padding:8px 12px;
    border:1px solid #ccc;
    border-radius:6px;
    font-size:14px;
    background:white;
}

.tools label{
    cursor:pointer;
}

#resultCount{
    margin-left:auto;
    color:#777;
}

/*================ CARDS ================*/

.container{
    width:90%;
    max-width:1300px;
    margin:25px auto 40px;
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(290px,1fr));
    gap:25px;
}

.card{
    background:white;
    border-radius:14px;
    overflow:hidden;
    box-shadow:0 3px 10px rgba(0,0,0,0.15);
    transition:0.3s;
    position:relative;
}

.card:hover{
    transform:translateY(-8px);
    box-shadow:0 12px 25px rgba(0,0,0,0.22);
}

.card .img-wrap{
    overflow:hidden;
    height:200px;
    position:relative;
}

.card img{
    width:100%;
    height:100%;
    object-fit:cover;
    transition:0.4s;
}

.card:hover img{
    transform:scale(1.08);
}

.badges{
    position:absolute;
    top:12px;
    left:12px;
    display:flex;
    flex-direction:column;
    gap:6px;
    align-items:flex-start;
}

.badge{
    background:#ff6b35;
    color:white;
    padding:4px 12px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
    box-shadow:0 2px 6px rgba(0,0,0,0.3);
}

.badge.fast{ background:#1d9a6c; }

.card-content{
    padding:16px 18px 18px;
}

.card-content h2{
    font-size:20px;
    margin-bottom:4px;
}

.cuisine{
    color:#777;
    font-size:14px;
    margin-bottom:12px;
}

.meta{
    display:flex;
    align-items:center;
    gap:12px;
    margin-bottom:10px;
    font-size:14px;
}

.rating-pill{
    background:#1d9a6c;
    color:white;
    padding:3px 10px;
    border-radius:6px;
    font-weight:600;
}

.address{
    color:#666;
    font-size:14px;
    margin-bottom:10px;
}

.status{
    font-weight:600;
    font-size:14px;
}

.dot{
    display:inline-block;
    width:9px;
    height:9px;
    border-radius:50%;
    margin-right:6px;
}

.open  { color:#1d9a6c; }
.open .dot  { background:#1d9a6c; }
.closed{ color:#d32f2f; }
.closed .dot{ background:#d32f2f; }

.card.is-closed img{
    filter:grayscale(1);
}

.viewBtn{
    display:block;
    width:100%;
    padding:12px;
    margin-top:14px;
    background:#ff6b35;
    color:white;
    text-align:center;
    text-decoration:none;
    border-radius:8px;
    font-size:16px;
    font-weight:600;
    transition:0.2s;
}

.viewBtn:hover{
    background:#e85a28;
}

.no-results{
    grid-column:1 / -1;
    text-align:center;
    padding:50px 20px;
    color:#777;
    font-size:18px;
}

/*================ WHY US ================*/

.why{
    background:white;
    padding:45px 20px;
    text-align:center;
}

.why h3{
    font-size:24px;
    margin-bottom:28px;
}

.why-grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:25px;
    max-width:1000px;
    margin:0 auto;
}

.why-item .icon{
    font-size:42px;
    margin-bottom:10px;
}

.why-item h4{
    margin-bottom:6px;
    color:#ff6b35;
}

.why-item p{
    color:#666;
    font-size:14px;
}

/*================ FOOTER ================*/

footer{
    background:#222;
    color:#ddd;
    text-align:center;
    padding:28px 20px;
    font-size:14px;
}

footer b{ color:#ff9a5c; }

@media (max-width:700px){
    .topbar{ flex-direction:column; gap:10px; padding:12px 16px; }
    .hero h1{ font-size:30px; }
    #resultCount{ margin-left:0; width:100%; }
}

</style>

</head>

<body>

<!-- ================= NAVBAR ================= -->

<div class="topbar">

    <a class="brand" href="Restaurant">🍔 Food Delivery App</a>

    <div class="navbar">

        <a href="Restaurant">Home</a>

        <% if (loggedUser == null) { %>

            <a href="login.html">Sign In</a>
            <a href="register.html">Sign Up</a>
            <a href="Cart.jsp">Cart</a>

        <% } else { %>

            <a href="Cart.jsp">Cart</a>
            <a href="ProfileServlet">Profile</a>
            <a href="MyOrdersServlet">My Orders</a>
            <a href="LogoutServlet">Logout</a>

        <% } %>

    </div>

</div>


<!-- ================= HERO ================= -->

<section class="hero">

    <% if (loggedUser != null) { %>
        <div class="greeting">👋 Hey <%= esc(loggedUser.getUserName()) %>, welcome back!</div>
    <% } else { %>
        <div class="greeting">👋 Welcome, foodie!</div>
    <% } %>

    <h1>Hungry? We've got you covered.</h1>
    <p class="sub">Your favourite restaurants, delivered in minutes.</p>

    <div class="search-box">
        <input type="text" id="searchInput"
               placeholder="🔍  Search for restaurants, biryani, pizza, burgers...">
    </div>

</section>


<!-- ================= OFFER STRIP ================= -->




<!-- ================= FILTERS ================= -->

<section class="filters">

    <h3>What's on your mind?</h3>

    <div class="chips" id="chips">
        <button class="chip active" data-filter="all">🍽️ All</button>
        <button class="chip" data-filter="biryani">🍛 Biryani</button>
        <button class="chip" data-filter="pizza">🍕 Pizza</button>
        <button class="chip" data-filter="burger">🍔 Burgers</button>
        <button class="chip" data-filter="fast food">🍗 Fast Food</button>
        <button class="chip" data-filter="north indian">🥘 North Indian</button>
        <button class="chip" data-filter="south indian">🥞 South Indian</button>
    </div>

    <div class="tools">

        <div>
            Sort by:
            <select id="sortSelect">
                <option value="default">Recommended</option>
                <option value="rating">Rating: High to Low</option>
                <option value="time">Delivery time: Fastest</option>
            </select>
        </div>

        <label>
            <input type="checkbox" id="openOnly"> Open now only
        </label>

        <span id="resultCount"></span>

    </div>

</section>


<!-- ================= RESTAURANT CARDS ================= -->

<div class="container" id="cardContainer">

<%

List<Restaurant> allRestaurant=(List<Restaurant>)request.getAttribute("allRestaurant");

if(allRestaurant!=null && !allRestaurant.isEmpty()){

int position = 0;

for(Restaurant restaurant:allRestaurant){

    position++;

    boolean topRated = restaurant.getRating() >= 4.5;
    boolean fastest  = restaurant.getDeliveryTime() <= 20;

%>

<div class="card <%= restaurant.isActive() ? "" : "is-closed" %>"
     data-name="<%= esc(restaurant.getName()).toLowerCase() %>"
     data-cuisine="<%= esc(restaurant.getCuisineType()).toLowerCase() %>"
     data-rating="<%= restaurant.getRating() %>"
     data-time="<%= restaurant.getDeliveryTime() %>"
     data-open="<%= restaurant.isActive() %>"
     data-pos="<%= position %>">

    <div class="img-wrap">

        <img src="<%= esc(restaurant.getImagePath()) %>" alt="<%= esc(restaurant.getName()) %>">

        <div class="badges">
            <% if (topRated) { %><span class="badge">⭐ Top rated</span><% } %>
            <% if (fastest)  { %><span class="badge fast">⚡ Fast delivery</span><% } %>
        </div>

    </div>

    <div class="card-content">

        <h2><%= esc(restaurant.getName()) %></h2>

        <div class="cuisine"><%= esc(restaurant.getCuisineType()) %></div>

        <div class="meta">
            <span class="rating-pill">★ <%= restaurant.getRating() %></span>
            <span>🕒 <%= restaurant.getDeliveryTime() %> mins</span>
        </div>

        <div class="address">📍 <%= esc(restaurant.getAddress()) %></div>

        <div class="status">
            <% if (restaurant.isActive()) { %>
                <span class="open"><span class="dot"></span>Open</span>
            <% } else { %>
                <span class="closed"><span class="dot"></span>Closed</span>
            <% } %>
        </div>

        <a class="viewBtn" href="menu?restaurantId=<%= restaurant.getRestaurantID() %>">View Menu</a>

    </div>

</div>

<%

}

}else{

%>

<div class="no-results">😕 No Restaurants Available right now. Please check back soon!</div>

<%

}

%>

</div>


<!-- ================= WHY US ================= -->

<section class="why">

    <h3>Why order with us?</h3>

    <div class="why-grid">

        <div class="why-item">
            <div class="icon">⚡</div>
            <h4>Lightning fast</h4>
            <p>Most orders reach you in under 30 minutes.</p>
        </div>

        <div class="why-item">
            <div class="icon">🍲</div>
            <h4>Fresh &amp; hot</h4>
            <p>Made to order and packed to stay warm.</p>
        </div>

        <div class="why-item">
            <div class="icon">💸</div>
            <h4>Great offers</h4>
            <p>Discounts and deals on your favourite places.</p>
        </div>

    </div>

</section>


<footer>
    Made with ❤️ in <b>Bangalore</b> &nbsp;|&nbsp; © 2026 Food Delivery App
</footer>


<!-- ================= SEARCH / FILTER / SORT ================= -->

<script>

(function () {

    var container  = document.getElementById("cardContainer");
    var cards      = Array.prototype.slice.call(container.querySelectorAll(".card"));
    var searchEl   = document.getElementById("searchInput");
    var sortEl     = document.getElementById("sortSelect");
    var openOnlyEl = document.getElementById("openOnly");
    var chipsEl    = document.getElementById("chips");
    var countEl    = document.getElementById("resultCount");

    var activeFilter = "all";

    var emptyMsg = document.createElement("div");
    emptyMsg.className = "no-results";
    emptyMsg.textContent = "😕 No restaurants match your search. Try something else!";
    emptyMsg.style.display = "none";
    container.appendChild(emptyMsg);

    function apply() {

        var q = searchEl.value.trim().toLowerCase();
        var visible = [];

        cards.forEach(function (card) {

            var name    = card.dataset.name;
            var cuisine = card.dataset.cuisine;

            var matchSearch = !q || name.indexOf(q) !== -1 || cuisine.indexOf(q) !== -1;
            var matchChip   = activeFilter === "all" || cuisine.indexOf(activeFilter) !== -1;
            var matchOpen   = !openOnlyEl.checked || card.dataset.open === "true";

            var show = matchSearch && matchChip && matchOpen;

            card.style.display = show ? "" : "none";

            if (show) visible.push(card);
        });

        var mode = sortEl.value;

        visible.sort(function (a, b) {
            if (mode === "rating") return parseFloat(b.dataset.rating) - parseFloat(a.dataset.rating);
            if (mode === "time")   return parseInt(a.dataset.time, 10) - parseInt(b.dataset.time, 10);
            return parseInt(a.dataset.pos, 10) - parseInt(b.dataset.pos, 10);
        });

        visible.forEach(function (card) { container.insertBefore(card, emptyMsg); });

        emptyMsg.style.display = (visible.length === 0 && cards.length > 0) ? "block" : "none";

        countEl.textContent = cards.length
            ? visible.length + " restaurant" + (visible.length === 1 ? "" : "s") + " found"
            : "";
    }

    searchEl.addEventListener("input", apply);
    sortEl.addEventListener("change", apply);
    openOnlyEl.addEventListener("change", apply);

    chipsEl.addEventListener("click", function (e) {
        var chip = e.target.closest(".chip");
        if (!chip) return;
        Array.prototype.forEach.call(chipsEl.children, function (c) { c.classList.remove("active"); });
        chip.classList.add("active");
        activeFilter = chip.dataset.filter;
        apply();
    });

    apply();

})();

</script>

</body>
</html>
