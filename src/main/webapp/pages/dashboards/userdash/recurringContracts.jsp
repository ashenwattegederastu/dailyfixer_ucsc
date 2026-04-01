<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dailyfixer.model.RecurringContract" %>
<%@ page import="com.dailyfixer.dao.RecurringContractDAO" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<% User user = (User) session.getAttribute("currentUser");
   if (user == null || user.getRole() == null || !"user".equalsIgnoreCase(user.getRole().trim())) {
       response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
       return;
   }
   RecurringContractDAO dao = new RecurringContractDAO();
   List<RecurringContract> contracts = dao.getContractsByUserId(user.getUserId());
   request.setAttribute("contracts", contracts);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recurring Contracts | Daily Fixer</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 4px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .badge-active    { background: #d1fae5; color: #065f46; }
        .badge-pending   { background: #fef3c7; color: #92400e; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; }
        .badge-completed { background: #e0e7ff; color: #3730a3; }
    </style>
</head>
<body class="dashboard-layout">
    <jsp:include page="sidebar.jsp"/>

    <main class="dashboard-container">
        <header class="dashboard-header">
            <h1>Recurring Contracts</h1>
            <p>Your active and past 1-year recurring service agreements</p>
        </header>

        <c:if test="${param.cancelled == 'true'}">
            <div style="background: #10b981; color: white; padding: 1rem; border-radius: 0.5rem; margin-bottom: 1rem;">
                Contract cancelled. Future bookings have been removed.
            </div>
        </c:if>

        <div class="section">
            <c:choose>
                <c:when test="${empty contracts}">
                    <div class="empty-state">
                        <h3>No Recurring Contracts</h3>
                        <p>You have not signed up for any recurring services yet. Browse services and look for the &#8635; Recurring Available badge.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Technician</th>
                                    <th>Service</th>
                                    <th>Monthly Fee</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${contracts}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td>${c.technicianName}</td>
                                        <td>${c.serviceName}</td>
                                        <td>Rs. <fmt:formatNumber value="${c.recurringFee}" maxFractionDigits="2" minFractionDigits="2"/>/mo</td>
                                        <td>${c.startDate}</td>
                                        <td>${c.endDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'ACTIVE'}">
                                                    <span class="status-badge badge-active">Active</span>
                                                </c:when>
                                                <c:when test="${c.status == 'PENDING'}">
                                                    <span class="status-badge badge-pending">Pending</span>
                                                </c:when>
                                                <c:when test="${c.status == 'CANCELLED'}">
                                                    <span class="status-badge badge-cancelled">Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge badge-completed">Completed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${c.status == 'ACTIVE' || c.status == 'PENDING'}">
                                                <form method="post" action="${pageContext.request.contextPath}/recurring/cancel"
                                                      onsubmit="return confirm('Cancel this recurring contract? All future bookings will be removed.');">
                                                    <input type="hidden" name="contractId" value="${c.contractId}">
                                                    <input type="hidden" name="role" value="user">
                                                    <button type="submit"
                                                            style="background: var(--destructive); color: var(--destructive-foreground); border: none; padding: 6px 14px; border-radius: 4px; font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                                        Cancel
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${c.status != 'ACTIVE' && c.status != 'PENDING'}">
                                                <span style="color: var(--muted-foreground); font-size: 0.85rem;">—</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>
