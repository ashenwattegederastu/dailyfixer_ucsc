package com.dailyfixer.servlet.product;

import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.model.Product;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class CategoryProductServlet extends HttpServlet {

    private static final String SESSION_USER_LAT = "userLat";
    private static final String SESSION_USER_LNG = "userLng";

    private static Double tryParseDouble(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String clearLocation = request.getParameter("clearLocation");
        Double lat = tryParseDouble(request.getParameter("lat"));
        Double lng = tryParseDouble(request.getParameter("lng"));

        HttpSession session = request.getSession();
        if ("true".equalsIgnoreCase(clearLocation)) {
            session.removeAttribute(SESSION_USER_LAT);
            session.removeAttribute(SESSION_USER_LNG);
        } else if (lat != null && lng != null) {
            session.setAttribute(SESSION_USER_LAT, lat);
            session.setAttribute(SESSION_USER_LNG, lng);
        }

        try {
            List<Product> products =
                    new ProductDAO().getProductsByCategory(category);



            request.setAttribute("products", products);
            request.setAttribute("category", category);

            request.getRequestDispatcher("/pages/stores/category_products.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
