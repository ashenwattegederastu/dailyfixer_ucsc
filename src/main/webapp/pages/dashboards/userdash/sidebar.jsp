<%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <%@ page import="com.dailyfixer.model.User" %>

        <% User currentUser=(User) session.getAttribute("currentUser"); String firstName=currentUser !=null &&
            currentUser.getFirstName() !=null ? currentUser.getFirstName() : "User" ; String lastName=currentUser !=null
            && currentUser.getLastName() !=null ? currentUser.getLastName() : "" ; String username=currentUser !=null &&
            currentUser.getUsername() !=null ? currentUser.getUsername() : "user" ; String
            avatarLetter=firstName.length()> 0 ? firstName.substring(0, 1).toUpperCase() : "U";
            %>
            <link rel="stylesheet" type="text/css"
                href="${pageContext.request.contextPath}/assets/icons/regular/style.css" />
            <link rel="stylesheet" type="text/css"
                href="${pageContext.request.contextPath}/assets/icons/fill/style.css" />
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sidebar.css" />

            <aside class="sidebar">
                <div class="sidebar-header">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="logo"
                        style="text-decoration: none;">Daily Fixer</a>
                    <div class="panel-name">User Panel</div>
                </div>

                <div class="sidebar-nav">
                    <h3>Navigation</h3>
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/user/dashboard"
                                id="nav-user-dashboard">
                                <i class="ph ph-squares-four"></i>
                                Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="#"
                                id="nav-user-notifications">
                                <i class="ph ph-bell"></i>
                                Notifications
                            </a>
                        </li>

                        <li class="nav-section-title"
                            style="padding: 12px 20px 4px; color: var(--muted-foreground); font-weight: 600; font-size: 0.75em; text-transform: uppercase; letter-spacing: 0.05em; margin-top: 8px;">
                            Bookings
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/user/bookings/active"
                                id="nav-user-bookings-active">
                                <i class="ph ph-calendar-check"></i>
                                Active Bookings
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/user/bookings/completed"
                                id="nav-user-bookings-completed">
                                <i class="ph ph-check-circle"></i>
                                Completed Bookings
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/user/bookings/cancelled"
                                id="nav-user-bookings-cancelled">
                                <i class="ph ph-x-circle"></i>
                                Cancelled Bookings
                            </a>
                        </li>

                        <li class="nav-section-title"
                            style="padding: 12px 20px 4px; color: var(--muted-foreground); font-weight: 600; font-size: 0.75em; text-transform: uppercase; letter-spacing: 0.05em; margin-top: 8px;">
                            More
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/user/orders" id="nav-user-purchases">
                                <i class="ph ph-shopping-bag"></i>
                                My Purchases
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/chats" id="nav-user-chats">
                                <i class="ph ph-chats-circle"></i>
                                Chats
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myProfile.jsp"
                                id="nav-user-profile">
                                <i class="ph ph-user"></i>
                                My Profile
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="sidebar-footer">
                    <div class="user-profile-widget">
                        <div class="user-avatar">
                            <%= avatarLetter %>
                        </div>
                        <div class="user-info">
                            <div class="user-name">
                                <%= firstName %>
                                    <%= lastName %>
                            </div>
                            <div class="user-handle">@<%= username %>
                            </div>
                        </div>
                    </div>

                    <div class="sidebar-actions">
                        <a href="${pageContext.request.contextPath}/logout" class="action-btn logout-btn">
                            <i class="ph ph-sign-out"></i>
                            Log Out
                        </a>
                    </div>
                </div>
            </aside>

            <script>
                // Highlight active navigation item based on current URL
                document.addEventListener('DOMContentLoaded', function () {
                    const currentPath = window.location.pathname;
                    const navLinks = document.querySelectorAll('.sidebar-nav ul li a');

                    navLinks.forEach(link => {
                        const linkPath = new URL(link.href).pathname;
                        if (currentPath.includes(linkPath) || currentPath === linkPath) {
                            link.classList.add('active');
                        }
                    });

                    // Special handling for servlet paths
                    if (currentPath.includes('/user/dashboard') || currentPath.endsWith('userdashmain.jsp')) {
                        document.getElementById('nav-user-dashboard')?.classList.add('active');
                    } else if (currentPath.includes('/chats')) {
                        document.getElementById('nav-user-chats')?.classList.add('active');
                    } else if (currentPath.includes('/user/bookings/active')) {
                        document.getElementById('nav-user-bookings-active')?.classList.add('active');
                    } else if (currentPath.includes('/user/bookings/completed')) {
                        document.getElementById('nav-user-bookings-completed')?.classList.add('active');
                    } else if (currentPath.includes('/user/bookings/cancelled')) {
                        document.getElementById('nav-user-bookings-cancelled')?.classList.add('active');
                    } else if (currentPath.includes('/user/orders')) {
                        document.getElementById('nav-user-purchases')?.classList.add('active');
                    }
                });
            </script>