<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ page import="java.util.*,com.dailyfixer.dao.GuideCommentDAO,com.dailyfixer.model.GuideComment" %>
            <%@ page import="java.text.SimpleDateFormat" %>
                <%@ page import="com.dailyfixer.model.User" %>

                    <% User currentUser=(User) session.getAttribute("currentUser"); if (currentUser==null ||
                        (!"volunteer".equalsIgnoreCase(currentUser.getRole()) &&
                        !"technician".equalsIgnoreCase(currentUser.getRole()))) {
                        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp" ); return; } int
                        userId=currentUser.getUserId(); GuideCommentDAO dao=new GuideCommentDAO(); List<GuideComment>
                        myComments = dao.getCommentsByGuideOwner(userId);
                        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
                        %>

                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Guide Comments | Daily Fixer</title>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap"
                                rel="stylesheet">
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

                                .comments-list {
                                    display: flex;
                                    flex-direction: column;
                                    gap: 15px;
                                }

                                .comment-card {
                                    background: var(--card);
                                    border: 1px solid var(--border);
                                    border-radius: var(--radius-md);
                                    padding: 20px;
                                    box-shadow: var(--shadow-sm);
                                    transition: all 0.2s;
                                }

                                .comment-card:hover {
                                    box-shadow: var(--shadow-md);
                                }

                                .comment-header {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    margin-bottom: 10px;
                                    border-bottom: 1px solid var(--border);
                                    padding-bottom: 10px;
                                }

                                .commenter-info {
                                    display: flex;
                                    align-items: center;
                                    gap: 10px;
                                }

                                .commenter-avatar {
                                    width: 40px;
                                    height: 40px;
                                    border-radius: 50%;
                                    background-color: var(--primary);
                                    color: var(--primary-foreground);
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    font-weight: bold;
                                    font-size: 1.2em;
                                }

                                .guide-link {
                                    font-size: 0.9em;
                                    color: var(--muted-foreground);
                                    text-decoration: none;
                                    display: flex;
                                    align-items: center;
                                    gap: 5px;
                                }

                                .guide-link:hover {
                                    color: var(--primary);
                                    text-decoration: underline;
                                }

                                .comment-body {
                                    font-size: 1rem;
                                    color: var(--foreground);
                                    line-height: 1.5;
                                    margin-bottom: 15px;
                                }

                                .comment-meta {
                                    font-size: 0.85em;
                                    color: var(--muted-foreground);
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .empty-state {
                                    text-align: center;
                                    padding: 60px;
                                    color: var(--muted-foreground);
                                    background: var(--card);
                                    border-radius: var(--radius-lg);
                                    border: 1px solid var(--border);
                                }

                                .empty-state h3 {
                                    color: var(--foreground);
                                    margin-bottom: 10px;
                                }
                            </style>
                        </head>

                        <body>
                            <c:choose>
                                <c:when test="${sessionScope.currentUser.role == 'technician'}">
                                    <jsp:include page="/pages/dashboards/techniciandash/sidebar.jsp" />
                                </c:when>
                                <c:otherwise>
                                    <jsp:include page="/pages/dashboards/volunteerdash/sidebar.jsp" />
                                </c:otherwise>
                            </c:choose>
                            <main class="container">
                                <h2>Guide Comments</h2>
                                <p style="color: var(--muted-foreground); margin-bottom: 25px;">Track all feedback on
                                    your
                                    contributions.</p>

                                <% if (myComments !=null && !myComments.isEmpty()) { %>
                                    <div class="comments-list">
                                        <% for (GuideComment c : myComments) { %>
                                            <div class="comment-card">
                                                <div class="comment-header">
                                                    <div class="commenter-info">
                                                        <div class="commenter-avatar">
                                                            <%= c.getUsername().substring(0, 1).toUpperCase() %>
                                                        </div>
                                                        <div>
                                                            <span style="font-weight: 600; color: var(--foreground);">
                                                                <%= c.getUsername() %>
                                                            </span>
                                                            <br>
                                                            <span
                                                                style="font-size: 0.8em; color: var(--muted-foreground);">
                                                                <%= sdf.format(c.getCreatedAt()) %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/guides/view?id=<%= c.getGuideId() %>"
                                                        class="guide-link">
                                                        On: <strong>
                                                            <%= c.getGuideTitle() %>
                                                        </strong> ↗
                                                    </a>
                                                </div>

                                                <div class="comment-body">
                                                    <%= c.getComment() %>
                                                </div>

                                                <!-- Optional: Add Reply or Delete functionality here later -->
                                            </div>
                                            <% } %>
                                    </div>
                                    <% } else { %>
                                        <div class="empty-state">
                                            <h3>No comments yet</h3>
                                            <p>When users comment on your guides, they will appear here.</p>
                                        </div>
                                        <% } %>
                            </main>
                        </body>

                        </html>