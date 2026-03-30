package com.dailyfixer.dao;

import com.dailyfixer.model.Booking;
import com.dailyfixer.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public void createBooking(Booking booking) throws Exception {
        String sql = "INSERT INTO bookings (user_id, technician_id, service_id, booking_date, booking_time, phone_number, problem_description, location_address, location_latitude, location_longitude, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getTechnicianId());
            ps.setInt(3, booking.getServiceId());
            ps.setDate(4, booking.getBookingDate());
            ps.setTime(5, booking.getBookingTime());
            ps.setString(6, booking.getPhoneNumber());
            ps.setString(7, booking.getProblemDescription());
            ps.setString(8, booking.getLocationAddress());
            ps.setBigDecimal(9, booking.getLocationLatitude());
            ps.setBigDecimal(10, booking.getLocationLongitude());
            ps.setString(11, booking.getStatus());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    booking.setBookingId(rs.getInt(1));
                }
            }
        }
    }

    public Booking getBookingById(int bookingId) throws Exception {
        String sql = "SELECT b.*, u1.first_name as user_first_name, u1.last_name as user_last_name, " +
                "u2.first_name as tech_first_name, u2.last_name as tech_last_name, s.service_name " +
                "FROM bookings b " +
                "JOIN users u1 ON b.user_id = u1.user_id " +
                "JOIN users u2 ON b.technician_id = u2.user_id " +
                "JOIN services s ON b.service_id = s.service_id " +
                "WHERE b.booking_id = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBookingFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public List<Booking> getBookingsByUserId(int userId) throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u1.first_name as user_first_name, u1.last_name as user_last_name, " +
                "u2.first_name as tech_first_name, u2.last_name as tech_last_name, s.service_name " +
                "FROM bookings b " +
                "JOIN users u1 ON b.user_id = u1.user_id " +
                "JOIN users u2 ON b.technician_id = u2.user_id " +
                "JOIN services s ON b.service_id = s.service_id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.booking_date DESC, b.booking_time DESC";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public List<Booking> getBookingsByUserAndStatuses(int userId, String... statuses) throws Exception {
        List<Booking> list = new ArrayList<>();
        if (statuses == null || statuses.length == 0)
            return list;

        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u1.first_name as user_first_name, u1.last_name as user_last_name, " +
                        "u2.first_name as tech_first_name, u2.last_name as tech_last_name, s.service_name " +
                        "FROM bookings b " +
                        "JOIN users u1 ON b.user_id = u1.user_id " +
                        "JOIN users u2 ON b.technician_id = u2.user_id " +
                        "JOIN services s ON b.service_id = s.service_id " +
                        "WHERE b.user_id = ? AND b.status IN (");
        for (int i = 0; i < statuses.length; i++) {
            sql.append("?");
            if (i < statuses.length - 1)
                sql.append(",");
        }
        sql.append(") ORDER BY b.booking_date DESC, b.booking_time DESC");

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, userId);
            for (int i = 0; i < statuses.length; i++) {
                ps.setString(i + 2, statuses[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public List<Booking> getBookingsByTechnicianId(int technicianId) throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u1.first_name as user_first_name, u1.last_name as user_last_name, " +
                "u2.first_name as tech_first_name, u2.last_name as tech_last_name, s.service_name " +
                "FROM bookings b " +
                "JOIN users u1 ON b.user_id = u1.user_id " +
                "JOIN users u2 ON b.technician_id = u2.user_id " +
                "JOIN services s ON b.service_id = s.service_id " +
                "WHERE b.technician_id = ? " +
                "ORDER BY b.booking_date DESC, b.booking_time DESC";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public List<Booking> getBookingsByTechnicianAndStatus(int technicianId, String status) throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u1.first_name as user_first_name, u1.last_name as user_last_name, " +
                "u2.first_name as tech_first_name, u2.last_name as tech_last_name, s.service_name " +
                "FROM bookings b " +
                "JOIN users u1 ON b.user_id = u1.user_id " +
                "JOIN users u2 ON b.technician_id = u2.user_id " +
                "JOIN services s ON b.service_id = s.service_id " +
                "WHERE b.technician_id = ? AND b.status = ? " +
                "ORDER BY b.booking_date DESC, b.booking_time DESC";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public List<Booking> getBookingsByTechnicianAndDate(int technicianId, Date date) throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u1.first_name as user_first_name, u1.last_name as user_last_name, " +
                "u2.first_name as tech_first_name, u2.last_name as tech_last_name, s.service_name " +
                "FROM bookings b " +
                "JOIN users u1 ON b.user_id = u1.user_id " +
                "JOIN users u2 ON b.technician_id = u2.user_id " +
                "JOIN services s ON b.service_id = s.service_id " +
                "WHERE b.technician_id = ? AND b.booking_date = ? " +
                "ORDER BY b.booking_time";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public void updateBookingStatus(int bookingId, String status) throws Exception {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        }
    }

    public void updateBookingStatusWithRejection(int bookingId, String status, String rejectionReason)
            throws Exception {
        String sql = "UPDATE bookings SET status = ?, rejection_reason = ? WHERE booking_id = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, rejectionReason);
            ps.setInt(3, bookingId);
            ps.executeUpdate();
        }
    }

    public int countPendingBookingsByTechnicianId(int technicianId) throws Exception {
        String sql = "SELECT COUNT(*) FROM bookings WHERE technician_id = ? AND status = 'REQUESTED'";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setTechnicianId(rs.getInt("technician_id"));
        booking.setServiceId(rs.getInt("service_id"));
        booking.setBookingDate(rs.getDate("booking_date"));
        booking.setBookingTime(rs.getTime("booking_time"));
        booking.setPhoneNumber(rs.getString("phone_number"));
        booking.setProblemDescription(rs.getString("problem_description"));
        booking.setLocationAddress(rs.getString("location_address"));
        booking.setLocationLatitude(rs.getBigDecimal("location_latitude"));
        booking.setLocationLongitude(rs.getBigDecimal("location_longitude"));
        booking.setStatus(rs.getString("status"));
        booking.setRejectionReason(rs.getString("rejection_reason"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Set display names
        booking.setUserName(rs.getString("user_first_name") + " " + rs.getString("user_last_name"));
        booking.setTechnicianName(rs.getString("tech_first_name") + " " + rs.getString("tech_last_name"));
        booking.setServiceName(rs.getString("service_name"));

        return booking;
    }

    public int countCompletedBookingsByTechnician(int technicianId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE technician_id = ? AND status = 'FULLY_COMPLETED'";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
