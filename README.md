# 🍔 Food Delivery Web Application

A full-stack food delivery web app built with **Java, JSP, Servlets, JDBC and MySQL**. Users can sign up, browse restaurants, add dishes to a cart, check out and view their order history.

## ✨ Features

- 🔐 **Sign up and login** with BCrypt password hashing and session management
- 🍽️ **Restaurant listing** with search, cuisine filters, sorting and an "open now" filter
- 📋 **Menu page** with ratings, availability, search, sorting and a quantity selector
- 🛒 **Cart** to add, update and remove items, with dish photos
- 💳 **Checkout** with an order summary, delivery charges (₹40) and 5% GST
- 📦 **My Orders** page showing previous orders
- 👤 **Profile page** with account details and logout
- 📱 Responsive design that works on desktop and mobile

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Language | Java 21 |
| Backend | Servlets, JSP (Jakarta EE) |
| Database | MySQL 8 with JDBC |
| Server | Apache Tomcat 10.1 |
| Security | jBCrypt for password hashing |
| Frontend | HTML, CSS, JavaScript |
| IDE | Eclipse |

## 🏗️ Project Structure

```
src/main
├── java/com/tap
│   ├── DAO         # DAO interfaces
│   ├── DAOImpl     # JDBC implementations
│   ├── model       # POJO classes (User, Restaurant, Menu, Cart, Order...)
│   ├── servlet     # Servlets (Login, Register, Menu, Cart, Order...)
│   └── utility     # DBConnection
└── webapp
    ├── images      # Restaurant and food images
    ├── WEB-INF/lib # jbcrypt and MySQL connector jars
    └── *.jsp / *.html
```

The project follows the **MVC** pattern with the **DAO** design pattern.

## 🗄️ Database

Database name: `tap_foods`

| Table | Main columns |
|-------|--------------|
| `user` | userID, userName, email, password, address, role, createdDate, lastLoginDate |
| `restaurant` | restaurantID, name, cuisineType, deliveryTime, address, rating, isActive, imagePath |
| `menu` | menuID, restaurantID, itemName, description, price, isAvailable, ratings, imagePath |
| `ordertable` | orderID, userID, restaurantID, orderDate, totalAmount, status, paymentMethod |
| `orderitem` | orderItemID, orderID, menuID, quantity, itemTotal |

## 🚀 How to Run

1. **Clone the repository**
```
   git clone https://github.com/Yogita-D/food-delivery-web-application.git
```
2. **Create the database** in MySQL: create a schema named `tap_foods` and create the five tables above (add your own sample restaurants and menu items).
3. **Set your database password** in `src/main/java/com/tap/utility/DBConnection.java`:
```java
   private final static String USERNAME = "root";
   private final static String PASSWORD = "YOUR_PASSWORD";
```
4. **Import into Eclipse** as an existing project (Dynamic Web Project) and add **Apache Tomcat 10.1** as the server.
5. **Run on server** and open:
```
   http://localhost:8080/food_delivery/Restaurant
```

## 🔑 Main URLs

| URL | Purpose |
|-----|---------|
| `/Restaurant` | Home page with all restaurants |
| `/menu?restaurantId=1` | Menu of a restaurant |
| `/login.html`, `/register.html` | Sign in and sign up |
| `/cartServlet` | Add, update and remove cart items |
| `/OrderServlet` | Place an order |
| `/MyOrdersServlet` | Order history |
| `/ProfileServlet` | User profile |

## 📝 Notes

- Payment is a **selection only** (UPI, Card, Cash on Delivery). No real payment gateway is connected.
- Passwords are stored as **BCrypt hashes**, never as plain text.

## 🔮 Future Improvements

- Real payment gateway integration
- Order status tracking (preparing, on the way, delivered)
- Admin dashboard for restaurants and menus
- Saved delivery addresses
- Ratings and reviews

## 👩‍💻 Author

**Yogita D**
GitHub: [@Yogita-D](https://github.com/Yogita-D)
