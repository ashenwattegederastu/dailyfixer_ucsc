package com.dailyfixer.model;

import java.util.Base64;

public class Product {
    private int productId;
    private String name;
    private String type;
    private int quantity;
    private String quantityUnit;
    private double price;
    private byte[] image;
    private String storeUsername;
    private String description;
    private int storeId;

    // Getters and Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getQuantityUnit() {
        return quantityUnit;
    }

    public void setQuantityUnit(String quantityUnit) {
        this.quantityUnit = quantityUnit;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public String getStoreUsername() {
        return storeUsername;
    }

    public void setStoreUsername(String storeUsername) {
        this.storeUsername = storeUsername;
    }

    public String getImageBase64() {
        if (image != null && image.length > 0) {
            return Base64.getEncoder().encodeToString(image);
        }
        return "";
    }

    // Alias for JSP EL ${product.base64Image}
    public String getBase64Image() {
        return getImageBase64();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    // Transient fields for variable products (not in products table)
    private boolean hasVariants;
    private double minPrice;
    private double maxPrice;
    private int variantQuantity;

    public boolean isHasVariants() {
        return hasVariants;
    }

    public void setHasVariants(boolean hasVariants) {
        this.hasVariants = hasVariants;
    }

    public double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }

    public double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public int getVariantQuantity() {
        return variantQuantity;
    }

    public void setVariantQuantity(int variantQuantity) {
        this.variantQuantity = variantQuantity;
    }
}
