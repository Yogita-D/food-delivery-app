<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
    User user = (User) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }

    // First letter of the name, shown inside the avatar circle
    String name = user.getUserName() == null ? "" : user.getUserName().trim();
    String initial = name.isEmpty() ? "?" : name.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile</title>

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
    min-height:100vh;
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
    height:170px;
    position:relative;
    overflow:hidden;
}

.hero::before{
    content:"";
    position:absolute;
    width:300px;
    height:300px;
    border-radius:50%;
    background:rgba(255,255,255,0.10);
    top:-130px;
    right:-60px;
}

/*================ PROFILE ================*/

.wrap{
    width:92%;
    max-width:720px;
    margin:-80px auto 50px;
    position:relative;
    z-index:2;
}

.card{
    background:white;
    border-radius:18px;
    padding:0 34px 34px;
    box-shadow:0 8px 28px rgba(0,0,0,0.14);
    text-align:center;
}

.avatar{
    width:110px;
    height:110px;
    margin:0 auto 14px;
    position:relative;
    top:-55px;
    margin-bottom:-30px;
    border-radius:50%;
    background:#ff6b35;
    color:white;
    border:6px solid white;
    box-shadow:0 5px 15px rgba(0,0,0,0.2);
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:48px;
    font-weight:700;
}

.card h1{
    font-size:26px;
}

.role{
    display:inline-block;
    margin-top:8px;
    background:#fff3ee;
    color:#ff6b35;
    padding:4px 16px;
    border-radius:20px;
    font-size:13px;
    font-weight:600;
    text-transform:capitalize;
}

.details{
    margin-top:26px;
    text-align:left;
    display:grid;
    gap:12px;
}

.detail{
    display:flex;
    align-items:center;
    gap:16px;
    background:#fafafa;
    border-radius:12px;
    padding:14px 18px;
}

.detail .icon{
    width:44px;
    height:44px;
    flex-shrink:0;
    border-radius:10px;
    background:#fff3ee;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:22px;
}

.detail .label{
    font-size:12px;
    color:#999;
    text-transform:uppercase;
    letter-spacing:0.5px;
}

.detail .value{
    font-weight:600;
    word-break:break-word;
}

.buttons{
    display:flex;
    gap:12px;
    margin-top:28px;
    flex-wrap:wrap;
}

.btn{
    flex:1;
    min-width:150px;
    padding:13px 18px;
    border-radius:10px;
    text-decoration:none;
    font-weight:600;
    font-size:15px;
    transition:0.2s;
}

.btn.primary{
    background:#ff6b35;
    color:white;
}

.btn.primary:hover{ background:#e85a28; }

.btn.outline{
    background:white;
    color:#ff6b35;
    border:2px solid #ff6b35;
}

.btn.outline:hover{ background:#ffe3d6; }

.btn.logout{
    background:#444;
    color:white;
}

.btn.logout:hover{ background:#222; }

@media (max-width:600px){
    .topbar{ padding:12px 16px; }
    .card{ padding:0 20px 26px; }
}

</style>

</head>

<body>

<!-- ================= TOP BAR ================= -->

<div class="topbar">
    <a class="brand" href="Restaurant">🍔 Food Delivery App</a>
    <a href="Restaurant">Home</a>
</div>

<div class="hero"></div>


<!-- ================= PROFILE CARD ================= -->

<div class="wrap">

    <div class="card">

        <div class="avatar"><%= esc(initial) %></div>

        <h1><%= esc(user.getUserName()) %></h1>

        <span class="role"><%= esc(user.getRole()) %></span>

        <div class="details">

            <div class="detail">
                <div class="icon">🆔</div>
                <div>
                    <div class="label">User ID</div>
                    <div class="value">#<%= user.getUserID() %></div>
                </div>
            </div>

            <div class="detail">
                <div class="icon">✉️</div>
                <div>
                    <div class="label">Email</div>
                    <div class="value"><%= esc(user.getEmail()) %></div>
                </div>
            </div>

            <div class="detail">
                <div class="icon">📍</div>
                <div>
                    <div class="label">Address</div>
                    <div class="value"><%= esc(user.getAddress()) %></div>
                </div>
            </div>

        </div>

        <div class="buttons">
            <a href="MyOrdersServlet" class="btn primary">📦 My Orders</a>
            <a href="Restaurant" class="btn outline">🍽️ Order Food</a>
            <a href="LogoutServlet" class="btn logout">Logout</a>
        </div>

    </div>

</div>

</body>
</html>
