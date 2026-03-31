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
            max-width: 700px;
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

        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--foreground);
            margin-top: 28px;
            margin-bottom: 14px;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--border);
        }

        .file-upload-group {
            margin-bottom: 16px;
        }

        .file-upload-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 6px;
            color: var(--foreground);
            font-size: 0.9rem;
        }

        .file-upload-group .file-hint {
            font-size: 0.8rem;
            color: var(--muted-foreground);
            margin-bottom: 6px;
        }

        .file-upload-group input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 2px dashed var(--border);
            border-radius: var(--radius-md);
            background: var(--muted);
            cursor: pointer;
            font-size: 0.9rem;
        }

        .file-upload-group input[type="file"]:hover {
            border-color: var(--primary);
        }

        .file-preview {
            margin-top: 8px;
            max-width: 200px;
            max-height: 120px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            display: none;
            object-fit: cover;
        }

        .policy-group {
            margin-top: 24px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .policy-group input[type="checkbox"] {
            margin-top: 3px;
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
        }

        .policy-group label {
            font-size: 0.9rem;
            color: var(--foreground);
        }

        .policy-group label a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
        }

        .policy-group label a:hover {
            text-decoration: underline;
        }

        .required-star {
            color: var(--destructive);
        }
    </style>
</head>

<body>

    <div class="register-container">
        <div class="form-container">
            <div class="page-header">
                <h2>Driver Signup</h2>
                <p>Join DailyFixer as a Delivery Driver</p>
            </div>

            <%
                String error = request.getParameter("error");
                if (error != null && !error.isEmpty()) {
            %>
            <div class="server-error"><%= error %></div>
            <% } %>

            <div id="error" class="error-text" style="margin-bottom: 15px; text-align: center;"></div>

            <form action="RegisterDriverServlet" method="post" enctype="multipart/form-data" id="registerForm">

                <!-- Personal Information -->
                <div class="section-title">Personal Information</div>

                <div class="form-cols">
                    <div class="form-group">
                        <label for="first_name">First Name <span class="required-star">*</span></label>
                        <input type="text" name="first_name" id="first_name" placeholder="First Name" required>
                    </div>

                    <div class="form-group">
                        <label for="last_name">Last Name <span class="required-star">*</span></label>
                        <input type="text" name="last_name" id="last_name" placeholder="Last Name" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="username">Username <span class="required-star">*</span></label>
                    <input type="text" name="username" id="username" placeholder="Username" required>
                </div>

                <div class="form-cols">
                    <div class="form-group">
                        <label for="email">Email <span class="required-star">*</span></label>
                        <input type="email" name="email" id="email" placeholder="Email" required>
                    </div>

                    <div class="form-group">
                        <label for="phone_number">Phone Number <span class="required-star">*</span></label>
                        <input type="tel" name="phone_number" id="phone_number" placeholder="Phone Number" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="city">City <span class="required-star">*</span></label>
                    <input type="text" name="city" id="city" placeholder="City" required>
                </div>

                <!-- Identification Documents -->
                <div class="section-title">Identification Documents</div>

                <div class="form-group">
                    <label for="nic_number">NIC Number <span class="required-star">*</span></label>
                    <input type="text" name="nic_number" id="nic_number"
                           placeholder="e.g. 200012345678 or 901234567V" required>
                    <div id="nicError" class="error-text"></div>
                </div>

                <div class="form-cols">
                    <div class="file-upload-group">
                        <label>NIC Front Photo <span class="required-star">*</span></label>
                        <div class="file-hint">Upload photo of the front of your NIC (max 5MB)</div>
                        <input type="file" name="nic_front" id="nic_front" accept="image/*" required
                               onchange="previewFile(this, 'nicFrontPreview')">
                        <img id="nicFrontPreview" class="file-preview" alt="NIC Front Preview">
                    </div>

                    <div class="file-upload-group">
                        <label>NIC Back Photo <span class="required-star">*</span></label>
                        <div class="file-hint">Upload photo of the back of your NIC (max 5MB)</div>
                        <input type="file" name="nic_back" id="nic_back" accept="image/*" required
                               onchange="previewFile(this, 'nicBackPreview')">
                        <img id="nicBackPreview" class="file-preview" alt="NIC Back Preview">
                    </div>
                </div>

                <!-- Profile Picture -->
                <div class="section-title">Profile Picture</div>

                <div class="file-upload-group">
                    <label>Driver Photo <span class="required-star">*</span></label>
                    <div class="file-hint">This will be used as your profile picture on the platform (max 5MB)</div>
                    <input type="file" name="profile_picture" id="profile_picture" accept="image/*" required
                           onchange="previewFile(this, 'profilePreview')">
                    <img id="profilePreview" class="file-preview" alt="Profile Preview">
                </div>

                <!-- Driving License -->
                <div class="section-title">Driving License</div>

                <div class="form-cols">
                    <div class="file-upload-group">
                        <label>License Front Photo <span class="required-star">*</span></label>
                        <div class="file-hint">Upload photo of the front of your license (max 5MB)</div>
                        <input type="file" name="license_front" id="license_front" accept="image/*" required
                               onchange="previewFile(this, 'licenseFrontPreview')">
                        <img id="licenseFrontPreview" class="file-preview" alt="License Front Preview">
                    </div>

                    <div class="file-upload-group">
                        <label>License Back Photo</label>
                        <div class="file-hint">Optional — upload if your license has info on the back</div>
                        <input type="file" name="license_back" id="license_back" accept="image/*"
                               onchange="previewFile(this, 'licenseBackPreview')">
                        <img id="licenseBackPreview" class="file-preview" alt="License Back Preview">
                    </div>
                </div>

                <!-- Password -->
                <div class="section-title">Account Security</div>

                <div class="form-cols">
                    <div class="form-group">
                        <label for="password">Password <span class="required-star">*</span></label>
                        <input type="password" name="password" id="password" placeholder="Min 6 characters" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password <span class="required-star">*</span></label>
                        <input type="password" name="confirmPassword" id="confirmPassword"
                               placeholder="Confirm Password" required>
                    </div>
                </div>

                <!-- Policy Acceptance -->
                <div class="policy-group">
                    <input type="checkbox" name="policy_accepted" id="policy_accepted" required>
                    <label for="policy_accepted">
                        I have read and agree to the
                        <a href="${pageContext.request.contextPath}/pages/policies/driver-policies.jsp" target="_blank">Driver Policies</a>
                        <span class="required-star">*</span>
                    </label>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; margin-top: 24px;">
                    Submit Driver Application
                </button>
            </form>
            <p class="login-link">Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>

    <script>
        function previewFile(input, previewId) {
            var preview = document.getElementById(previewId);
            if (input.files && input.files[0]) {
                var file = input.files[0];

                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('Please select an image file (JPG, PNG, etc.)');
                    input.value = '';
                    preview.style.display = 'none';
                    return;
                }

                // Validate file size (5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert('File size must be less than 5MB');
                    input.value = '';
                    preview.style.display = 'none';
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
            }
        }

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var pw   = document.getElementById("password").value;
            var cpw  = document.getElementById("confirmPassword").value;
            var email = document.getElementById("email").value;
            var phone = document.getElementById("phone_number").value;
            var nic   = document.getElementById("nic_number").value.trim();
            var policy = document.getElementById("policy_accepted").checked;

            var errorMsg = "";

            if (!email.includes("@")) errorMsg += "Invalid email format.<br>";
            if (pw.length < 6) errorMsg += "Password must be at least 6 characters.<br>";
            if (pw !== cpw) errorMsg += "Passwords do not match.<br>";
            if (phone.length < 10) errorMsg += "Enter a valid phone number.<br>";

            // NIC validation: 9 digits + V/X or 12 digits
            var nicRegex = /^\d{9}[VvXx]$|^\d{12}$/;
            if (!nicRegex.test(nic)) {
                errorMsg += "Invalid NIC format. Use 9 digits + V/X or 12 digits.<br>";
                document.getElementById("nicError").textContent = "Invalid NIC format";
            } else {
                document.getElementById("nicError").textContent = "";
            }

            // Validate required files
            var nicFront = document.getElementById("nic_front").files.length;
            var nicBack  = document.getElementById("nic_back").files.length;
            var profile  = document.getElementById("profile_picture").files.length;
            var licFront = document.getElementById("license_front").files.length;

            if (nicFront === 0) errorMsg += "NIC front photo is required.<br>";
            if (nicBack === 0) errorMsg += "NIC back photo is required.<br>";
            if (profile === 0) errorMsg += "Profile picture is required.<br>";
            if (licFront === 0) errorMsg += "License front photo is required.<br>";

            if (!policy) errorMsg += "You must accept the driver policies.<br>";

            var errorDiv = document.getElementById("error");
            errorDiv.innerHTML = errorMsg;

            if (errorMsg !== "") {
                e.preventDefault();
                window.scrollTo({top: 0, behavior: 'smooth'});
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>

</html>