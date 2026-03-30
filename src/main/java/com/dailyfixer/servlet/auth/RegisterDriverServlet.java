package com.dailyfixer.servlet.auth;

import com.dailyfixer.util.HashUtil;
import com.dailyfixer.util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/RegisterDriverServlet")
public class RegisterDriverServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone_number");
        String city = request.getParameter("city");

        // ✅ Use same hashing method as RegisterUserServlet
        String hashedPassword = HashUtil.sha256(password);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (first_name, last_name, username, email, password, phone_number, city, role) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, 'driver')";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, username);
            stmt.setString(4, email);
            stmt.setString(5, hashedPassword);
            stmt.setString(6, phone);
            stmt.setString(7, city);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("login.jsp?msg=Driver+account+created+successfully");
            } else {
                response.sendRedirect("registerDriver.jsp?error=Signup+failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registerDriver.jsp?error=Database+error");
        }
    }
}
