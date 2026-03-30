package com.dailyfixer.servlet.product;

import java.io.*;
import java.math.BigDecimal;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import com.dailyfixer.model.Product;
import com.dailyfixer.model.ProductVariant;
import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.dao.ProductVariantDAO;
import com.dailyfixer.model.User;

@MultipartConfig(maxFileSize = 16177215) // 16 MB max
public class AddProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get logged-in User object from session
        HttpSession session = request.getSession(false); // do not create new session
        if (session == null) {
            response.sendRedirect("../../login.jsp");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"store".equals(user.getRole())) {
            response.sendRedirect("../../login.jsp"); // only store users can add products
            return;
        }

        String storeUsername = user.getUsername(); // safe to use for DB

        // 2. Get form parameters
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        String quantityStr = request.getParameter("quantity");
        int quantity = 0;
        if (quantityStr != null && !quantityStr.trim().isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException e) {
                quantity = 0;
            }
        }
        String quantityUnit = request.getParameter("quantityUnit");
        double price = 0.0;
        String mainPriceStr = request.getParameter("price");
        if (mainPriceStr != null && !mainPriceStr.trim().isEmpty()) {
            price = Double.parseDouble(mainPriceStr);
        }
        String description = request.getParameter("description");

        // 3. Get uploaded image
        InputStream inputStream = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        try {
            // 4. Create Product object
            Product p = new Product();
            p.setName(name);
            p.setType(type);
            p.setQuantity(quantity);
            p.setQuantityUnit(quantityUnit);
            p.setPrice(price);
            p.setStoreUsername(storeUsername);
            p.setDescription(description);
            if (inputStream != null) p.setImage(inputStream.readAllBytes());

            // 5. Save to database and get product ID
            ProductDAO productDAO = new ProductDAO();
            int productId = productDAO.addProductAndReturnId(p);

            // 6. Handle variants if provided
            String[] variantColors = request.getParameterValues("variantColor[]");
            String[] variantSizes = request.getParameterValues("variantSize[]");
            String[] variantPowers = request.getParameterValues("variantPower[]");
            String[] variantPrices = request.getParameterValues("variantPrice[]");
            String[] variantQuantities = request.getParameterValues("variantQuantity[]");

            boolean hasVariants = false;
            if (variantColors != null && variantColors.length > 0) {
                ProductVariantDAO variantDAO = new ProductVariantDAO();
                for (int i = 0; i < variantColors.length; i++) {
                    // Skip empty rows (all fields empty)
                    String color = variantColors[i] != null ? variantColors[i].trim() : "";
                    String size = (variantSizes != null && i < variantSizes.length) ? 
                                  (variantSizes[i] != null ? variantSizes[i].trim() : "") : "";
                    String power = (variantPowers != null && i < variantPowers.length) ? 
                                   (variantPowers[i] != null ? variantPowers[i].trim() : "") : "";
                    String priceStr = (variantPrices != null && i < variantPrices.length) ? 
                                      variantPrices[i] : "";
                    String qtyStr = (variantQuantities != null && i < variantQuantities.length) ? 
                                    variantQuantities[i] : "";

                    // Skip if all fields are empty
                    if (color.isEmpty() && size.isEmpty() && power.isEmpty() && 
                        (priceStr == null || priceStr.trim().isEmpty()) && 
                        (qtyStr == null || qtyStr.trim().isEmpty())) {
                        continue;
                    }

                    // Validate required fields
                    if (priceStr == null || priceStr.trim().isEmpty() || 
                        qtyStr == null || qtyStr.trim().isEmpty()) {
                        continue; // Skip incomplete variants
                    }

                    try {
                        hasVariants = true;
                        ProductVariant variant = new ProductVariant();
                        variant.setProductId(productId);
                        variant.setColor(color.isEmpty() ? null : color);
                        variant.setSize(size.isEmpty() ? null : size);
                        variant.setPower(power.isEmpty() ? null : power);
                        variant.setPrice(new BigDecimal(priceStr));
                        variant.setQuantity(Integer.parseInt(qtyStr));
                        variantDAO.addVariant(variant);
                    } catch (Exception e) {
                        e.printStackTrace();
                        // Continue with other variants even if one fails
                    }
                }
            }
            
            // If variants were added, set main product quantity to 0 (variants have their own quantities)
            if (hasVariants) {
                Product updateProduct = new Product();
                updateProduct.setProductId(productId);
                updateProduct.setName(p.getName());
                updateProduct.setType(p.getType());
                updateProduct.setQuantity(0);
                updateProduct.setQuantityUnit(p.getQuantityUnit());
                updateProduct.setPrice(p.getPrice());
                updateProduct.setImage(p.getImage());
                updateProduct.setDescription(p.getDescription());
                productDAO.updateProduct(updateProduct);
            }

            // 7. Redirect to product list
            response.sendRedirect("ListProductsServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error adding product: " + e.getMessage());
        }
    }
}
