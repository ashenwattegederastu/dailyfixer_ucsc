<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Driver Signup | DailyFixer</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
        <style>
            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background-color: var(--background);
                padding: 40px 20px;
            }

            .register-container {
                width: 100%;
                max-width: 600px;
            }

            .form-container {
                margin: 0 auto;
            }

            .page-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .page-header h2 {
                font-size: 2rem;
                color: var(--primary);
                margin-bottom: 10px;
            }

            .error-text {
                color: var(--destructive);
                font-size: 0.85rem;
                margin-top: 5px;
                font-weight: 500;
            }

            .server-error {
                background-color: var(--destructive);
                color: white;
                padding: 15px;
                border-radius: var(--radius-md);
                margin-bottom: 20px;
                font-weight: 500;
            }

            .form-cols {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            @media (max-width: 600px) {
                .form-cols {
                    grid-template-columns: 1fr;
                    gap: 0;
                }
            }

            .login-link {
                text-align: center;
                margin-top: 20px;
                color: var(--muted-foreground);
            }

            .login-link a {
                color: var(--primary);
                font-weight: 600;
                text-decoration: none;
            }

            .login-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>

        <div class="register-container">
            <div class="form-container">
                <div class="page-header">
                    <h2>Driver Signup</h2>
                    <p style="color: var(--muted-foreground)">Join DailyFixer as a Driver</p>
                </div>

                <div id="error" class="error-text" style="margin-bottom: 15px; text-align: center;"></div>

                <form action="RegisterDriverServlet" method="post" id="registerForm">
                    <div class="form-cols">
                        <div class="form-group">
                            <label for="first_name">First Name</label>
                            <input type="text" name="first_name" id="first_name" placeholder="First Name" required>
                        </div>

                        <div class="form-group">
                            <label for="last_name">Last Name</label>
                            <input type="text" name="last_name" id="last_name" placeholder="Last Name" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" name="username" id="username" placeholder="Username" required>
                    </div>

                    <div class="form-cols">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" name="email" id="email" placeholder="Email" required>
                        </div>

                        <div class="form-group">
                            <label for="phone_number">Phone Number</label>
                            <input type="tel" name="phone_number" id="phone_number" placeholder="Phone Number" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" name="city" id="city" placeholder="City" required>
                    </div>

                    <div class="form-cols">
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" name="password" id="password" placeholder="Password" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" name="confirmPassword" id="confirmPassword"
                                placeholder="Confirm Password" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="width: 100%; margin-top: 20px;">Register as
                        Driver</button>
                </form>
                <p class="login-link">Already have an account? <a href="login.jsp">Login here</a></p>
            </div>
        </div>

        <script>
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                let pw = document.getElementById("password").value;
                let cpw = document.getElementById("confirmPassword").value;
                let email = document.getElementById("email").value;
                let phone = document.getElementById("phone_number").value;

                let errorMsg = "";

                if (!email.includes("@")) errorMsg += "Invalid email format.<br>";
                if (pw.length < 6) errorMsg += "Password must be at least 6 characters.<br>";
                if (pw !== cpw) errorMsg += "Passwords do not match.<br>";
                if (phone.length < 10) errorMsg += "Enter a valid phone number.<br>";

                let errorDiv = document.getElementById("error");
                errorDiv.innerHTML = errorMsg;

                if (errorMsg !== "") {
                    e.preventDefault();
                }
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
    </body>

    </html>