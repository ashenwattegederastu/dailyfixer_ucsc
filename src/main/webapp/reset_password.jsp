<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - DailyFixer</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
</head>
<body>

<div class="login-container">
    <div style="position: fixed; top: 20px; right: 20px; z-index: 1000;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
    </div>
    <div class="login-card">
        <div class="login-header">
            <h1 class="login-title">Reset Password</h1>
            <p class="login-subtitle">Create a new password for your account</p>
        </div>

        <% String error = (String) request.getAttribute("error");
            if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <% String message = (String) request.getAttribute("message");
            if (message != null) { %>
        <div class="alert alert-success"><%= message %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/ResetEmailPasswordEmailServlet" class="login-form">
            <input type="hidden" name="token" value="${param.token}">
            
            <div class="form-group">
                <label for="newPassword" class="form-label">New Password</label>
                <input
                        type="password"
                        id="newPassword"
                        name="newPassword"
                        class="form-input"
                        placeholder="Enter new password"
                        required>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="form-input"
                        placeholder="Confirm new password"
                        required>
            </div>

            <button type="submit" class="login-btn">Update Password</button>
        </form>

        <div class="login-footer">
            <p class="footer-text">
                <a href="${pageContext.request.contextPath}/login.jsp" class="footer-link">Back to Login</a>
            </p>
            <p class="footer-text">
                <a href="${pageContext.request.contextPath}/index.jsp" class="footer-link-secondary">← Back to Home</a>
            </p>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

</body>
</html>
