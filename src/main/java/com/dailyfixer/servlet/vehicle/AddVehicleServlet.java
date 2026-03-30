package com.dailyfixer.servlet.vehicle;

import com.dailyfixer.dao.VehicleDAO;
import com.dailyfixer.model.User;
import com.dailyfixer.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@WebServlet("/AddVehicleServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB max
public class AddVehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("currentUser");

        try {
            // Read text fields from the multipart form
            String vehicleType = getValue(request.getPart("vehicleType"));
            String brand = getValue(request.getPart("brand"));
            String model = getValue(request.getPart("model"));
            String plateNumber = getValue(request.getPart("plateNumber"));
            String vehicleCategory = getValue(request.getPart("vehicleCategory"));

            // Read picture
            Part picturePart = request.getPart("picture");
            byte[] picture = null;
            if (picturePart != null && picturePart.getSize() > 0) {
                try (InputStream is = picturePart.getInputStream()) {
                    picture = is.readAllBytes();
                }
            }

            Vehicle vehicle = new Vehicle();
            vehicle.setDriverId(user.getUserId());
            vehicle.setVehicleType(vehicleType);
            vehicle.setBrand(brand);
            vehicle.setModel(model);
            vehicle.setPlateNumber(plateNumber);
            vehicle.setPicture(picture);
            vehicle.setVehicleCategory(vehicleCategory);

            boolean added = vehicleDAO.addVehicle(vehicle);
            if (added) {
                response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
            } else {
                request.setAttribute("error", "Failed to add vehicle.");
                request.getRequestDispatcher("/pages/dashboards/driverdash/vehicleManagement.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error: " + e.getMessage());
            request.getRequestDispatcher("/pages/dashboards/driverdash/vehicleManagement.jsp").forward(request, response);
        }
    }

    // Helper method to read string from Part
    private String getValue(Part part) throws IOException {
        if (part == null) return null;
        try (InputStream is = part.getInputStream()) {
            return new String(is.readAllBytes()).trim();
        }
    }
}
