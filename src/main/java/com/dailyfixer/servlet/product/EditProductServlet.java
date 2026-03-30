package com.dailyfixer.servlet.product;

import java.io.*;
import java.math.BigDecimal;

import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.dao.ProductVariantDAO;
import com.dailyfixer.model.Product;
import com.dailyfixer.model.ProductVariant;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig
public class EditProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("productId"));
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
            Part filePart = request.getPart("image");
            byte[] image = null;
            if(filePart != null && filePart.getSize() > 0) {
                image = filePart.getInputStream().readAllBytes();
            } else {
                image = new ProductDAO().getProductById(id).getImage();
            }

            Product p = new Product();
            p.setProductId(id);
            p.setName(name);
            p.setType(type);
            p.setQuantity(quantity);
            p.setQuantityUnit(quantityUnit);
            p.setPrice(price);
            p.setImage(image);
            p.setDescription(description);

            // Handle variants first to determine if product has variants
            String[] variantIds = request.getParameterValues("variantId[]");
            String[] variantColors = request.getParameterValues("variantColor[]");
            String[] variantSizes = request.getParameterValues("variantSize[]");
            String[] variantPowers = request.getParameterValues("variantPower[]");
            String[] variantPrices = request.getParameterValues("variantPrice[]");
            String[] variantQuantities = request.getParameterValues("variantQuantity[]");

            boolean hasVariants = false;
            if (variantIds != null && variantIds.length > 0) {
                ProductVariantDAO variantDAO = new ProductVariantDAO();
                
                for (int i = 0; i < variantIds.length; i++) {
                    String variantIdStr = variantIds[i];
                    String color = (variantColors != null && i < variantColors.length) ? 
                                   (variantColors[i] != null ? variantColors[i].trim() : "") : "";
                    String size = (variantSizes != null && i < variantSizes.length) ? 
                                  (variantSizes[i] != null ? variantSizes[i].trim() : "") : "";
                    String power = (variantPowers != null && i < variantPowers.length) ? 
                                   (variantPowers[i] != null ? variantPowers[i].trim() : "") : "";
                    String priceStr = (variantPrices != null && i < variantPrices.length) ? 
                                      variantPrices[i] : "";
                    String qtyStr = (variantQuantities != null && i < variantQuantities.length) ? 
                                   variantQuantities[i] : "";

                    boolean isEmpty = color.isEmpty() && size.isEmpty() && power.isEmpty() && 
                                     (priceStr == null || priceStr.trim().isEmpty()) && 
                                     (qtyStr == null || qtyStr.trim().isEmpty());

                    // If variantId exists, it's an existing variant
                    if (variantIdStr != null && !variantIdStr.trim().isEmpty()) {
                        try {
                            int variantId = Integer.parseInt(variantIdStr);
                            if (isEmpty) {
                                // Delete variant if all fields are empty
                                variantDAO.deleteVariant(variantId);
                            } else {
                                // Update existing variant
                                if (priceStr != null && !priceStr.trim().isEmpty() && 
                                    qtyStr != null && !qtyStr.trim().isEmpty()) {
                                    hasVariants = true;
                                    ProductVariant variant = new ProductVariant();
                                    variant.setVariantId(variantId);
                                    variant.setProductId(id);
                                    variant.setColor(color.isEmpty() ? null : color);
                                    variant.setSize(size.isEmpty() ? null : size);
                                    variant.setPower(power.isEmpty() ? null : power);
                                    variant.setPrice(new BigDecimal(priceStr));
                                    variant.setQuantity(Integer.parseInt(qtyStr));
                                    variantDAO.updateVariant(variant);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    } else {
                        // New variant (no variantId)
                        if (!isEmpty && priceStr != null && !priceStr.trim().isEmpty() && 
                            qtyStr != null && !qtyStr.trim().isEmpty()) {
                            try {
                                hasVariants = true;
                                ProductVariant variant = new ProductVariant();
                                variant.setProductId(id);
                                variant.setColor(color.isEmpty() ? null : color);
                                variant.setSize(size.isEmpty() ? null : size);
                                variant.setPower(power.isEmpty() ? null : power);
                                variant.setPrice(new BigDecimal(priceStr));
                                variant.setQuantity(Integer.parseInt(qtyStr));
                                variantDAO.addVariant(variant);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }
            
            // If variants exist, set main product quantity to 0 (variants have their own quantities)
            if (hasVariants) {
                quantity = 0;
            }
            
            // Update product with correct quantity
            p.setQuantity(quantity);
            new ProductDAO().updateProduct(p);

            response.sendRedirect(request.getContextPath() + "/ListProductsServlet?updated=success");
        } catch (Exception e) { 
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ListProductsServlet?updated=error");
        }
    }
}
