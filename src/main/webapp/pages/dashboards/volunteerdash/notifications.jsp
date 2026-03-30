<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.dailyfixer.model.User" %>

        <% User currentUser=(User) session.getAttribute("currentUser"); if (currentUser==null ||
            !"volunteer".equalsIgnoreCase(currentUser.getRole())) { response.sendRedirect(request.getContextPath()
            + "/pages/shared/login.jsp" ); return; } %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Notifications | Daily Fixer</title>
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">

                <style>
                    :root {
                        --panel-color: #dcdaff;
                        --accent: #8b95ff;
                        --text-dark: #000000;
                        --text-secondary: #333333;
                        --shadow-sm: 0 4px 12px rgba(0, 0, 0, 0.12);
                        --shadow-md: 0 8px 24px rgba(0, 0, 0, 0.18);
                        --shadow-lg: 0 12px 36px rgba(0, 0, 0, 0.22);
                    }

                    /* Reset */
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        background-color: var(--background);
                        color: var(--foreground);
                        display: flex;
                        min-height: 100vh;
                    }

                    /* Main Content */
                    .container {
                        flex: 1;
                        margin-left: 240px;
                        margin-top: 83px;
                        padding: 30px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-height: calc(100vh - 83px);
                    }

                    .empty-state {
                        text-align: center;
                        padding: 60px;
                        color: var(--muted-foreground);
                        background: var(--card);
                        border-radius: var(--radius-lg);
                        border: 1px solid var(--border);
                        max-width: 500px;
                        width: 100%;
                        box-shadow: var(--shadow-sm);
                    }

                    .empty-state h3 {
                        color: var(--foreground);
                        margin-bottom: 10px;
                        font-size: 1.5rem;
                    }

                    .empty-state .icon {
                        font-size: 3rem;
                        color: var(--primary);
                        margin-bottom: 20px;
                    }

                    @media (max-width: 900px) {
                        .container {
                            margin-left: 0 !important;
                            margin-top: 60px !important;
                            padding-top: 40px !important;
                        }
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/pages/dashboards/volunteerdash/sidebar.jsp" />

                <main class="container">
                    <div class="empty-state">
                        <div class="icon">🚧</div>
                        <h3>Under Construction</h3>
                        <p>The notifications system is currently being built. Check back later!</p>
                    </div>
                </main>
                <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
            </body>

            </html>