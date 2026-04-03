package com.dailyfixer.servlet.auth;

import com.dailyfixer.model.User;
import com.dailyfixer.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/registerTechnician")
public class RegisterTechnicianServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Hash password using SHA-256
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String city = request.getParameter("city");
        String phone = request.getParameter("phone");

        String errorMsg = null;

        if (firstName.isEmpty() || lastName.isEmpty() || username.isEmpty() ||
                email.isEmpty() || password.isEmpty() || city.isEmpty()) {
            errorMsg = "Please fill all required fields.";
        }

        if (errorMsg != null) {
            request.setAttribute("errorMsg", errorMsg);
            request.getRequestDispatcher("/pages/authentication/register/registerTechnician.jsp").forward(request, response);
            return;
        }

        try {
            // Hash the password
            String hashedPassword = hashPassword(password);

            // Insert into users table
            String sql = "INSERT INTO users(first_name, last_name, username, email, password, phone_number, city, role, status) " +
                    "VALUES(?,?,?,?,?,?,?,?,?)";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, username);
                stmt.setString(4, email);
                stmt.setString(5, hashedPassword);
                stmt.setString(6, phone);
                stmt.setString(7, city);
                stmt.setString(8, "technician"); // role
                stmt.setString(9, "active"); // status

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    // Success: redirect to login page
                    response.sendRedirect(request.getContextPath() + "/pages/authentication/login.jsp");
                } else {
                    errorMsg = "Registration failed. Please try again.";
                    request.setAttribute("errorMsg", errorMsg);
                    request.getRequestDispatcher("/pages/authentication/register/registerTechnician.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "Error: " + e.getMessage();
            request.setAttribute("errorMsg", errorMsg);
            request.getRequestDispatcher("/pages/authentication/register/registerTechnician.jsp").forward(request, response);
        }
    }
}
