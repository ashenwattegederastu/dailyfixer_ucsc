<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.dailyfixer.model.User" %>
        <% User user=(User) session.getAttribute("currentUser"); if (user==null || !"store".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Add Product | Daily Fixer</title>
                <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/storedash-forms.css">
            </head>

            <body class="dashboard-layout">

                <header class="topbar">
                    <div class="logo">Daily Fixer</div>
                    <div class="panel-name">Store Panel</div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
                    </div>
                </header>

                <aside class="sidebar">
                    <h3>Navigation</h3>
                    <ul>
                        <li><a
                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a>
                        </li>
                        <li><a
                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up
                                for Delivery</a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed
                                Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/ListProductsServlet">Catalogue</a></li>
                        <li><a href="${pageContext.request.contextPath}/ListDiscountsServlet">Discounts</a></li>
                        <li><a href="${pageContext.request.contextPath}/StoreReviewsServlet">Customer Reviews</a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/finances.jsp">Finances</a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myStore.jsp">My Store</a></li>
                        <li><a
                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a>
                        </li>
                    </ul>
                </aside>

                <main class="container form-layout">
                    <div class="form-card">
                        <h2>Add Product</h2>

                        <form action="${pageContext.request.contextPath}/AddProductServlet" method="post"
                            enctype="multipart/form-data">

                            <label for="name">Product Name</label>
                            <input type="text" name="name" placeholder="Enter product name" required>

                            <label for="type">Category</label>
                            <select name="type" required>
                                <option value="">-- Select Category --</option>
                                <option value="Cutting Tools">Cutting Tools</option>
                                <option value="Painting Tools">Painting Tools</option>
                                <option value="Tool Storage & Safety Gear">Tool Storage & Safety Gear</option>
                                <option value="Electrical Tools & Accessories">Electrical Tools & Accessories</option>
                                <option value="Power Tools">Power Tools</option>
                                <option value="Cleaning & Maintenance">Cleaning & Maintenance</option>
                                <option value="Vehicle Parts & Accessories">Vehicle Parts & Accessories</option>
                                <option value="Measuring & Marking Tools">Measuring & Marking Tools</option>
                                <option value="Tapes">Tapes</option>
                                <option value="Fasteners & Fittings">Fasteners & Fittings</option>
                                <option value="Plumbing Tools & Supplies">Plumbing Tools & Supplies</option>
                                <option value="Adhesives & Sealants">Adhesives & Sealants</option>
                            </select>

                            <label for="quantity">Quantity <span id="quantityNote"
                                    class="form-help">(Required if no
                                    variants)</span></label>
                            <input type="number" step="0.01" name="quantity" id="quantityInput"
                                placeholder="Enter quantity" value="0">

                            <label for="quantityUnit">Unit</label>
                            <select name="quantityUnit" required>
                                <option value="No of items">No of items</option>
                                <option value="Litres">Litres</option>
                                <option value="Kg">Kg</option>
                                <option value="Metres">Metres</option>
                            </select>

                            <label for="price">Price (Rs.) <span id="priceNote"
                                    class="form-help"></span></label>
                            <input type="number" step="0.01" name="price" placeholder="Enter price" required>

                            <label for="description">Description</label>
                            <textarea name="description" id="description" rows="4"
                                placeholder="Enter product description" required></textarea>


                            <label for="image">Product Image</label>
                            <input type="file" name="image" accept="image/*" required>

                            <!-- Product Variants Section -->
                            <div class="variants-section">
                                <h3>Product Variants (Optional)</h3>
                                <p class="help-text">If your product has different options (color, size, power), add variants below. Leave empty if product has no variants.</p>
                                <div id="variantsContainer">
                                    <div class="variant-row">
                                        <div class="variant-grid">
                                            <div>
                                                <label>Color</label>
                                                <input type="text" name="variantColor[]" placeholder="e.g. Red">
                                            </div>
                                            <div>
                                                <label>Size</label>
                                                <input type="text" name="variantSize[]" placeholder="e.g. M">
                                            </div>
                                        </div>
                                        <div class="variant-grid">
                                            <div>
                                                <label>Power</label>
                                                <input type="text" name="variantPower[]" placeholder="e.g. 500W">
                                            </div>
                                            <div>
                                                <label>Variant Price (Rs.)</label>
                                                <input type="number" step="0.01" name="variantPrice[]" placeholder="Price">
                                            </div>
                                        </div>
                                        <div>
                                            <label>Variant Stock</label>
                                            <input type="number" name="variantQuantity[]" placeholder="Stock quantity">
                                        </div>
                                        <button type="button" class="remove-variant-btn" onclick="removeVariantRow(this)">Remove</button>
                                    </div>
                                </div>
                                <button type="button" class="add-variant-btn" onclick="addVariantRow()">+ Add Variant</button>
                            </div>

                            <button type="submit">Add Product</button>
                        </form>

                        <a href="${pageContext.request.contextPath}/ListProductsServlet" class="back-btn">Back to
                            Products</a>
                    </div>
                </main>

                <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/storedash-product-variants.js"></script>
            </body>

            </html>