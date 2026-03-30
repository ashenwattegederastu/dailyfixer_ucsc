<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    // Get the currently logged-in user from session
    User user = (User) session.getAttribute("currentUser");

    // Redirect to login if no user or role is set
    if (user == null || user.getRole() == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Check role: allow only admin or store
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
<title>Orders | Daily Fixer</title>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<!-- Framework CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<!-- Tables CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/storedash-tables.css">

<style>
/* Page-specific: action button variants */
.view-btn { background: var(--primary); color: var(--primary-foreground); }
.update-btn { background: var(--accent); color: var(--accent-foreground); }
.delivery-btn { background: var(--destructive); color: var(--destructive-foreground); }

/* Page-specific: status dropdown */
.status-options {
    display: none;
    position: absolute;
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 8px;
    box-shadow: var(--shadow-sm);
    z-index: 10;
    margin-top: 5px;
}
.status-options button {
    display: block;
    width: 100%;
    padding: 8px 12px;
    border: none;
    background: none;
    text-align: left;
    cursor: pointer;
    font-size: 0.85em;
    color: var(--foreground);
}
.status-options button:hover {
    background-color: var(--accent);
    color: var(--accent-foreground);
}

/* Page-specific: vehicle selection modal */
.vehicle-modal {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.6);
    justify-content: center;
    align-items: center;
    z-index: 500;
}
.vehicle-modal .modal-content {
    background: var(--card);
    color: var(--card-foreground);
    padding: 30px;
    border-radius: 12px;
    max-width: 400px;
    width: 90%;
    text-align: center;
    box-shadow: var(--shadow-lg);
    position: relative;
}
.vehicle-modal h3 {
    color: var(--primary);
    margin-bottom: 20px;
}
.vehicle-modal .vehicle-options {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
    margin-bottom: 20px;
}
.vehicle-modal .vehicle-btn {
    padding: 12px;
    border: 2px solid var(--border);
    border-radius: 8px;
    background: var(--card);
    color: var(--card-foreground);
    cursor: pointer;
    font-weight: 500;
    transition: all 0.2s;
}
.vehicle-modal .vehicle-btn:hover {
    border-color: var(--primary);
    background: var(--accent);
}
.vehicle-modal .vehicle-btn.selected {
    border-color: var(--primary);
    background: var(--accent);
    color: var(--accent-foreground);
}
.vehicle-modal .modal-buttons {
    display: flex;
    gap: 10px;
    justify-content: center;
}
.vehicle-modal .modal-btn {
    padding: 10px 20px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
}
.vehicle-modal .confirm-btn {
    background: var(--primary);
    color: var(--primary-foreground);
}
.vehicle-modal .cancel-btn {
    background: var(--muted);
    color: var(--muted-foreground);
}
.close-btn {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 1.5em;
    font-weight: bold;
    cursor: pointer;
    color: var(--muted-foreground);
}
</style>
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
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp" class="active">Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up for Delivery</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/ListProductsServlet">Catalogue</a></li>
        <li><a href="${pageContext.request.contextPath}/ListDiscountsServlet">Discounts</a></li>
        <li><a href="${pageContext.request.contextPath}/StoreReviewsServlet">Customer Reviews</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/finances.jsp">Finances</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myStore.jsp">My Store</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>Orders</h2>
    
    <table>
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Date</th>
                <th>Status</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>001</td>
                <td>Kamal Silva</td>
                <td>2025-07-20</td>
                <td><span class="status pending"></span>Pending</td>
                <td>LKR 1,100</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn update-btn" onclick="toggleStatusOptions(this, 1)">Update Status</button>
                    <div class="status-options" id="status-options-1">
                        <button onclick="changeStatus(this, 'Pending')">Pending</button>
                        <button onclick="changeStatus(this, 'Out for Delivery')">Out for Delivery</button>
                        <button onclick="changeStatus(this, 'Delivered')">Delivered</button>
                    </div>
                    <button class="btn delivery-btn" onclick="showVehicleModal('001')">Ready to Deliver</button>
                </td>
            </tr>
            <tr>
                <td>002</td>
                <td>Amal Bandara</td>
                <td>2025-07-06</td>
                <td><span class="status delivered"></span>Delivered</td>
                <td>LKR 350</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn update-btn" onclick="toggleStatusOptions(this, 2)">Update Status</button>
                    <div class="status-options" id="status-options-2">
                        <button onclick="changeStatus(this, 'Pending')">Pending</button>
                        <button onclick="changeStatus(this, 'Out for Delivery')">Out for Delivery</button>
                        <button onclick="changeStatus(this, 'Delivered')">Delivered</button>
                    </div>
                    <button class="btn delivery-btn" onclick="showVehicleModal('002')">Ready to Deliver</button>
                </td>
            </tr>
            <tr>
                <td>003</td>
                <td>Nimal Perera</td>
                <td>2025-07-19</td>
                <td><span class="status out-delivery"></span>Out for Delivery</td>
                <td>LKR 2,500</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn update-btn" onclick="toggleStatusOptions(this, 3)">Update Status</button>
                    <div class="status-options" id="status-options-3">
                        <button onclick="changeStatus(this, 'Pending')">Pending</button>
                        <button onclick="changeStatus(this, 'Out for Delivery')">Out for Delivery</button>
                        <button onclick="changeStatus(this, 'Delivered')">Delivered</button>
                    </div>
                    <button class="btn delivery-btn" onclick="showVehicleModal('003')">Ready to Deliver</button>
                </td>
            </tr>
        </tbody>
    </table>
</main>

<!-- Vehicle Selection Modal -->
<div id="vehicleModal" class="vehicle-modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeVehicleModal()">&times;</span>
        <h3>Select Delivery Vehicle</h3>
        <p>Choose the type of vehicle needed for delivery:</p>
        
        <div class="vehicle-options">
            <button class="vehicle-btn" onclick="selectVehicle('bike')">Bike</button>
            <button class="vehicle-btn" onclick="selectVehicle('threewheel')">Three Wheel</button>
            <button class="vehicle-btn" onclick="selectVehicle('van')">Van</button>
            <button class="vehicle-btn" onclick="selectVehicle('lorry')">Lorry</button>
        </div>
        
        <div class="modal-buttons">
            <button class="modal-btn confirm-btn" onclick="confirmDelivery()">Confirm</button>
            <button class="modal-btn cancel-btn" onclick="closeVehicleModal()">Cancel</button>
        </div>
    </div>
</div>

<script>
let selectedOrderId = '';
let selectedVehicle = '';

function toggleStatusOptions(btn, orderId) {
    const optionsDiv = document.getElementById(`status-options-${orderId}`);
    optionsDiv.style.display = optionsDiv.style.display === "block" ? "none" : "block";
}

function changeStatus(button, newStatus) {
    const row = button.closest("tr");
    const statusCell = row.querySelector("td:nth-child(4)");
    
    // Update status visually
    let statusClass = "";
    if (newStatus === "Pending") statusClass = "pending";
    if (newStatus === "Out for Delivery") statusClass = "out-delivery";
    if (newStatus === "Delivered") statusClass = "delivered";
    
    statusCell.innerHTML = `<span class="status ${statusClass}"></span> ${newStatus}`;
    
    // Hide status options
    button.parentElement.style.display = "none";
}

function showVehicleModal(orderId) {
    selectedOrderId = orderId;
    document.getElementById('vehicleModal').style.display = 'flex';
}

function closeVehicleModal() {
    document.getElementById('vehicleModal').style.display = 'none';
    selectedVehicle = '';
    // Reset vehicle button selections
    document.querySelectorAll('.vehicle-btn').forEach(btn => {
        btn.classList.remove('selected');
    });
}

function selectVehicle(vehicle) {
    selectedVehicle = vehicle;
    // Reset all buttons
    document.querySelectorAll('.vehicle-btn').forEach(btn => {
        btn.classList.remove('selected');
    });
    // Select clicked button
    event.target.classList.add('selected');
}

function confirmDelivery() {
    if (selectedVehicle) {
        alert(`Order ${selectedOrderId} is ready for delivery using ${selectedVehicle}. Driver will be notified.`);
        closeVehicleModal();
    } else {
        alert('Please select a delivery vehicle type.');
    }
}

// Close modal on outside click
document.getElementById('vehicleModal').addEventListener('click', e => {
    if(e.target.id === 'vehicleModal') {
        closeVehicleModal();
    }
});
</script>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
