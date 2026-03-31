<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Driver Policies | Daily Fixer</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .policy-container {
            max-width: 800px;
            margin: 60px auto;
            padding: 40px 30px;
        }

        .policy-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 40px;
            box-shadow: var(--shadow-sm);
        }

        .policy-card h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--foreground);
            margin-bottom: 8px;
        }

        .policy-card p {
            color: var(--muted-foreground);
            font-size: 0.95rem;
            line-height: 1.7;
            margin-bottom: 16px;
        }

        .placeholder-notice {
            background: var(--muted);
            border: 1px dashed var(--border);
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            margin-top: 24px;
            color: var(--muted-foreground);
        }

        .back-link {
            display: inline-block;
            margin-top: 24px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="policy-container">
        <div class="policy-card">
            <h1>Driver Policies & Terms of Service</h1>
            <p>By registering as a driver on Daily Fixer, you agree to abide by the following policies and guidelines.</p>

            <div class="placeholder-notice">
                <p style="font-size: 1.1rem; font-weight: 600; margin-bottom: 8px;">📄 Policies Coming Soon</p>
                <p style="margin-bottom: 0;">The full driver policies document will be published here shortly. By proceeding with registration, you acknowledge that you will be bound by these policies once published.</p>
            </div>

            <a href="${pageContext.request.contextPath}/registerDriver.jsp" class="back-link">← Back to Registration</a>
        </div>
    </div>
</body>
</html>
