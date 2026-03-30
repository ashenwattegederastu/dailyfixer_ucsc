package com.dailyfixer.servlet.vehicle;

import com.dailyfixer.dao.VehicleDAO;
import com.dailyfixer.model.User;
import com.dailyfixer.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;

@WebServlet("/EditVehicleServlet")
@MultipartConfig(maxFileSize = 16177215) // max 16MB
public class EditVehicleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("currentUser");

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
                return;
            }

            int id = Integer.parseInt(idParam);

            String vehicleType = request.getParameter("vehicleType");
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String plateNumber = request.getParameter("plateNumber");
            String vehicleCategory = request.getParameter("vehicleCategory");

            Part picturePart = request.getPart("picture"); // may be null or empty

            VehicleDAO dao = new VehicleDAO();
            Vehicle vehicle = dao.getVehicleById(id);

            if (vehicle == null || vehicle.getDriverId() != user.getUserId()) {
                // Vehicle not found or doesn't belong to logged-in driver
                response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
                return;
            }

            vehicle.setVehicleType(vehicleType);
            vehicle.setBrand(brand);
            vehicle.setModel(model);
            vehicle.setPlateNumber(plateNumber);
            vehicle.setVehicleCategory(vehicleCategory);

            // Only update picture if a new file was uploaded
            if (picturePart != null && picturePart.getSize() > 0) {
                InputStream inputStream = picturePart.getInputStream();
                byte[] pictureBytes = inputStream.readAllBytes();
                vehicle.setPicture(pictureBytes);
            }

            boolean updated = dao.updateVehicle(vehicle);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
            } else {
                response.getWriter().println("Failed to update vehicle.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
