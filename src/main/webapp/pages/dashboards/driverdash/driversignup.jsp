<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Driver Signup | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
    --panel-color: #dcdaff;
    --accent: #8b95ff;
    --text-dark: #000000;
    --text-secondary: #333333;
    --shadow-sm: 0 4px 12px rgba(0,0,0,0.12);
    --shadow-md: 0 8px 24px rgba(0,0,0,0.18);
    --shadow-lg: 0 12px 36px rgba(0,0,0,0.22);
}

/* Reset */
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Inter', sans-serif;
    background: linear-gradient(135deg, var(--panel-color), #f0f0ff);
    color: var(--text-dark);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

/* Login Wrapper */
.login-wrapper {
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
}

/* Login Card */
.login-card {
    background: #fff;
    border-radius: 16px;
    box-shadow: var(--shadow-lg);
    border: 1px solid rgba(0,0,0,0.1);
    padding: 40px;
    text-align: center;
}

.login-card h2 {
    font-size: 2em;
    margin-bottom: 30px;
    color: var(--accent);
    font-weight: 700;
}

/* Input Fields */
.input-field {
    margin-bottom: 20px;
    text-align: left;
}

.input-field label {
    display: block;
    margin-bottom: 8px;
    color: var(--text-dark);
    font-weight: 600;
    font-size: 0.9rem;
}

.input-field input {
    width: 100%;
    padding: 14px 16px;
    border: 2px solid #e1e5e9;
    border-radius: 10px;
    font-family: 'Inter', sans-serif;
    font-size: 0.95rem;
    transition: all 0.2s;
    background: #fff;
}

.input-field input:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 4px rgba(139, 149, 255, 0.1);
    transform: translateY(-1px);
}

.input-field input:hover {
    border-color: var(--accent);
}

/* Login Button */
.login-btn {
    width: 100%;
    padding: 16px;
    background: linear-gradient(135deg, var(--accent), #7ba3d4);
    color: white;
    border: none;
    border-radius: 10px;
    font-family: 'Inter', sans-serif;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    margin-top: 10px;
    box-shadow: var(--shadow-sm);
}

.login-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

.login-btn:active {
    transform: translateY(0);
}

/* Back Link */
.back-link {
    display: inline-block;
    margin-top: 20px;
    color: var(--accent);
    text-decoration: none;
    font-weight: 500;
    font-size: 0.9rem;
    transition: all 0.2s;
}

.back-link:hover {
    color: #7ba3d4;
    text-decoration: underline;
}

/* Error Message */
.error {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: white;
    padding: 12px 16px;
    border-radius: 8px;
    margin-top: 20px;
    font-weight: 500;
    font-size: 0.9rem;
    box-shadow: var(--shadow-sm);
}

/* Form Validation */
.input-field input:invalid {
    border-color: #dc3545;
}

.input-field input:valid {
    border-color: #28a745;
}

/* Responsive */
@media (max-width: 600px) {
    .login-card {
        padding: 30px 20px;
    }
    
    .login-card h2 {
        font-size: 1.6em;
    }
}
</style>
</head>
<body>
<div class="login-wrapper">
  <div class="login-card">
    <h2>Driver Signup</h2>
    <form action="${pageContext.request.contextPath}/DriverSignupServlet" method="post" onsubmit="return validateSignup()">
      <div class="input-field">
        <label for="fname">First Name</label>
        <input type="text" name="fname" id="fname" required>
      </div>
      <div class="input-field">
        <label for="lname">Last Name</label>
        <input type="text" name="lname" id="lname" required>
      </div>
      <div class="input-field">
        <label for="username">Username</label>
        <input type="text" name="username" id="username" required>
      </div>
      <div class="input-field">
        <label for="password">Password</label>
        <input type="password" name="password" id="password" required>
      </div>
      <div class="input-field">
        <label for="email">Email</label>
        <input type="email" name="email" id="email" required>
      </div>
      <div class="input-field">
        <label for="phone">Phone</label>
        <input type="tel" name="phone" id="phone" required>
      </div>
      <div class="input-field">
        <label for="profilepic">Profile Picture URL</label>
        <input type="url" name="profilepic" id="profilepic">
      </div>
      <div class="input-field">
        <label for="real_pic">Driver Real Picture URL</label>
        <input type="url" name="real_pic" id="real_pic">
      </div>
      <div class="input-field">
        <label for="service_area">Service Area</label>
        <input type="text" name="service_area" id="service_area" required>
      </div>
      <div class="input-field">
        <label for="license_pic">License Picture URL</label>
        <input type="url" name="license_pic" id="license_pic">
      </div>
      <button type="submit" class="login-btn">Sign Up</button>
    </form>
    <a href="../../pages/shared/login.jsp" class="back-link">← Back to Login</a>
    <c:if test="${not empty error}">
      <div class="error">${error}</div>
    </c:if>
  </div>
</div>

<script>
  function validateSignup() {
    let fields = ['fname','lname','username','password','email','phone','service_area'];
    for(let f of fields){
      if(document.querySelector(`[name=${f}]`).value.trim() === ""){
        alert("Please fill all required fields");
        return false;
      }
    }
    return true;
  }
</script>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>
</html>
