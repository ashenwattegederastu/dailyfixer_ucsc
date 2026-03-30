<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Volunteer Signup - Daily Fixer</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
            <link
                    rel="stylesheet"
                    type="text/css"
                    href="${pageContext.request.contextPath}/assets/icons/regular/style.css"
            />
            <link
                    rel="stylesheet"
                    type="text/css"
                    href="${pageContext.request.contextPath}/assets/icons/fill/style.css"
            />
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

                /* Step indicator */
                .step-indicator {
                    display: flex;
                    justify-content: center;
                    gap: 8px;
                    margin-bottom: 30px;
                }

                .step-circle {
                    width: 36px;
                    height: 36px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 700;
                    font-size: 0.85rem;
                    border: 2px solid var(--border);
                    color: var(--muted-foreground);
                    background: var(--card);
                    transition: all 0.3s ease;
                }

                .step-circle.active {
                    background: var(--primary);
                    color: var(--primary-foreground);
                    border-color: var(--primary);
                    box-shadow: var(--shadow-md);
                }

                .step-circle.completed {
                    background: oklch(0.6290 0.1902 156.4499);
                    color: white;
                    border-color: oklch(0.6290 0.1902 156.4499);
                }

                .step-line {
                    width: 40px;
                    height: 2px;
                    background: var(--border);
                    align-self: center;
                    transition: background 0.3s;
                }

                .step-line.completed {
                    background: oklch(0.6290 0.1902 156.4499);
                }

                /* Form step visibility */
                .form-step {
                    display: none;
                }

                .form-step.active {
                    display: block;
                    animation: fadeIn 0.3s ease;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(10px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .section-title {
                    font-size: 1.1rem;
                    font-weight: 700;
                    color: var(--foreground);
                    margin-bottom: 4px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .section-subtitle {
                    font-size: 0.85rem;
                    color: var(--muted-foreground);
                    margin-bottom: 20px;
                }

                /* Extend framework .form-group for types not covered */
                .form-group input[type="email"],
                .form-group input[type="password"],
                .form-group input[type="tel"],
                .form-group select {
                    width: 100%;
                    padding: 10px 15px;
                    border: 2px solid var(--border);
                    border-radius: var(--radius-md);
                    font-size: 0.9rem;
                    background-color: var(--input);
                    color: var(--foreground);
                    transition: border-color 0.2s, background-color 0.3s ease, color 0.3s ease;
                    font-family: var(--font-sans), serif;
                }

                .form-group input[type="email"]:focus,
                .form-group input[type="password"]:focus,
                .form-group input[type="tel"]:focus,
                .form-group select:focus {
                    outline: none;
                    border-color: var(--ring);
                }

                .form-cols {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
                }

                /* Checkbox grid for expertise */
                .checkbox-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 8px;
                    margin-bottom: 12px;
                }

                .checkbox-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    padding: 8px 12px;
                    border: 2px solid var(--border);
                    border-radius: var(--radius-md);
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .checkbox-item:hover {
                    border-color: var(--ring);
                    background: var(--accent);
                }

                .checkbox-item input[type="checkbox"] {
                    width: 16px;
                    height: 16px;
                    accent-color: var(--primary);
                }

                .checkbox-item label {
                    font-size: 0.85rem;
                    color: var(--foreground);
                    cursor: pointer;
                    margin: 0;
                    font-weight: 500;
                }

                /* Radio groups */
                .radio-group {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                    margin-bottom: 12px;
                }

                .radio-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    padding: 8px 16px;
                    border: 2px solid var(--border);
                    border-radius: var(--radius-md);
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .radio-item:hover {
                    border-color: var(--ring);
                    background: var(--accent);
                }

                .radio-item input[type="radio"] {
                    width: 16px;
                    height: 16px;
                    accent-color: var(--primary);
                }

                .radio-item label {
                    font-size: 0.85rem;
                    color: var(--foreground);
                    cursor: pointer;
                    margin: 0;
                    font-weight: 500;
                }

                /* File upload area */
                .file-upload-area {
                    border: 2px dashed var(--border);
                    border-radius: var(--radius-md);
                    padding: 20px;
                    text-align: center;
                    cursor: pointer;
                    transition: all 0.2s;
                    background: var(--input);
                }

                .file-upload-area:hover {
                    border-color: var(--ring);
                    background: var(--accent);
                }

                .file-upload-area .upload-icon {
                    font-size: 1.5rem;
                    margin-bottom: 4px;
                }

                .file-upload-area .upload-text {
                    font-size: 0.85rem;
                    color: var(--muted-foreground);
                }

                .file-upload-area .upload-hint {
                    font-size: 0.75rem;
                    color: var(--muted-foreground);
                    margin-top: 4px;
                }

                /* Proof upload block */
                .proof-block {
                    background: var(--muted);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-lg);
                    padding: 16px;
                    margin-bottom: 12px;
                }

                .proof-block .proof-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 12px;
                }

                .proof-block .proof-number {
                    font-weight: 700;
                    font-size: 0.85rem;
                    color: var(--primary);
                }

                .proof-block .btn-remove-proof {
                    background: none;
                    border: none;
                    color: var(--destructive);
                    cursor: pointer;
                    font-size: 0.8rem;
                    font-weight: 600;
                }

                /* Agreement checkboxes */
                .agreement-group {
                    display: flex;
                    align-items: flex-start;
                    gap: 10px;
                    margin-bottom: 14px;
                    padding: 12px;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    background: var(--muted);
                }

                .agreement-group input[type="checkbox"] {
                    margin-top: 3px;
                    width: 18px;
                    height: 18px;
                    accent-color: var(--primary);
                    flex-shrink: 0;
                }

                .agreement-group label {
                    font-size: 0.85rem;
                    color: var(--foreground);
                    margin: 0;
                    line-height: 1.4;
                }

                /* Button row */
                .btn-row {
                    display: flex;
                    justify-content: space-between;
                    margin-top: 24px;
                    gap: 12px;
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

                .file-preview {
                    font-size: 0.8rem;
                    color: oklch(0.6290 0.1902 156.4499);
                    margin-top: 6px;
                    font-weight: 600;
                }

                @media (max-width: 640px) {
                    .form-cols {
                        grid-template-columns: 1fr;
                        gap: 0;
                    }

                    .checkbox-grid {
                        grid-template-columns: 1fr;
                    }

                    .radio-group {
                        flex-direction: column;
                    }

                    .step-line {
                        width: 20px;
                    }
                }
            </style>
        </head>

        <body>

            <div class="register-container">
                <div class="form-container">
                    <div class="page-header">
                        <h2>Volunteer Signup</h2>
                        <p>Join DailyFixer as a Volunteer</p>
                    </div>

                    <!-- Step Indicator -->
                    <div class="step-indicator">
                        <div class="step-circle active" id="stepCircle1">1</div>
                        <div class="step-line" id="stepLine1"></div>
                        <div class="step-circle" id="stepCircle2">2</div>
                        <div class="step-line" id="stepLine2"></div>
                        <div class="step-circle" id="stepCircle3">3</div>
                        <div class="step-line" id="stepLine3"></div>
                        <div class="step-circle" id="stepCircle4">4</div>
                    </div>

                    <% String serverError=(String) request.getAttribute("errorMsg"); %>
                        <% if (serverError !=null) { %>
                            <div class="server-error">
                                <%= serverError %>
                            </div>
                            <% } %>

                                <form action="${pageContext.request.contextPath}/registerVolunteer" method="post"
                                    enctype="multipart/form-data" id="registerForm">

                                    <!-- ===== STEP 1: Basic Account Info ===== -->
                                    <div class="form-step active" id="step1">
                                        <div class="section-title"><i class="ph ph-user-check"></i> Basic Account Information</div>
                                        <div class="section-subtitle">These are required for your account.</div>

                                        <div class="form-group">
                                            <label for="fullName">Full Name</label>
                                            <input type="text" id="fullName" name="fullName"
                                                placeholder="Enter your full name">
                                            <div id="fullNameError" class="error-text"></div>
                                        </div>

                                        <div class="form-group">
                                            <label for="username">Username</label>
                                            <input type="text" id="username" name="username"
                                                placeholder="Choose a username">
                                            <div id="usernameError" class="error-text"></div>
                                        </div>

                                        <div class="form-cols">
                                            <div class="form-group">
                                                <label for="email">Email</label>
                                                <input type="email" id="email" name="email"
                                                    placeholder="name@example.com">
                                                <div id="emailError" class="error-text"></div>
                                            </div>
                                            <div class="form-group">
                                                <label for="phone">Phone Number</label>
                                                <input type="tel" id="phone" name="phone" placeholder="10-digit number">
                                                <div id="phoneError" class="error-text"></div>
                                            </div>
                                        </div>

                                        <div class="form-cols">
                                            <div class="form-group">
                                                <label for="password">Password</label>
                                                <input type="password" id="password" name="password"
                                                    placeholder="Create password">
                                                <div id="passwordError" class="error-text"></div>
                                            </div>
                                            <div class="form-group">
                                                <label for="confirmPassword">Confirm Password</label>
                                                <input type="password" id="confirmPassword" name="confirmPassword"
                                                    placeholder="Confirm password">
                                                <div id="confirmPasswordError" class="error-text"></div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="city">City / District</label>
                                            <select id="city" name="city" class="filter-select" style="width: 100%">
                                                <option value="">-- Select City --</option>
                                                <option>Colombo</option>
                                                <option>Kandy</option>
                                                <option>Galle</option>
                                                <option>Jaffna</option>
                                                <option>Negombo</option>
                                                <option>Matara</option>
                                                <option>Trincomalee</option>
                                                <option>Anuradhapura</option>
                                                <option>Kurunegala</option>
                                                <option>Ratnapura</option>
                                                <option>Badulla</option>
                                                <option>Hambantota</option>
                                                <option>Puttalam</option>
                                                <option>Polonnaruwa</option>
                                                <option>Nuwara Eliya</option>
                                                <option>Vavuniya</option>
                                                <option>Mannar</option>
                                                <option>Mullaitivu</option>
                                                <option>Kalutara</option>
                                                <option>Batticaloa</option>
                                                <option>Ampara</option>
                                                <option>Monaragala</option>
                                                <option>Kegalle</option>
                                                <option>Matalawa</option>
                                            </select>
                                            <div id="cityError" class="error-text"></div>
                                        </div>

                                        <div class="form-group">
                                            <label>Profile Picture (Optional)</label>
                                            <div class="file-upload-area"
                                                onclick="document.getElementById('profilePicture').click()">
                                                <div class="upload-icon"><i class="ph ph-images-square"></i></div>
                                                <div class="upload-text">Click to upload profile picture</div>
                                                <div class="upload-hint">JPG, PNG — Max 2MB</div>
                                            </div>
                                            <input type="file" id="profilePicture" name="profilePicture"
                                                accept="image/jpeg,image/png" style="display:none"
                                                onchange="showFileName(this, 'profilePreview')">
                                            <div id="profilePreview" class="file-preview"></div>
                                        </div>

                                        <div id="step1Error" class="error-text"
                                            style="text-align:center;margin-bottom:10px;"></div>

                                        <div class="btn-row" style="justify-content:flex-end;">
                                            <button type="button" class="btn-primary" onclick="nextStep(1)">Next
                                                →</button>
                                        </div>
                                    </div>

                                    <!-- ===== STEP 2: Professional Info ===== -->
                                    <div class="form-step" id="step2">
                                        <div class="section-title"><i class="ph ph-toolbox"></i> Professional Information</div>
                                        <div class="section-subtitle">Help us understand your expertise.</div>

                                        <div class="form-group">
                                            <label>Area of Expertise (Select all that apply)</label>
                                            <div class="checkbox-grid">
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp1" name="expertise"
                                                        value="Home Repairs">
                                                    <label for="exp1">Home Repairs</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp2" name="expertise" value="Plumbing">
                                                    <label for="exp2">Plumbing</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp3" name="expertise"
                                                        value="Electrical">
                                                    <label for="exp3">Electrical</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp4" name="expertise"
                                                        value="Vehicle Repairs">
                                                    <label for="exp4">Vehicle Repairs</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp5" name="expertise"
                                                        value="Computer Hardware">
                                                    <label for="exp5">Computer Hardware</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp6" name="expertise"
                                                        value="Mobile Phone Repairs">
                                                    <label for="exp6">Mobile Phone Repairs</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp7" name="expertise"
                                                        value="Appliances">
                                                    <label for="exp7">Appliances</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="exp8" name="expertise"
                                                        value="Farming Equipment">
                                                    <label for="exp8">Farming Equipment</label>
                                                </div>
                                            </div>
                                            <div class="form-group" style="margin-top:4px;">
                                                <input type="text" id="expertiseOther" name="expertiseOther"
                                                    placeholder="Other expertise (optional)">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>Skill Level</label>
                                            <div class="radio-group">
                                                <div class="radio-item">
                                                    <input type="radio" id="sl1" name="skillLevel" value="Beginner">
                                                    <label for="sl1">Beginner</label>
                                                </div>
                                                <div class="radio-item">
                                                    <input type="radio" id="sl2" name="skillLevel" value="Intermediate">
                                                    <label for="sl2">Intermediate</label>
                                                </div>
                                                <div class="radio-item">
                                                    <input type="radio" id="sl3" name="skillLevel" value="Advanced">
                                                    <label for="sl3">Advanced</label>
                                                </div>
                                                <div class="radio-item">
                                                    <input type="radio" id="sl4" name="skillLevel" value="Professional">
                                                    <label for="sl4">Professional</label>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>Years of Experience</label>
                                            <div class="radio-group">
                                                <div class="radio-item">
                                                    <input type="radio" id="ey1" name="experienceYears" value="0-1">
                                                    <label for="ey1">0–1</label>
                                                </div>
                                                <div class="radio-item">
                                                    <input type="radio" id="ey2" name="experienceYears" value="1-3">
                                                    <label for="ey2">1–3</label>
                                                </div>
                                                <div class="radio-item">
                                                    <input type="radio" id="ey3" name="experienceYears" value="3-5">
                                                    <label for="ey3">3–5</label>
                                                </div>
                                                <div class="radio-item">
                                                    <input type="radio" id="ey4" name="experienceYears" value="5+">
                                                    <label for="ey4">5+</label>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="bio">Short Bio</label>
                                            <textarea id="bio" name="bio"
                                                placeholder="Tell us about your background and why you want to contribute guides..."
                                                rows="4"></textarea>
                                        </div>

                                        <div class="form-group">
                                            <label for="sampleGuide">Sample Guide (Optional but Recommended)</label>
                                            <textarea id="sampleGuide" name="sampleGuide"
                                                placeholder="Write a short repair guide (5–10 steps), or paste a link to your blog/portfolio..."
                                                rows="5"></textarea>
                                        </div>

                                        <div class="form-group">
                                            <label>Or Upload a Sample Guide PDF</label>
                                            <div class="file-upload-area"
                                                onclick="document.getElementById('sampleGuideFile').click()">
                                                <div class="upload-icon"><i class="ph ph-file-pdf"></i></div>
                                                <div class="upload-text">Click to upload PDF</div>
                                                <div class="upload-hint">PDF only — Max 5MB</div>
                                            </div>
                                            <input type="file" id="sampleGuideFile" name="sampleGuideFile" accept=".pdf"
                                                style="display:none" onchange="showFileName(this, 'samplePreview')">
                                            <div id="samplePreview" class="file-preview"></div>
                                        </div>

                                        <div id="step2Error" class="error-text"
                                            style="text-align:center;margin-bottom:10px;"></div>

                                        <div class="btn-row">
                                            <button type="button" class="btn-secondary" onclick="prevStep(2)">←
                                                Back</button>
                                            <button type="button" class="btn-primary" onclick="nextStep(2)">Next
                                                →</button>
                                        </div>
                                    </div>

                                    <!-- ===== STEP 3: Qualification Proofs ===== -->
                                    <div class="form-step" id="step3">
                                        <div class="section-title"><i class="ph ph-certificate"></i> Qualification Proof Upload</div>
                                        <div class="section-subtitle">Upload up to 5 images to prove your
                                            qualifications. (JPG/PNG, max 2MB each)</div>

                                        <div id="proofsContainer">
                                            <!-- Proof 1 (always visible) -->
                                            <div class="proof-block" id="proofBlock_0">
                                                <div class="proof-header">
                                                    <span class="proof-number">Proof #1</span>
                                                </div>
                                                <div class="form-group">
                                                    <label>Proof Type</label>
                                                    <select name="proofType_0" class="filter-select" style="width:100%">
                                                        <option value="">Select type...</option>
                                                        <option value="Educational Certificate">Educational Certificate
                                                        </option>
                                                        <option value="Technical Certification">Technical Certification
                                                        </option>
                                                        <option value="Trade License">Trade License</option>
                                                        <option value="Workshop Training Certificate">Workshop Training
                                                            Certificate</option>
                                                        <option value="Work Experience Letter">Work Experience Letter
                                                        </option>
                                                        <option value="Portfolio Screenshot">Portfolio Screenshot
                                                        </option>
                                                        <option value="Previous Published Guide">Previous Published
                                                            Guide</option>
                                                        <option value="Professional ID">Professional ID</option>
                                                        <option value="Other">Other</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <div class="file-upload-area"
                                                        onclick="document.getElementById('proofImage_0').click()">
                                                        <div class="upload-icon"><i class="ph ph-images-square"></i> or <i class="ph ph-file-pdf"></i></div>
                                                        <div class="upload-text">Click to upload image</div>
                                                        <div class="upload-hint">JPG, PNG — Max 2MB</div>
                                                    </div>
                                                    <input type="file" id="proofImage_0" name="proofImage_0"
                                                        accept="image/jpeg,image/png" style="display:none"
                                                        onchange="showFileName(this, 'proofPreview_0')">
                                                    <div id="proofPreview_0" class="file-preview"></div>
                                                </div>
                                                <div class="form-group">
                                                    <label>Description</label>
                                                    <input type="text" name="proofDesc_0"
                                                        placeholder="Brief description of this proof">
                                                </div>
                                            </div>
                                        </div>

                                        <button type="button" class="btn-secondary"
                                            style="margin-bottom:16px;font-size:0.85rem;padding:8px 16px;"
                                            onclick="addProofBlock()" id="addProofBtn">
                                            + Add Another Proof
                                        </button>

                                        <div id="step3Error" class="error-text"
                                            style="text-align:center;margin-bottom:10px;"></div>

                                        <div class="btn-row">
                                            <button type="button" class="btn-secondary" onclick="prevStep(3)">←
                                                Back</button>
                                            <button type="button" class="btn-primary" onclick="nextStep(3)">Next
                                                →</button>
                                        </div>
                                    </div>

                                    <!-- ===== STEP 4: Agreement & Declaration ===== -->
                                    <div class="form-step" id="step4">
                                        <div class="section-title"><i class="ph ph-check-square-offset"></i> Agreement & Declaration</div>
                                        <div class="section-subtitle">Please read and agree to the following before
                                            submitting.</div>

                                        <div class="agreement-group">
                                            <input type="checkbox" id="agree1" name="agree1">
                                            <label for="agree1">I confirm all information provided is true and
                                                accurate.</label>
                                        </div>

                                        <div class="agreement-group">
                                            <input type="checkbox" id="agree2" name="agree2">
                                            <label for="agree2">I understand my account will be reviewed by an admin
                                                before activation.</label>
                                        </div>

                                        <div class="agreement-group">
                                            <input type="checkbox" id="agree3" name="agree3">
                                            <label for="agree3">I agree that providing false information may result in
                                                rejection or suspension.</label>
                                        </div>

                                        <div class="agreement-group">
                                            <input type="checkbox" id="agree4" name="agree4">
                                            <label for="agree4">I agree to DailyFixer content guidelines and terms of
                                                service.</label>
                                        </div>

                                        <div id="step4Error" class="error-text"
                                            style="text-align:center;margin-bottom:10px;"></div>

                                        <div class="btn-row">
                                            <button type="button" class="btn-secondary" onclick="prevStep(4)">←
                                                Back</button>
                                            <button type="submit" class="btn-primary" style="width: 100%;">Submit
                                                Application</button>
                                        </div>
                                    </div>
                                </form>

                                <p class="login-link">Already have an account? <a href="login.jsp">Login here</a></p>
                </div>
            </div>

            <script>
                let currentStep = 1;
                const totalSteps = 4;
                let proofCount = 1;

                function updateStepIndicator() {
                    for (let i = 1; i <= totalSteps; i++) {
                        const circle = document.getElementById('stepCircle' + i);
                        circle.classList.remove('active', 'completed');
                        if (i < currentStep) circle.classList.add('completed');
                        else if (i === currentStep) circle.classList.add('active');

                        if (i < totalSteps) {
                            const line = document.getElementById('stepLine' + i);
                            line.classList.toggle('completed', i < currentStep);
                        }
                    }
                }

                function showStep(step) {
                    for (let i = 1; i <= totalSteps; i++) {
                        document.getElementById('step' + i).classList.toggle('active', i === step);
                    }
                    currentStep = step;
                    updateStepIndicator();
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                }

                function nextStep(fromStep) {
                    const errorDiv = document.getElementById('step' + fromStep + 'Error');
                    errorDiv.innerHTML = '';

                    if (fromStep === 1) {
                        document.querySelectorAll('#step1 .error-text').forEach(el => el.textContent = '');
                        let hasError = false;
                        const f = id => document.getElementById(id).value.trim();

                        if (!f('fullName')) { document.getElementById('fullNameError').textContent = 'Full name required'; hasError = true; }
                        if (!f('username')) { document.getElementById('usernameError').textContent = 'Username required'; hasError = true; }
                        if (!f('email')) { document.getElementById('emailError').textContent = 'Email required'; hasError = true; }
                        else {
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailRegex.test(f('email'))) { document.getElementById('emailError').textContent = 'Invalid email format'; hasError = true; }
                        }
                        if (f('password').length < 6) { document.getElementById('passwordError').textContent = 'Min 6 characters'; hasError = true; }
                        if (f('password') !== f('confirmPassword')) { document.getElementById('confirmPasswordError').textContent = 'Passwords do not match'; hasError = true; }
                        if (!f('city')) { document.getElementById('cityError').textContent = 'City required'; hasError = true; }

                        const phoneVal = f('phone').replace(/\D/g, '');
                        if (!phoneVal) { document.getElementById('phoneError').textContent = 'Phone number required'; hasError = true; }
                        else if (phoneVal.length !== 10) { document.getElementById('phoneError').textContent = 'Phone must be exactly 10 digits'; hasError = true; }

                        if (hasError) return;
                    }

                    if (fromStep === 2) {
                        const expertiseChecked = document.querySelectorAll('input[name="expertise"]:checked');
                        const expertiseOther = document.getElementById('expertiseOther').value.trim();
                        if (expertiseChecked.length === 0 && !expertiseOther) {
                            errorDiv.innerHTML = 'Please select at least one area of expertise.';
                            return;
                        }
                        const skillLevel = document.querySelector('input[name="skillLevel"]:checked');
                        if (!skillLevel) { errorDiv.innerHTML = 'Please select your skill level.'; return; }
                        const experienceYears = document.querySelector('input[name="experienceYears"]:checked');
                        if (!experienceYears) { errorDiv.innerHTML = 'Please select your years of experience.'; return; }
                        const bio = document.getElementById('bio').value.trim();
                        if (!bio) { errorDiv.innerHTML = 'Please write a short bio.'; return; }
                    }

                    showStep(fromStep + 1);
                }

                function prevStep(fromStep) {
                    showStep(fromStep - 1);
                }

                function addProofBlock() {
                    if (proofCount >= 5) return;
                    const container = document.getElementById('proofsContainer');
                    const i = proofCount;

                    const block = document.createElement('div');
                    block.className = 'proof-block';
                    block.id = 'proofBlock_' + i;
                    block.innerHTML = //this is the start of the inner html
                        `<div class="proof-header">
                            <span class="proof-number">Proof #` + (i + 1) + `</span>
                            <button type="button" class="btn-remove-proof" onclick="removeProofBlock(` + i + `)">✕ Remove</button>
                        </div>
                        <div class="form-group">
                            <label>Proof Type</label>
                            <select name="proofType_` + i + `" class="filter-select" style="width:100%">
                                <option value="">Select type...</option>
                                <option value="Educational Certificate">Educational Certificate</option>
                                <option value="Technical Certification">Technical Certification</option>
                                <option value="Trade License">Trade License</option>
                                <option value="Workshop Training Certificate">Workshop Training Certificate</option>
                                <option value="Work Experience Letter">Work Experience Letter</option>
                                <option value="Portfolio Screenshot">Portfolio Screenshot</option>
                                <option value="Previous Published Guide">Previous Published Guide</option>
                                <option value="Professional ID">Professional ID</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="file-upload-area" onclick="document.getElementById('proofImage_` + i + `').click()">
                                <div class="upload-icon"><i class="ph ph-images-square"></i></div>
                                <div class="upload-text">Click to upload image</div>
                                <div class="upload-hint">JPG, PNG — Max 2MB</div>
                            </div>
                            <input type="file" id="proofImage_` + i + `" name="proofImage_` + i + `" accept="image/jpeg,image/png"
                                   style="display:none" onchange="showFileName(this, 'proofPreview_` + i + `')">
                            <div id="proofPreview_` + i + `" class="file-preview"></div>
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <input type="text" name="proofDesc_` + i + `" placeholder="Brief description of this proof">
                        </div>`;//this is the end of the inner html
                    container.appendChild(block);
                    proofCount++;

                    if (proofCount >= 5) document.getElementById('addProofBtn').style.display = 'none';
                }

                function removeProofBlock(index) {
                    const block = document.getElementById('proofBlock_' + index);
                    if (block) block.remove();
                    proofCount--;
                    if (proofCount < 5) document.getElementById('addProofBtn').style.display = 'inline-block';
                }

                function showFileName(input, previewId) {
                    const preview = document.getElementById(previewId);
                    if (input.files && input.files[0]) {
                        preview.textContent = '✓ ' + input.files[0].name;
                    } else {
                        preview.textContent = '';
                    }
                }

                // Final submit validation
                document.getElementById('registerForm').addEventListener('submit', function (e) {
                    const errorDiv = document.getElementById('step4Error');
                    errorDiv.innerHTML = '';

                    const agree1 = document.getElementById('agree1').checked;
                    const agree2 = document.getElementById('agree2').checked;
                    const agree3 = document.getElementById('agree3').checked;
                    const agree4 = document.getElementById('agree4').checked;

                    if (!agree1 || !agree2 || !agree3 || !agree4) {
                        errorDiv.innerHTML = 'You must agree to all declarations before submitting.';
                        e.preventDefault();
                    }
                });
            </script>
            <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

        </body>

        </html>