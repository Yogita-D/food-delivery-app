<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    Integer orderID = (Integer) session.getAttribute("orderID");
    Double orderTotal = (Double) session.getAttribute("orderTotal");

    // Someone opened this page directly without placing an order
    if (orderID == null || orderTotal == null) {
        response.sendRedirect("Restaurant");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Successful</title>

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
    background:linear-gradient(135deg,#ff6b35,#ff9a5c);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    padding:20px;
    overflow-x:hidden;
}

.card{
    position:relative;
    width:100%;
    max-width:560px;
    background:white;
    border-radius:20px;
    padding:45px 35px 38px;
    text-align:center;
    box-shadow:0 15px 40px rgba(0,0,0,0.25);
    animation:pop 0.5s ease;
}

@keyframes pop{
    from{ transform:scale(0.9); opacity:0; }
    to  { transform:scale(1);   opacity:1; }
}

.tick{
    width:90px;
    height:90px;
    margin:0 auto 22px;
    border-radius:50%;
    background:#1d9a6c;
    color:white;
    font-size:50px;
    display:flex;
    align-items:center;
    justify-content:center;
    box-shadow:0 0 0 12px rgba(29,154,108,0.15);
}

h1{
    font-size:28px;
    margin-bottom:8px;
    color:#333;
}

.msg{
    color:#666;
    margin-bottom:26px;
}

.details{
    background:#fff3ee;
    border-radius:14px;
    padding:10px 20px;
    margin-bottom:26px;
}

.row{
    display:flex;
    justify-content:space-between;
    padding:13px 0;
    border-bottom:1px dashed #f0cdbd;
}

.row:last-child{ border-bottom:none; }

.row span:first-child{ color:#777; }

.row b{ color:#333; }

.row b.big{
    color:#ff6b35;
    font-size:20px;
}

.steps{
    display:flex;
    justify-content:space-between;
    margin-bottom:28px;
    font-size:12px;
    color:#999;
}

.step{ flex:1; }

.step .dot{
    width:34px;
    height:34px;
    margin:0 auto 6px;
    border-radius:50%;
    background:#eee;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:16px;
}

.step.done{ color:#1d9a6c; font-weight:600; }
.step.done .dot{ background:#d9f3e8; }

.buttons{
    display:flex;
    gap:12px;
    flex-wrap:wrap;
}

.buttons a{
    flex:1;
    min-width:180px;
    padding:13px 18px;
    border-radius:10px;
    text-decoration:none;
    font-weight:600;
    transition:0.2s;
}

.primary{
    background:#ff6b35;
    color:white;
}

.primary:hover{ background:#e85a28; }

.secondary{
    background:white;
    color:#ff6b35;
    border:2px solid #ff6b35;
}

.secondary:hover{ background:#ffe3d6; }

</style>

</head>

<body>

<div class="card">

    <div class="tick">✓</div>

    <h1>Order placed successfully! 🎉</h1>

    <p class="msg">Thank you for ordering with us. Your delicious food is on its way to being prepared.</p>

    <div class="details">

        <div class="row">
            <span>Order ID</span>
            <b>#<%= orderID %></b>
        </div>

        <div class="row">
            <span>Total paid</span>
            <b class="big">₹<%= String.format("%.2f", orderTotal) %></b>
        </div>

        <div class="row">
            <span>Status</span>
            <b>Order placed</b>
        </div>

    </div>

    <div class="steps">
        <div class="step done"><div class="dot">✅</div>Placed</div>
        <div class="step"><div class="dot">👨‍🍳</div>Preparing</div>
        <div class="step"><div class="dot">🛵</div>On the way</div>
        <div class="step"><div class="dot">🍽️</div>Delivered</div>
    </div>

    <div class="buttons">
        <a class="primary" href="MyOrdersServlet">View My Orders</a>
        <a class="secondary" href="Restaurant">Order more food</a>
    </div>

</div>

</body>
</html>
