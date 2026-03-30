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

  // Get vehicle ID from query parameter
  String idParam = request.getParameter("id");
  if (idParam == null || idParam.isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
    return;
  }

  int vehicleId = Integer.parseInt(idParam);
  VehicleDAO dao = new VehicleDAO();
  Vehicle vehicle = dao.getVehicleById(vehicleId);

  if (vehicle == null || vehicle.getDriverId() != user.getUserId()) {
    response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
    return;
  }

  DeliveryRateDAO deliveryRateDAO = new DeliveryRateDAO();
  List<String> vehicleCategories = deliveryRateDAO.getActiveVehicleTypes();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Vehicle | Daily Fixer</title>
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

.vehicle-form {
    max-width: 500px;
    margin: 20px auto;
    background: var(--card);
    border: 1px solid var(--border);
    padding: 30px;
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-sm);
}
.vehicle-form h3 {
    margin-bottom: 25px;
    color: var(--foreground);
    font-size: 1.3em;
    text-align: center;
    border-bottom: 2px solid var(--border);
    padding-bottom: 15px;
}
.vehicle-form label {
    display: block;
    margin: 15px 0 5px;
    color: var(--foreground);
    font-weight: 600;
    font-size: 0.9rem;
}
.vehicle-form input, .vehicle-form select, .vehicle-form button {
    display: block;
    margin: 8px 0;
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
    margin-top: 20px;
    transition: all 0.2s;
}
.vehicle-form button:hover {
    transform: translateY(-1px);
    box-shadow: var(--shadow-sm);
    opacity: 0.9;
}
.current-image {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border-radius: var(--radius-md);
    margin-bottom: 15px;
    border: 2px solid var(--border);
}
</style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<main class="container">
    <h2>Edit Vehicle</h2>
    <form action="${pageContext.request.contextPath}/EditVehicleServlet" method="post" enctype="multipart/form-data" class="vehicle-form">
        <h3>Update Vehicle Information</h3>
        <input type="hidden" name="id" value="<%= vehicle.getId() %>">

        <label>Current Image:</label>
        <img src="${pageContext.request.contextPath}/GetVehicleImageServlet?id=<%= vehicle.getId() %>" class="current-image" alt="Vehicle Image">

        <label for="vehicleType">Vehicle Type:</label>
        <input type="text" name="vehicleType" value="<%= vehicle.getVehicleType() %>" placeholder="Vehicle Type" required>

        <label for="brand">Brand:</label>
        <input type="text" name="brand" value="<%= vehicle.getBrand() %>" placeholder="Brand" required>

        <label for="model">Model:</label>
        <input type="text" name="model" value="<%= vehicle.getModel() %>" placeholder="Model" required>

        <label for="plateNumber">Plate Number:</label>
        <input type="text" name="plateNumber" value="<%= vehicle.getPlateNumber() %>" placeholder="Plate Number" required>

        <label for="picture">New Image (optional):</label>
        <input type="file" name="picture" accept="image/*">

        <label for="vehicleCategory">Vehicle Category:</label>
        <select name="vehicleCategory" required>
            <option value="">-- Select Category --</option>
            <% for (String cat : vehicleCategories) { %>
            <option value="<%= cat %>" <%= cat.equals(vehicle.getVehicleCategory()) ? "selected" : "" %>><%= cat %></option>
            <% } %>
        </select>

        <button type="submit">Update Vehicle</button>
    </form>
</main>

</body>
</html>
