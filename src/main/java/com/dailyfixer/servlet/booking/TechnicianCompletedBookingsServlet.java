package com.dailyfixer.servlet.booking;

import com.dailyfixer.dao.BookingDAO;
import com.dailyfixer.dao.BookingRatingDAO;
import com.dailyfixer.model.Booking;
import com.dailyfixer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/technician/bookings/completed")
public class TechnicianCompletedBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser == null || !"technician".equalsIgnoreCase(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            BookingRatingDAO ratingDAO = new BookingRatingDAO();
            int techId = currentUser.getUserId();

            // Fetch both TECHNICIAN_COMPLETED (awaiting user confirm) and FULLY_COMPLETED
            List<Booking> techCompleted = bookingDAO.getBookingsByTechnicianAndStatus(techId, "TECHNICIAN_COMPLETED");
            List<Booking> fullyCompleted = bookingDAO.getBookingsByTechnicianAndStatus(techId, "FULLY_COMPLETED");

            List<Booking> allCompleted = new ArrayList<>();
            allCompleted.addAll(techCompleted);
            allCompleted.addAll(fullyCompleted);

            // Build set of booking IDs where technician has already submitted a CLIENT_RATING
            Set<Integer> ratedBookingIds = new HashSet<>();
            for (Booking b : fullyCompleted) {
                if (ratingDAO.hasRated(b.getBookingId(), "CLIENT_RATING")) {
                    ratedBookingIds.add(b.getBookingId());
                }
            }

            request.setAttribute("completedBookings", allCompleted);
            request.setAttribute("ratedBookingIds", ratedBookingIds);
            request.getRequestDispatcher("/pages/dashboards/techniciandash/completedBookings.jsp").forward(request,
                    response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading completed bookings: " + e.getMessage());
        }
    }
}
