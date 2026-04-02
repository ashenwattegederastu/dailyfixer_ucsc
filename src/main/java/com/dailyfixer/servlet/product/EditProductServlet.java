package com.dailyfixer.servlet.product;

import java.io.*;
import java.math.BigDecimal;

import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.dao.ProductVariantDAO;
import com.dailyfixer.model.Product;
import com.dailyfixer.model.ProductVariant;
import com.dailyfixer.util.ProductImageUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig(maxFileSize = 16177215) // 16 MB max
public class EditProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String webAppPath = getServletContext().getRealPath("/");
            ProductDAO productDAO = new ProductDAO();

            int id = Integer.parseInt(request.getParameter("productId"));

            // Resolve type — handle "Other" custom category
            String type = request.getParameter("type");
            if ("Other".equals(type)) {
                String custom = request.getParameter("customCategory");
                if (custom != null && !custom.trim().isEmpty()) type = custom.trim();
            }

            String name         = request.getParameter("name");
            String quantityStr  = request.getParameter("quantity");
            int quantity = 0;
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                try { quantity = Integer.parseInt(quantityStr); } catch (NumberFormatException ignored) {}
            }
            String quantityUnit = request.getParameter("quantityUnit");
            double price        = 0.0;
            String mainPriceStr = request.getParameter("price");
            if (mainPriceStr != null && !mainPriceStr.trim().isEmpty()) {
                try { price = Double.parseDouble(mainPriceStr); } catch (NumberFormatException ignored) {}
            }
            String description  = request.getParameter("description");
            String warrantyInfo = request.getParameter("warrantyInfo");

            // Resolve image path — keep existing if no new file uploaded
            Product existing   = productDAO.getProductById(id);
            String  imagePath  = existing.getImagePath();
            Part    filePart   = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                ProductImageUtil.deleteImage(imagePath, webAppPath);
                imagePath = ProductImageUtil.saveProductMainImage(filePart, id, webAppPath);
            }

            Product p = new Product();
            p.setProductId(id);
            p.setName(name);
            p.setType(type);
            p.setQuantity(quantity);
            p.setQuantityUnit(quantityUnit);
            p.setPrice(price);
            p.setImagePath(imagePath);
            p.setDescription(description);
            p.setWarrantyInfo((warrantyInfo != null && !warrantyInfo.isBlank()) ? warrantyInfo.trim() : null);
            p.setStoreUsername(existing.getStoreUsername());

            // Handle variants
            String[] variantIds        = request.getParameterValues("variantId[]");
            String[] variantColors     = request.getParameterValues("variantColor[]");
            String[] variantSizes      = request.getParameterValues("variantSize[]");
            String[] variantPowers     = request.getParameterValues("variantPower[]");
            String[] variantPrices     = request.getParameterValues("variantPrice[]");
            String[] variantQuantities = request.getParameterValues("variantQuantity[]");

            // Collect variant image parts (ordered by their position)
            Part[] variantImages = null;
            try {
                java.util.List<Part> imgParts = new java.util.ArrayList<>();
                for (Part part : request.getParts()) {
                    if ("variantImage[]".equals(part.getName())) imgParts.add(part);
                }
                variantImages = imgParts.toArray(new Part[0]);
            } catch (Exception ignored) {}

            boolean hasVariants = false;
            if (variantIds != null && variantIds.length > 0) {
                ProductVariantDAO variantDAO = new ProductVariantDAO();

                for (int i = 0; i < variantIds.length; i++) {
                    String variantIdStr = variantIds[i];
                    String color  = (variantColors    != null && i < variantColors.length)    ? variantColors[i].trim()    : "";
                    String size   = (variantSizes     != null && i < variantSizes.length)     ? variantSizes[i].trim()     : "";
                    String power  = (variantPowers    != null && i < variantPowers.length)    ? variantPowers[i].trim()    : "";
                    String pStr   = (variantPrices    != null && i < variantPrices.length)    ? variantPrices[i]           : "";
                    String qStr   = (variantQuantities != null && i < variantQuantities.length) ? variantQuantities[i]     : "";

                    boolean isEmpty = color.isEmpty() && size.isEmpty() && power.isEmpty() &&
                                      (pStr == null || pStr.trim().isEmpty()) &&
                                      (qStr == null || qStr.trim().isEmpty());

                    if (variantIdStr != null && !variantIdStr.trim().isEmpty()) {
                        // Existing variant
                        try {
                            int variantId = Integer.parseInt(variantIdStr);
                            if (isEmpty) {
                                // Delete variant and its image
                                ProductVariant old = variantDAO.getVariantById(variantId);
                                if (old != null) ProductImageUtil.deleteImage(old.getImagePath(), webAppPath);
                                variantDAO.deleteVariant(variantId);
                            } else if (pStr != null && !pStr.trim().isEmpty() && qStr != null && !qStr.trim().isEmpty()) {
                                hasVariants = true;
                                ProductVariant old = variantDAO.getVariantById(variantId);
                                String vImgPath = (old != null) ? old.getImagePath() : null;

                                // Save new variant image if provided
                                if (variantImages != null && i < variantImages.length && variantImages[i].getSize() > 0) {
                                    ProductImageUtil.deleteImage(vImgPath, webAppPath);
                                    vImgPath = ProductImageUtil.saveVariantImage(variantImages[i], variantId, webAppPath);
                                }

                                ProductVariant variant = new ProductVariant();
                                variant.setVariantId(variantId);
                                variant.setProductId(id);
                                variant.setColor(color.isEmpty() ? null : color);
                                variant.setSize(size.isEmpty()   ? null : size);
                                variant.setPower(power.isEmpty() ? null : power);
                                variant.setPrice(new BigDecimal(pStr.trim()));
                                variant.setQuantity(Integer.parseInt(qStr.trim()));
                                variant.setImagePath(vImgPath);
                                variantDAO.updateVariant(variant);
                            }
                        } catch (Exception e) { e.printStackTrace(); }
                    } else {
                        // New variant
                        if (!isEmpty && pStr != null && !pStr.trim().isEmpty() && qStr != null && !qStr.trim().isEmpty()) {
                            try {
                                hasVariants = true;
                                ProductVariant variant = new ProductVariant();
                                variant.setProductId(id);
                                variant.setColor(color.isEmpty() ? null : color);
                                variant.setSize(size.isEmpty()   ? null : size);
                                variant.setPower(power.isEmpty() ? null : power);
                                variant.setPrice(new BigDecimal(pStr.trim()));
                                variant.setQuantity(Integer.parseInt(qStr.trim()));

                                int newVId = variantDAO.addVariantAndReturnId(variant);
                                if (variantImages != null && i < variantImages.length && variantImages[i].getSize() > 0) {
                                    String vImgPath = ProductImageUtil.saveVariantImage(variantImages[i], newVId, webAppPath);
                                    variant.setVariantId(newVId);
                                    variant.setImagePath(vImgPath);
                                    variantDAO.updateVariant(variant);
                                }
                            } catch (Exception e) { e.printStackTrace(); }
                        }
                    }
                }
            }

            if (hasVariants) p.setQuantity(0);
            productDAO.updateProduct(p);

            response.sendRedirect(request.getContextPath() + "/ListProductsServlet?updated=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ListProductsServlet?updated=error");
        }
    }
}
