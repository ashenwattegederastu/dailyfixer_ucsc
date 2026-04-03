<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ page import="com.dailyfixer.model.User" %>

            <% User user=(User) session.getAttribute("currentUser"); if (user==null || user.getRole()==null ||
                !"user".equalsIgnoreCase(user.getRole().trim())) { response.sendRedirect(request.getContextPath()
                + "/pages/authentication/login.jsp" ); return; } %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <%@ page contentType="text/html;charset=UTF-8" %>
                        <%@ taglib uri="jakarta.tags.core" prefix="c" %>
                            <%@ page import="com.dailyfixer.model.User" %>

                                <% User user=(User) session.getAttribute("currentUser"); if (user==null ||
                                    user.getRole()==null || !"user".equalsIgnoreCase(user.getRole().trim())) {
                                    response.sendRedirect(request.getContextPath() + "/pages/authentication/login.jsp" );
                                    return; } %>

                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Notifications | Daily Fixer</title>
                                        <link
                                            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                            rel="stylesheet">

                                        <link rel="stylesheet"
                                            href="${pageContext.request.contextPath}/assets/css/framework.css">
                                        <jsp:include page="sidebar.jsp" />

                                        <main class="dashboard-container">
                                            <h2>Notifications</h2>

                                            <div class="section-header">Recent Notifications</div>

                                            <!-- Booking Accepted Notification -->
                                            <div class="notification-card">
                                                <div class="notification-icon accepted">✓</div>
                                                <div class="notification-content">
                                                    <h4>Booking Accepted</h4>
                                                    <p>Your electrical repair booking for October 25, 2025 has been
                                                        accepted by John Silva
                                                    </p>
                                                </div>
                                                <div class="notification-time">2 hours ago</div>
                                                <div class="notification-status status-accepted">Accepted</div>
                                            </div>

                                            <!-- Delivery Update Notification -->
                                            <div class="notification-card">
                                                <div class="notification-icon delivery">🚚</div>
                                                <div class="notification-content">
                                                    <h4>Out for Delivery</h4>
                                                    <p>Your Heavy Duty Hammer order is now out for delivery. Expected
                                                        arrival: 2-3 hours</p>
                                                </div>
                                                <div class="notification-time">4 hours ago</div>
                                                <div class="notification-status status-delivery">In Transit</div>
                                            </div>

                                            <!-- Booking Denied Notification -->
                                            <div class="notification-card">
                                                <div class="notification-icon denied">✗</div>
                                                <div class="notification-content">
                                                    <h4>Booking Declined</h4>
                                                    <p>Your plumbing service booking for October 28, 2025 has been
                                                        declined due to
                                                        scheduling conflict</p>
                                                </div>
                                                <div class="notification-time">1 day ago</div>
                                                <div class="notification-status status-denied">Declined</div>
                                            </div>

                                            <!-- Delivery Completed Notification -->
                                            <div class="notification-card">
                                                <div class="notification-icon accepted">📦</div>
                                                <div class="notification-content">
                                                    <h4>Delivery Completed</h4>
                                                    <p>Your Premium Paint Brush Set has been delivered successfully.
                                                        Please rate your
                                                        experience!</p>
                                                </div>
                                                <div class="notification-time">2 days ago</div>
                                                <div class="notification-status status-accepted">Delivered</div>
                                            </div>

                                            <!-- Booking Pending Notification -->
                                            <div class="notification-card">
                                                <div class="notification-icon pending">⏳</div>
                                                <div class="notification-content">
                                                    <h4>Booking Under Review</h4>
                                                    <p>Your AC repair booking is currently under review. We'll notify
                                                        you once a technician
                                                        is assigned</p>
                                                </div>
                                                <div class="notification-time">3 days ago</div>
                                                <div class="notification-status status-pending">Pending</div>
                                            </div>

                                            <div class="section-header">Earlier Notifications</div>

                                            <!-- Older notifications -->
                                            <div class="notification-card">
                                                <div class="notification-icon accepted">✓</div>
                                                <div class="notification-content">
                                                    <h4>Service Completed</h4>
                                                    <p>Your AC repair service has been completed successfully by Kusal
                                                        Jayawardena</p>
                                                </div>
                                                <div class="notification-time">1 week ago</div>
                                                <div class="notification-status status-accepted">Completed</div>
                                            </div>

                                            <div class="notification-card">
                                                <div class="notification-icon delivery">📦</div>
                                                <div class="notification-content">
                                                    <h4>Order Shipped</h4>
                                                    <p>Your Cordless Drill Machine has been shipped and is on its way
                                                    </p>
                                                </div>
                                                <div class="notification-time">1 week ago</div>
                                                <div class="notification-status status-delivery">Shipped</div>
                                            </div>

                                        </main>

                                        </body>

                                    </html>