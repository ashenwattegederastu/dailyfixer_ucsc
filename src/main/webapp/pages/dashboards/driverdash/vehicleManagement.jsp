<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dailyfixer.model.Vehicle" %>
<%@ page import="com.dailyfixer.dao.VehicleDAO" %>
<%@ page import="com.dailyfixer.dao.DeliveryRateDAO" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    // Get logged-in user
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"driver".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
        return;
    }

    VehicleDAO dao = new VehicleDAO();
    List<Vehicle> vehicles = dao.getVehiclesByDriver(user.getUserId());

    DeliveryRateDAO deliveryRateDAO = new DeliveryRateDAO();
    List<String> vehicleCategories = deliveryRateDAO.getActiveVehicleTypes();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vehicle Management | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<style>
.container {
    flex: 1;
    margin-left: 240px;
    margin-top: 83px;
    padding: 30px;
    background-color: var(--background);
}
.container h2 {
    font-size: 1.6em;
    margin-bottom: 20px;
    color: var(--foreground);
}

/* Add Vehicle Button */
.add-vehicle-btn {
    margin: 20px 0;
    padding: 12px 24px;
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    box-shadow: var(--shadow-sm);
    transition: all 0.2s;
}
.add-vehicle-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

/* Vehicle Form */
.vehicle-form {
    display: none;
    margin-top: 20px;
    background: var(--card);
    border: 1px solid var(--border);
    padding: 25px;
    border-radius: var(--radius-lg);
    max-width: 500px;
    box-shadow: var(--shadow-sm);
}
.vehicle-form h3 {
    margin-bottom: 20px;
    color: var(--foreground);
    font-size: 1.2em;
}
.vehicle-form input, .vehicle-form select, .vehicle-form button {
    display: block;
    margin: 12px 0;
    width: 100%;
    padding: 12px;
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    font-family: inherit;
    font-size: 0.9rem;
    background: var(--background);
    color: var(--foreground);
}
.vehicle-form input:focus, .vehicle-form select:focus {
    outline: none;
    border-color: var(--primary);
    box-shadow: 0 0 0 3px color-mix(in srgb, var(--primary) 15%, transparent);
}
.vehicle-form button {
    background: var(--primary);
    color: var(--primary-foreground);
    border: none;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.2s;
}
.vehicle-form button:hover {
    transform: translateY(-1px);
    box-shadow: var(--shadow-sm);
    opacity: 0.9;
}

/* Vehicle Cards */
.vehicle-cards {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
    margin-top: 20px;
}
.vehicle-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 20px;
    text-align: center;
    position: relative;
    box-shadow: var(--shadow-sm);
    transition: all 0.2s;
}
.vehicle-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
}
.vehicle-card img {
    width: 100%;
    height: 160px;
    object-fit: cover;
    border-radius: var(--radius-md);
    margin-bottom: 15px;
}
.vehicle-card p {
    margin: 8px 0;
    color: var(--muted-foreground);
    font-weight: 500;
}
.vehicle-card p strong {
    color: var(--foreground);
}

/* Vehicle Actions */
.vehicle-card .actions {
    margin-top: 15px;
    display: flex;
    gap: 10px;
    justify-content: center;
}
.vehicle-card .actions a {
    display: inline-block;
    padding: 8px 16px;
    border-radius: var(--radius-md);
    text-decoration: none;
    color: white;
    font-weight: 500;
    font-size: 0.85rem;
    transition: all 0.2s;
}
.edit-btn   { background: linear-gradient(135deg, #007bff, #0056b3); }
.delete-btn { background: linear-gradient(135deg, #dc3545, #c82333); }
.vehicle-card .actions a:hover {
    transform: translateY(-1px);
    box-shadow: var(--shadow-sm);
    opacity: 0.9;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 40px;
    color: var(--muted-foreground);
    background: var(--card);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-sm);
    border: 1px solid var(--border);
}
</style>
<script>
    function toggleForm() {
        const form = document.getElementById('addVehicleForm');
        form.style.display = form.style.display === 'block' ? 'none' : 'block';
    }

    function openEditForm(vehicleId, type, brand, model, plate, category) {
        const form = document.getElementById('addVehicleForm');
        form.style.display = 'block';
        form.action = '${pageContext.request.contextPath}/EditVehicleServlet';
        document.getElementById('vehicleId').value = vehicleId;
        document.getElementById('vehicleType').value = type;
        document.getElementById('brand').value = brand;
        document.getElementById('model').value = model;
        document.getElementById('plateNumber').value = plate;
        document.getElementById('vehicleCategory').value = category;
    }
</script>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<main class="container">
    <h2>Vehicle Management</h2>

    <!-- Add/Edit Vehicle Form -->
    <button class="add-vehicle-btn" onclick="toggleForm()">Add Vehicle</button>
    <form id="addVehicleForm" action="${pageContext.request.contextPath}/AddVehicleServlet" method="post" enctype="multipart/form-data" class="vehicle-form">
        <h3>Add / Edit Vehicle</h3>
        <input type="hidden" id="vehicleId" name="id">
        <input type="text" id="vehicleType" name="vehicleType" placeholder="Vehicle Make / Description (e.g. Honda CB125)" required>
        <input type="text" id="brand" name="brand" placeholder="Brand" required>
        <input type="text" id="model" name="model" placeholder="Model" required>
        <input type="text" id="plateNumber" name="plateNumber" placeholder="Plate Number" required>
        <input type="file" name="picture" accept="image/*">
        <select id="vehicleCategory" name="vehicleCategory" required>
            <option value="">-- Select Vehicle Category --</option>
            <% for (String cat : vehicleCategories) { %>
            <option value="<%= cat %>"><%= cat %></option>
            <% } %>
        </select>
        <button type="submit">Submit</button>
    </form>

    <!-- Vehicles Display -->
    <div class="vehicle-cards">
        <% for (Vehicle vehicle : vehicles) { %>
        <div class="vehicle-card">
            <img src="${pageContext.request.contextPath}/GetVehicleImageServlet?id=<%= vehicle.getId() %>" alt="Vehicle Image">
            <p><strong>Type:</strong> <%= vehicle.getVehicleType() %></p>
            <p><strong>Brand:</strong> <%= vehicle.getBrand() %></p>
            <p><strong>Model:</strong> <%= vehicle.getModel() %></p>
            <p><strong>Plate:</strong> <%= vehicle.getPlateNumber() %></p>
            <p><strong>Category:</strong> <%= vehicle.getVehicleCategory() %></p>
            <div class="actions">
                <a href="javascript:void(0);" class="edit-btn"
                   onclick="openEditForm('<%= vehicle.getId() %>', '<%= vehicle.getVehicleType() %>', '<%= vehicle.getBrand() %>', '<%= vehicle.getModel() %>', '<%= vehicle.getPlateNumber() %>', '<%= vehicle.getVehicleCategory() %>')">Edit</a>
                <a href="${pageContext.request.contextPath}/DeleteVehicleServlet?id=<%= vehicle.getId() %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this vehicle?');">Delete</a>
            </div>
        </div>
        <% } %>
        <% if (vehicles.isEmpty()) { %>
        <div class="empty-state">
            <p>No vehicles added yet. Click "Add Vehicle" to register your first vehicle.</p>
        </div>
        <% } %>
    </div>
</main>

</body>
</html>
