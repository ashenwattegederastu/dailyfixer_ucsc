<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Technician Dashboard | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<style>
.info-box {
    background: var(--muted);
    padding: 15px 18px;
    border-radius: var(--radius-md);
    border-left: 4px solid var(--primary);
}
.info-box p {
    margin: 0;
    color: var(--foreground);
    font-size: 0.95em;
}
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 15px;
}
.section-card {
    background: var(--card);
    padding: 25px;
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--border);
    margin-bottom: 30px;
}
.section-card h3 {
    margin-bottom: 20px;
    color: var(--foreground);
    font-size: 1.1em;
    font-weight: 600;
}
.status-badge {
    display: inline-block;
    padding: 3px 10px;
    border-radius: 4px;
    font-size: 0.78em;
    font-weight: 600;
}
.status-REQUESTED            { background: #fef3c7; color: #92400e; }
.status-ACCEPTED             { background: #d1fae5; color: #065f46; }
.status-REJECTED             { background: #fee2e2; color: #991b1b; }
.status-CANCELLED            { background: #f3f4f6; color: #6b7280; }
.status-TECHNICIAN_COMPLETED { background: #dbeafe; color: #1e40af; }
.status-FULLY_COMPLETED      { background: #d1fae5; color: #065f46; }
.rating-star {
    color: #f59e0b;
}
</style>
</head>

<body class="dashboard-layout">

<jsp:include page="sidebar.jsp" />

<main class="dashboard-container">
    <header class="dashboard-header">
        <h1>Dashboard</h1>
        <p>Welcome back, ${sessionScope.currentUser.firstName}. Here's your activity at a glance.</p>
    </header>

    <!-- Stat Cards -->
    <div class="stats-container">
        <div class="stat-card">
            <p class="number">${pendingCount}</p>
            <p>Pending Requests</p>
        </div>
        <div class="stat-card">
            <p class="number">${activeCount}</p>
            <p>Active Bookings</p>
        </div>
        <div class="stat-card">
            <p class="number">${completedCount}</p>
            <p>Completed Jobs</p>
        </div>
        <div class="stat-card">
            <p class="number"><span class="rating-star">★</span> ${avgRatingStr}</p>
            <p>Average Rating</p>
        </div>
    </div>

    <!-- Performance Overview -->
    <div class="section-card">
        <h3>Performance Overview</h3>
        <div class="stats-grid">
            <div class="info-box">
                <p><strong>Service Listings:</strong> ${serviceCount} active listing<c:if test="${serviceCount != 1}">s</c:if></p>
            </div>
            <div class="info-box">
                <p><strong>Total Ratings:</strong> ${ratingCount} review<c:if test="${ratingCount != 1}">s</c:if></p>
            </div>
            <div class="info-box">
                <p><strong>Completed This Month:</strong> ${thisMonthCount} job<c:if test="${thisMonthCount != 1}">s</c:if></p>
            </div>
            <div class="info-box">
                <p><strong>All-Time Completed:</strong> ${completedCount} job<c:if test="${completedCount != 1}">s</c:if></p>
            </div>
        </div>
    </div>

    <!-- Recent Bookings -->
    <div class="section">
        <h2>Recent Bookings</h2>
        <div class="table-container">
            <c:choose>
                <c:when test="${empty recentBookings}">
                    <div style="text-align:center; padding:2.5rem; background:var(--card); border-radius:var(--radius-lg); border:1px solid var(--border);">
                        <p style="color:var(--muted-foreground);">No bookings yet. They will appear here once customers book your services.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Service</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${recentBookings}">
                                <tr>
                                    <td style="font-family: monospace; color: var(--muted-foreground);">#${b.bookingId}</td>
                                    <td style="font-weight: 500;">${b.serviceName}</td>
                                    <td>${b.userName}</td>
                                    <td>${b.bookingDate}</td>
                                    <td>
                                        <span class="status-badge status-${b.status}">
                                            <c:out value="${fn:replace(b.status, '_', ' ')}" default="${b.status}" />
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        <c:if test="${not empty recentBookings}">
            <div style="margin-top: 12px; text-align: right;">
                <a href="${pageContext.request.contextPath}/bookings/calendar"
                   style="color: var(--primary); font-size: 0.9em; text-decoration: none; font-weight: 500;">
                    View all bookings →
                </a>
            </div>
        </c:if>
    </div>
</main>

</body>
</html>

