<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = user.getRole().trim().toLowerCase();
    if (!("technician".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Accepted Bookings | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
    --panel-color: #dcdaff;
    --accent: #8b95ff;
    --text-dark: #000000;
    --text-secondary: #333333;
    --shadow-sm: 0 4px 12px rgba(0,0,0,0.12);
    --shadow-md: 0 8px 24px rgba(0,0,0,0.18);
    --shadow-lg: 0 12px 36px rgba(0,0,0,0.22);
}

/* Reset */
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Inter', sans-serif;
    background-color: #ffffff;
    color: var(--text-dark);
    display: flex;
    min-height: 100vh;
}

/* Top Navbar */
.topbar {
    position: fixed;
    top:0; left:0; right:0;
    height:76px;
    background-color: var(--panel-color);
    border-bottom: 1px solid rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 30px;
    z-index: 200;
    box-shadow: var(--shadow-md);
}
.topbar .logo { font-size: 1.5em; font-weight: 700; color: var(--accent); }
.topbar .panel-name { font-weight: 600; flex:1; text-align:center; color: var(--text-dark); }
.topbar .logout-btn {
    padding: 0.6rem 1.2rem;
    background: linear-gradient(135deg, var(--accent), #7ba3d4);
    border: none;
    color: #fff;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    box-shadow: var(--shadow-sm);
    text-decoration: none;
}
.topbar .logout-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

/* Sidebar */
.sidebar {
    width: 240px;
    background-color: var(--panel-color);
    height: 100vh;
    position: fixed;
    top:0;
    left:0;
    padding-top: 96px;
    box-shadow: var(--shadow-md);
    overflow-y: auto;
    z-index: 100;
}
.sidebar h3 { padding: 0 20px 12px; font-size: 0.85em; color: var(--text-dark); text-transform: uppercase; }
.sidebar ul { list-style:none; }
.sidebar a {
    display:block;
    padding:12px 20px;
    text-decoration:none;
    color: var(--text-dark);
    font-weight:500;
    border-left:3px solid transparent;
    border-radius:0 8px 8px 0;
    margin-bottom:4px;
    transition: all 0.2s;
}
.sidebar a:hover, .sidebar a.active {
    background-color: #f0f0ff;
    border-left-color: var(--accent);
}

/* Main Content */
.container {
    flex:1;
    margin-left:240px;
    margin-top:83px;
    padding:30px;
}
.container h2 {
    font-size:1.6em;
    margin-bottom:20px;
    color: #000000;
}

/* Table Styles */
table {
    width:100%;
    border-collapse: collapse;
    box-shadow: var(--shadow-sm);
    background: white;
    border-radius: 12px;
    overflow: hidden;
}
thead { background-color: var(--panel-color); }
th, td {
    padding:12px 10px;
    text-align:left;
    border-bottom:1px solid #ddd;
}
tbody tr:hover { background-color:#f9f9f9; }

/* Buttons */
.btn { 
    padding:8px 16px; 
    border:none; 
    border-radius:8px; 
    cursor:pointer; 
    font-weight:500; 
    margin-right:5px;
    text-decoration: none;
    display: inline-block;
    transition: all 0.2s;
    font-size: 14px;
}
.complete-btn { 
    background: #28a745; 
    color:#fff; 
}
.view-btn { 
    background: #20255b; 
    color:#fff; 
}
.btn:hover {
    transform: translateY(-1px);
    opacity: 0.9;
}

.status-badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
}
.status-accepted {
    background: #d4edda;
    color: #155724;
}
.status-in-progress {
    background: #fff3cd;
    color: #856404;
}
</style>
</head>
<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">Technician Dashboard</div>
    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/techniciandashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/bookings.jsp">Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/serviceListings.jsp">Service Listings</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/acceptedBookings.jsp" class="active">Accepted Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/completedBookings.jsp">Completed Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/technicianProfile.jsp">My Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>Accepted Bookings</h2>
    
    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Service Name</th>
                <th>Customer Name</th>
                <th>Scheduled Date</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <!-- Sample data - replace with actual data from backend -->
            <tr>
                <td>BK004</td>
                <td>Plumbing Repair</td>
                <td>Alice Brown</td>
                <td>2025-01-20</td>
                <td><span class="status-badge status-accepted">Accepted</span></td>
                <td>
                    <button class="btn view-btn" onclick="viewBookingDetails('BK004')">View Details</button>
                    <button class="btn complete-btn" onclick="completeBooking('BK004')">Mark Complete</button>
                </td>
            </tr>
            <tr>
                <td>BK005</td>
                <td>Electrical Installation</td>
                <td>Robert Davis</td>
                <td>2025-01-22</td>
                <td><span class="status-badge status-in-progress">In Progress</span></td>
                <td>
                    <button class="btn view-btn" onclick="viewBookingDetails('BK005')">View Details</button>
                    <button class="btn complete-btn" onclick="completeBooking('BK005')">Mark Complete</button>
                </td>
            </tr>
            <tr>
                <td>BK006</td>
                <td>HVAC Maintenance</td>
                <td>Emily Wilson</td>
                <td>2025-01-25</td>
                <td><span class="status-badge status-accepted">Accepted</span></td>
                <td>
                    <button class="btn view-btn" onclick="viewBookingDetails('BK006')">View Details</button>
                    <button class="btn complete-btn" onclick="completeBooking('BK006')">Mark Complete</button>
                </td>
            </tr>
        </tbody>
    </table>
</main>

<script>
function viewBookingDetails(bookingId) {
    // Navigate to booking details page or show modal
    window.location.href = '${pageContext.request.contextPath}/pages/dashboards/techniciandash/bookingDetails.jsp?id=' + bookingId;
}

function completeBooking(bookingId) {
    if (confirm('Are you sure you want to mark this booking as complete?')) {
        // Send AJAX request to complete booking
        fetch('${pageContext.request.contextPath}/CompleteBookingServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'bookingId=' + bookingId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Booking marked as complete successfully!');
                location.reload();
            } else {
                alert('Error completing booking: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error completing booking');
        });
    }
}
</script>

</body>
</html>
