<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.dao.ProductDAO" %>
<%@ page import="com.dailyfixer.dao.ProductVariantDAO" %>
<%@ page import="com.dailyfixer.model.Product" %>
<%@ page import="com.dailyfixer.model.ProductVariant" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"store".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    int id = Integer.parseInt(request.getParameter("productId"));
    Product product = new ProductDAO().getProductById(id);
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/ListProductsServlet");
        return;
    }
    
    // Load existing variants
    List<ProductVariant> variants = null;
    try {
        ProductVariantDAO variantDAO = new ProductVariantDAO();
        variants = variantDAO.getVariantsByProductId(id);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product | Daily Fixer</title>
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
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up for Delivery</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed Orders</a></li>
            <li><a href="${pageContext.request.contextPath}/ListProductsServlet">Catalogue</a></li>
            <li><a href="${pageContext.request.contextPath}/ListDiscountsServlet">Discounts</a></li>
            <li><a href="${pageContext.request.contextPath}/StoreReviewsServlet">Customer Reviews</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/finances.jsp">Finances</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myStore.jsp">My Store</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
        </ul>
    </aside>

    <main class="container form-layout">
        <div class="form-card">
            <h2>Edit Product</h2>

            <form action="${pageContext.request.contextPath}/EditProductServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="productId" value="<%=product.getProductId()%>">

                <label>Product Name</label>
                <input type="text" name="name" value="<%=product.getName()%>" placeholder="Enter product name" required>

                <label>Category</label>
                <select name="type" required>
                    <option value="Cutting Tools" <%=product.getType().equals("Cutting Tools")?"selected":""%>>Cutting Tools</option>
                    <option value="Painting Tools" <%=product.getType().equals("Painting Tools")?"selected":""%>>Painting Tools</option>
                    <option value="Tool Storage & Safety Gear" <%=product.getType().equals("Tool Storage & Safety Gear")?"selected":""%>>Tool Storage & Safety Gear</option>
                    <option value="Electrical Tools & Accessories" <%=product.getType().equals("Electrical Tools & Accessories")?"selected":""%>>Electrical Tools & Accessories</option>
                    <option value="Power Tools" <%=product.getType().equals("Power Tools")?"selected":""%>>Power Tools</option>
                    <option value="Cleaning & Maintenance" <%=product.getType().equals("Cleaning & Maintenance")?"selected":""%>>Cleaning & Maintenance</option>
                    <option value="Vehicle Parts & Accessories" <%=product.getType().equals("Vehicle Parts & Accessories")?"selected":""%>>Vehicle Parts & Accessories</option>
                    <option value="Measuring & Marking Tools" <%=product.getType().equals("Measuring & Marking Tools")?"selected":""%>>Measuring & Marking Tools</option>
                    <option value="Tapes" <%=product.getType().equals("Tapes")?"selected":""%>>Tapes</option>
                    <option value="Fasteners & Fittings" <%=product.getType().equals("Fasteners & Fittings")?"selected":""%>>Fasteners & Fittings</option>
                    <option value="Plumbing Tools & Supplies" <%=product.getType().equals("Plumbing Tools & Supplies")?"selected":""%>>Plumbing Tools & Supplies</option>
                    <option value="Adhesives & Sealants" <%=product.getType().equals("Adhesives & Sealants")?"selected":""%>>Adhesives & Sealants</option>
                </select>

                <label>Quantity <span id="quantityNote" class="form-help">(<%= (variants != null && !variants.isEmpty()) ? "Not required - variants have their own quantities" : "Required if no variants" %>)</span></label>
                <input type="number" step="0.01" name="quantity" id="quantityInput" value="<%=product.getQuantity()%>" placeholder="Enter quantity" <%=(variants==null || variants.isEmpty()) ? "required" : "" %>>

                <label>Quantity Unit</label>
                <select name="quantityUnit" required>
                    <option value="No of items" <%=product.getQuantityUnit().equals("No of items")?"selected":""%>>No of items</option>
                    <option value="Litres" <%=product.getQuantityUnit().equals("Litres")?"selected":""%>>Litres</option>
                    <option value="Kg" <%=product.getQuantityUnit().equals("Kg")?"selected":""%>>Kg</option>
                    <option value="Metres" <%=product.getQuantityUnit().equals("Metres")?"selected":""%>>Metres</option>
                </select>

                <label>Price (Rs.) <span id="priceNote" class="form-help"></span></label>
                <input type="number" step="0.01" name="price" value="<%=product.getPrice()%>" placeholder="Enter price" required>

                <label>Description</label>
                <textarea name="description" rows="4" placeholder="Enter product description" required><%=product.getDescription()%></textarea>

                <label>Product Image</label>
                <input type="file" name="image" accept="image/*">

                <!-- Product Variants Section -->
                <div class="variants-section">
                    <h3>Product Variants</h3>
                    <p class="help-text">Manage product variants (color, size, power). Leave empty to remove a variant.</p>

                    <div id="variantsContainer">
                        <% if (variants != null && !variants.isEmpty()) { 
                            for (ProductVariant v : variants) { %>
                            <div class="variant-row">
                                <input type="hidden" name="variantId[]" value="<%=v.getVariantId()%>">
                                <div class="variant-grid">
                                    <div>
                                        <label>Color</label>
                                        <input type="text" name="variantColor[]" value="<%=v.getColor() != null ? v.getColor() : ""%>" placeholder="e.g. Red">
                                    </div>
                                    <div>
                                        <label>Size</label>
                                        <input type="text" name="variantSize[]" value="<%=v.getSize() != null ? v.getSize() : ""%>" placeholder="e.g. M">
                                    </div>
                                </div>
                                <div class="variant-grid">
                                    <div>
                                        <label>Power</label>
                                        <input type="text" name="variantPower[]" value="<%=v.getPower() != null ? v.getPower() : ""%>" placeholder="e.g. 500W">
                                    </div>
                                    <div>
                                        <label>Variant Price (Rs.)</label>
                                        <input type="number" step="0.01" name="variantPrice[]" value="<%=v.getPrice()%>" placeholder="Price">
                                    </div>
                                </div>
                                <div>
                                    <label>Variant Stock</label>
                                    <input type="number" name="variantQuantity[]" value="<%=v.getQuantity()%>" placeholder="Stock quantity">
                                </div>
                                <button type="button" class="remove-variant-btn" onclick="removeVariantRow(this)">Remove</button>
                            </div>
                        <% } } else { %>
                            <!-- Empty variant row if no variants exist -->
                            <div class="variant-row">
                                <input type="hidden" name="variantId[]" value="">
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
                        <% } %>
                    </div>

                    <button type="button" class="add-variant-btn" onclick="addVariantRow()">+ Add Variant</button>
                </div>

                <button type="submit">Update Product</button>
            </form>

            <a href="${pageContext.request.contextPath}/ListProductsServlet" class="back-btn">Back to Products</a>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/storedash-product-variants.js"></script>
</body>
</html>