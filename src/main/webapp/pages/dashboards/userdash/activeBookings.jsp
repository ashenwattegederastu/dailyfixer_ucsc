<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ page import="com.dailyfixer.model.User" %>

<% User user=(User) session.getAttribute("currentUser"); if (user==null || user.getRole()==null ||
        !"user".equalsIgnoreCase(user.getRole().trim())) {
            response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp" ); return; } %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Bookings | Daily Fixer</title>
    <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
</head>

<body class="dashboard-layout">
<jsp:include page="sidebar.jsp"/>

<main class="dashboard-container">
    <header class="dashboard-header">
        <h1>Active Bookings</h1>
        <p>Manage and track your ongoing service requests</p>
    </header>

    <div class="section">
        <div class="table-container">
            <c:choose>
                <c:when test="${empty activeBookings}">
                    <div class="empty-state">
                        <h3>No Active Bookings</h3>
                        <p>You don't have any requested or accepted bookings at the moment.
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                        <tr>
                            <th>Service</th>
                            <th>Technician</th>
                            <th>Date & Time</th>
                            <th>Address</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${activeBookings}">
                            <tr>
                                <td>
                                    <strong>${b.serviceName}</strong>
                                    <c:if test="${not empty b.recurringContractId}">
                                        <br><span style="display:inline-block; background:#dbeafe; color:#1e40af; border-radius:4px; padding:1px 6px; font-size:0.75rem; font-weight:700; margin-top:2px;">&#8635; Recurring &mdash; Month ${b.recurringSequence}/12</span>
                                        <br><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/recurringContracts.jsp" style="font-size:0.78rem; color:var(--muted-foreground); text-decoration:underline;">View full contract</a>
                                    </c:if>
                                    <br><small>${b.problemDescription}</small>
                                </td>
                                <td>${b.technicianName}</td>
                                <td>
                                    <fmt:formatDate value="${b.bookingDate}"
                                                    pattern="MMM dd, yyyy"/><br>
                                    <fmt:formatDate value="${b.bookingTime}"
                                                    pattern="hh:mm a" type="time"/>
                                </td>
                                <td>${b.locationAddress}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status eq 'ACCEPTED'}">
                                            <span class="status-badge priority-medium"
                                                  style="background: #d1fae5; color: #065f46;">Accepted</span>
                                        </c:when>
                                        <c:when test="${b.status eq 'TECHNICIAN_COMPLETED'}">
                                            <span class="status-badge"
                                                  style="background: #e0e7ff; color: #3730a3;">Awaiting Confirmation</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge priority-low"
                                                  style="background: #fef3c7; color: #92400e;">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/chats?userId=${fn:replace(b.technicianName, ' ', '')}"
                                           class="btn-primary"
                                           style="padding: 4px 10px; font-size: 0.8em; margin-right: 5px;">Message</a>
                                        <c:if test="${b.status eq 'TECHNICIAN_COMPLETED'}">
                                            <form method="post" action="${pageContext.request.contextPath}/bookings/complete" style="display: inline;">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                <input type="hidden" name="completionType" value="user">
                                                <button type="submit" class="btn-secondary"
                                                        style="padding: 4px 10px; font-size: 0.8em; background: #4f46e5; color: white; border: none; cursor: pointer;">Confirm Completion</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>

</html>