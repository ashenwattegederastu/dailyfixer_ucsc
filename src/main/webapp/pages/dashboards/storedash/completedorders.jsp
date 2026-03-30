<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = user.getRole().trim().toLowerCase();
    if (!("admin".equals(role) || "store".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Completed Orders | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/storedash-tables.css">
</head>
<body class="dashboard-layout">

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">Store Panel</div>
    <div style="display: flex; align-items: center; gap: 10px;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up for Delivery</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp" class="active">Completed Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/ListProductsServlet">Catalogue</a></li>
        <li><a href="${pageContext.request.contextPath}/ListDiscountsServlet">Discounts</a></li>
        <li><a href="${pageContext.request.contextPath}/StoreReviewsServlet">Customer Reviews</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/finances.jsp">Finances</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myStore.jsp">My Store</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>Completed Orders</h2>
    
    <table>
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Order Date</th>
                <th>Delivery Date</th>
                <th>Status</th>
                <th>Rating</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>002</td>
                <td>Amal Bandara</td>
                <td>2025-07-06</td>
                <td class="delivery-date">2025-07-08</td>
                <td><span class="status delivered"></span>Delivered</td>
                <td class="rating">★★★★★ (5.0)</td>
                <td>LKR 350</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn receipt-btn">Download Receipt</button>
                    <button class="btn review-btn">View Review</button>
                </td>
            </tr>
            <tr>
                <td>007</td>
                <td>Lakshmi Fernando</td>
                <td>2025-07-15</td>
                <td class="delivery-date">2025-07-17</td>
                <td><span class="status delivered"></span>Delivered</td>
                <td class="rating">★★★★☆ (4.0)</td>
                <td>LKR 1,250</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn receipt-btn">Download Receipt</button>
                    <button class="btn review-btn">View Review</button>
                </td>
            </tr>
            <tr>
                <td>008</td>
                <td>Ravi Jayawardena</td>
                <td>2025-07-12</td>
                <td class="delivery-date">2025-07-14</td>
                <td><span class="status delivered"></span>Delivered</td>
                <td class="rating">★★★★★ (5.0)</td>
                <td>LKR 2,100</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn receipt-btn">Download Receipt</button>
                    <button class="btn review-btn">View Review</button>
                </td>
            </tr>
            <tr>
                <td>009</td>
                <td>Nisha Wickramasinghe</td>
                <td>2025-07-10</td>
                <td class="delivery-date">2025-07-12</td>
                <td><span class="status delivered"></span>Delivered</td>
                <td class="rating">★★★★☆ (4.5)</td>
                <td>LKR 750</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn receipt-btn">Download Receipt</button>
                    <button class="btn review-btn">View Review</button>
                </td>
            </tr>
            <tr>
                <td>010</td>
                <td>Kumar Perera</td>
                <td>2025-07-08</td>
                <td class="delivery-date">2025-07-10</td>
                <td><span class="status delivered"></span>Delivered</td>
                <td class="rating">★★★★★ (5.0)</td>
                <td>LKR 3,500</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn receipt-btn">Download Receipt</button>
                    <button class="btn review-btn">View Review</button>
                </td>
            </tr>
        </tbody>
    </table>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
