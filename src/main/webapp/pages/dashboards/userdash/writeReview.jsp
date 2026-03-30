<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ page import="com.dailyfixer.model.User" %>

            <% User com.dailyfixer.user=(User) session.getAttribute("currentUser"); if (user==null ||
                user.getRole()==null || !"user".equalsIgnoreCase(user.getRole().trim())) {
                response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp" ); return; } %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <%@ page contentType="text/html;charset=UTF-8" %>
                        <%@ taglib uri="jakarta.tags.core" prefix="c" %>
                            <%@ page import="com.dailyfixer.model.User" %>

                                <% User com.dailyfixer.user=(User) session.getAttribute("currentUser"); if (user==null
                                    || user.getRole()==null || !"user".equalsIgnoreCase(user.getRole().trim())) {
                                    response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp" );
                                    return; } %>

                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Write Review | Daily Fixer</title>
                                        <link
                                            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                            rel="stylesheet">


                                        <link rel="stylesheet"
                                            href="${pageContext.request.contextPath}/assets/css/framework.css">
                                        <jsp:include page="sidebar.jsp" />

                                        <main class="dashboard-container">
                                            <h2>Write Review</h2>

                                            <!-- Product Information -->
                                            <div class="product-card">
                                                <img src="${pageContext.request.contextPath}/assets/images/hammer.png"
                                                    alt="Heavy Duty Hammer" class="product-image">
                                                <div class="product-info">
                                                    <h3>Heavy Duty Hammer</h3>
                                                    <p><strong>Category:</strong> Tools</p>
                                                    <p><strong>Order #:</strong> 12345</p>
                                                    <p class="price">$25.00</p>
                                                </div>
                                            </div>

                                            <!-- Review Guidelines -->
                                            <div class="guidelines">
                                                <h5>Review Guidelines</h5>
                                                <ul>
                                                    <li>Be honest and constructive in your feedback</li>
                                                    <li>Focus on the product quality and your experience</li>
                                                    <li>Avoid personal attacks or inappropriate language</li>
                                                    <li>Your review will help other customers make informed decisions
                                                    </li>
                                                </ul>
                                            </div>

                                            <!-- Review Form -->
                                            <form class="review-form"
                                                action="${pageContext.request.contextPath}/submitReview" method="post">
                                                <h4>Share Your Experience</h4>

                                                <div class="form-group">
                                                    <label for="rating">Overall Rating</label>
                                                    <div class="rating-input">
                                                        <input type="number" id="rating" name="rating" min="1" max="5"
                                                            value="5" required>
                                                        <span>out of 5 stars</span>
                                                        <div class="star-display" id="starDisplay">
                                                            <span class="star">★</span>
                                                            <span class="star">★</span>
                                                            <span class="star">★</span>
                                                            <span class="star">★</span>
                                                            <span class="star">★</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label for="comment">Your Review</label>
                                                    <textarea id="comment" name="comment"
                                                        placeholder="Tell us about your experience with this product. What did you like? What could be improved?"
                                                        required></textarea>
                                                </div>

                                                <div class="form-actions">
                                                    <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myPurchases.jsp"
                                                        class="btn btn-cancel">Cancel</a>
                                                    <button type="submit" class="btn btn-submit">Submit Review</button>
                                                </div>
                                            </form>
                                        </main>

                                        <script>
                                            // Star rating interaction
                                            const ratingInput = document.getElementById('rating');
                                            const starDisplay = document.getElementById('starDisplay');
                                            const stars = starDisplay.querySelectorAll('.star');

                                            function updateStars(rating) {
                                                stars.forEach((star, index) => {
                                                    if (index < rating) {
                                                        star.textContent = '★';
                                                        star.style.color = '#fbbf24';
                                                    } else {
                                                        star.textContent = '☆';
                                                        star.style.color = '#d1d5db';
                                                    }
                                                });
                                            }

                                            // Update stars when input changes
                                            ratingInput.addEventListener('input', function () {
                                                updateStars(parseInt(this.value));
                                            });

                                            // Update input when stars are clicked
                                            stars.forEach((star, index) => {
                                                star.addEventListener('click', function () {
                                                    const rating = index + 1;
                                                    ratingInput.value = rating;
                                                    updateStars(rating);
                                                });
                                            });

                                            // Initialize stars
                                            updateStars(parseInt(ratingInput.value));
                                        </script>

                                        </body>

                                    </html>