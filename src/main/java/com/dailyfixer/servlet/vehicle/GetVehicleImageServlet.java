package com.dailyfixer.servlet.vehicle;

import com.dailyfixer.dao.VehicleDAO;
import com.dailyfixer.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/GetVehicleImageServlet")
public class GetVehicleImageServlet extends HttpServlet {

    private VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing vehicle id");
            return;
        }

        try {
            int vehicleId = Integer.parseInt(idStr);
            Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId); // You'll need this method in DAO

            if (vehicle != null && vehicle.getPicture() != null) {
                response.setContentType("image/jpeg"); // Or dynamically detect type
                try (OutputStream out = response.getOutputStream()) {
                    out.write(vehicle.getPicture());
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }
}
