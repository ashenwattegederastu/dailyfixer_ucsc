package com.dailyfixer.dao;

import com.dailyfixer.model.Vehicle;
import com.dailyfixer.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    // Fetch all vehicles for a specific driver
    public List<Vehicle> getVehiclesByDriver(int driverId) {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicles WHERE driver_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, driverId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vehicle v = mapResultSetToVehicle(rs);
                    list.add(v);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching vehicles for driver " + driverId, e);
        }
        return list;
    }

    // Update a vehicle
    public boolean updateVehicle(Vehicle v) {
        String sql = "UPDATE vehicles SET vehicle_type=?, brand=?, model=?, plate_number=?, picture=?, vehicle_category=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, v.getVehicleType());
            stmt.setString(2, v.getBrand());
            stmt.setString(3, v.getModel());
            stmt.setString(4, v.getPlateNumber());
            stmt.setBytes(5, v.getPicture());
            stmt.setString(6, v.getVehicleCategory());
            stmt.setInt(7, v.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating vehicle with ID " + v.getId(), e);
        }
    }

    // Delete a vehicle
    public boolean deleteVehicle(int id) {
        String sql = "DELETE FROM vehicles WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting vehicle with ID " + id, e);
        }
    }


    // Fetch a single vehicle by its ID
    public Vehicle getVehicleById(int id) {
        String sql = "SELECT * FROM vehicles WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVehicle(rs);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching vehicle with ID " + id, e);
        }
        return null;
    }

    // Add a new vehicle
    public boolean addVehicle(Vehicle v) {
        String sql = "INSERT INTO vehicles(driver_id, vehicle_type, brand, model, plate_number, picture, vehicle_category) VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, v.getDriverId());
            stmt.setString(2, v.getVehicleType());
            stmt.setString(3, v.getBrand());
            stmt.setString(4, v.getModel());
            stmt.setString(5, v.getPlateNumber());
            stmt.setBytes(6, v.getPicture());
            stmt.setString(7, v.getVehicleCategory());

            return stmt.executeUpdate() > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding vehicle for driver " + v.getDriverId(), e);
        }
    }

    // Utility method to map a ResultSet row to a Vehicle object
    private Vehicle mapResultSetToVehicle(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setId(rs.getInt("id"));
        v.setDriverId(rs.getInt("driver_id"));
        v.setVehicleType(rs.getString("vehicle_type"));
        v.setBrand(rs.getString("brand"));
        v.setModel(rs.getString("model"));
        v.setPlateNumber(rs.getString("plate_number"));
        v.setPicture(rs.getBytes("picture"));
        v.setVehicleCategory(rs.getString("vehicle_category"));
        return v;
    }
}
