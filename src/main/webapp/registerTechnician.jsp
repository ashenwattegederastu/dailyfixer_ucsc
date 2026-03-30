<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ page import="java.util.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Register Technician - DailyFixer</title>
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
                    max-width: 650px;
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

                .page-header p {
                    color: var(--muted-foreground);
                }

                .error-text {
                    color: var(--destructive);
                    font-size: 0.85rem;
                    font-weight: 500;
                }

                .server-error {
                    background-color: var(--destructive);
                    color: white;
                    padding: 15px;
                    border-radius: var(--radius-md);
                    margin-bottom: 20px;
                    font-weight: 500;
                    line-height: 1.6;
                }

                .section-title {
                    font-size: 0.85rem;
                    font-weight: 700;
                    color: var(--primary);
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    margin-top: 24px;
                    margin-bottom: 16px;
                }

                .section-title:first-of-type {
                    margin-top: 0;
                }

                .form-cols {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 16px;
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

                @media (max-width: 600px) {
                    .form-cols {
                        grid-template-columns: 1fr;
                        gap: 0;
                    }
                }
            </style>
        </head>

        <body>

            <div class="register-container">
                <div class="form-container">
                    <div class="page-header">
                        <h2>Technician Account</h2>
                        <p>Register to start accepting jobs</p>
                    </div>

                    <div id="errorMsg" class="server-error" style="display: none;"></div>

                    <form method="post" action="registerTechnician" id="registerForm">
                        <div class="section-title">Personal Details</div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="firstName">First Name</label>
                                <input type="text" name="firstName" id="firstName" placeholder="First Name" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Last Name</label>
                                <input type="text" name="lastName" id="lastName" placeholder="Last Name" required>
                            </div>
                        </div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" name="username" id="username" placeholder="Username" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" name="email" id="email" placeholder="Email" required>
                            </div>
                        </div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" name="password" id="password"
                                    placeholder="Password (min 6 chars)" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <input type="password" name="confirmPassword" id="confirmPassword"
                                    placeholder="Confirm Password" required>
                            </div>
                        </div>

                        <div class="section-title">Contact Information</div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" name="phone" id="phone" placeholder="Phone Number">
                            </div>
                            <div class="form-group">
                                <label for="city">City</label>
                                <select name="city" id="city" class="filter-select" style="width: 100%;" required>
                                    <option value="">-- Select city --</option>
                                    <% String[]
                                        cities={"Colombo","Kandy","Galle","Jaffna","Kurunegala","Matara","Trincomalee","Batticaloa","Negombo","Anuradhapura","Polonnaruwa","Badulla","Ratnapura","Puttalam","Kilinochchi","Mannar","Hambantota"};
                                        for (String c : cities) { %>
                                        <option value="<%=c%>">
                                            <%=c%>
                                        </option>
                                        <% } %>
                                </select>
                            </div>
                        </div>

                        <button type="submit" class="btn-primary" style="width: 100%; margin-top: 24px;">Register
                            Technician</button>
                    </form>
                    <p class="login-link">Already have an account? <a href="login.jsp">Login here</a></p>
                </div>
            </div>

            <script>
                document.getElementById('registerForm').addEventListener('submit', function (e) {
                    var errorMsg = [];
                    var firstName = document.getElementById('firstName').value.trim();
                    var lastName = document.getElementById('lastName').value.trim();
                    var username = document.getElementById('username').value.trim();
                    var email = document.getElementById('email').value.trim();
                    var password = document.getElementById('password').value;
                    var confirmPassword = document.getElementById('confirmPassword').value;
                    var city = document.getElementById('city').value;

                    if (!firstName) errorMsg.push("First Name is required.");
                    if (!lastName) errorMsg.push("Last Name is required.");
                    if (!username) errorMsg.push("Username is required.");
                    if (!email) errorMsg.push("Email is required.");
                    if (!password) errorMsg.push("Password is required.");
                    if (password && password.length < 6) errorMsg.push("Password must be at least 6 characters.");
                    if (password !== confirmPassword) errorMsg.push("Passwords do not match.");
                    if (!city) errorMsg.push("City is required.");

                    var errorDiv = document.getElementById('errorMsg');
                    if (errorMsg.length > 0) {
                        errorDiv.innerHTML = errorMsg.join("<br>");
                        errorDiv.style.display = 'block';
                        e.preventDefault();
                    } else {
                        errorDiv.style.display = 'none';
                    }
                });
            </script>
            <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

        </body>

        </html>