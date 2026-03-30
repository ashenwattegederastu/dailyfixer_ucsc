package com.dailyfixer.servlet.user;

import com.dailyfixer.dao.BookingDAO;
import com.dailyfixer.dao.BookingRatingDAO;
import com.dailyfixer.model.Booking;
import com.dailyfixer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/user/bookings/*")
public class UserBookingsServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || !"user".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/bookings/active");
            return;
        }

        try {
            int userId = currentUser.getUserId();
            List<Booking> bookings;
            String targetJsp = "";

            switch (pathInfo) {
                case "/active":
                    bookings = bookingDAO.getBookingsByUserAndStatuses(userId, "REQUESTED", "ACCEPTED",
                            "TECHNICIAN_COMPLETED");
                    request.setAttribute("activeBookings", bookings);
                    targetJsp = "/pages/dashboards/userdash/activeBookings.jsp";
                    break;
                case "/completed":
                    bookings = bookingDAO.getBookingsByUserAndStatuses(userId, "FULLY_COMPLETED");
                    request.setAttribute("completedBookings", bookings);

                    // Build set of booking IDs where user has already submitted a TECHNICIAN_RATING
                    BookingRatingDAO ratingDAO = new BookingRatingDAO();
                    Set<Integer> ratedBookingIds = new HashSet<>();
                    for (Booking b : bookings) {
                        if (ratingDAO.hasRated(b.getBookingId(), "TECHNICIAN_RATING")) {
                            ratedBookingIds.add(b.getBookingId());
                        }
                    }
                    request.setAttribute("ratedBookingIds", ratedBookingIds);
                    targetJsp = "/pages/dashboards/userdash/completedBookings.jsp";
                    break;
                case "/cancelled":
                    bookings = bookingDAO.getBookingsByUserAndStatuses(userId, "REJECTED", "CANCELLED");
                    request.setAttribute("cancelledBookings", bookings);
                    targetJsp = "/pages/dashboards/userdash/cancelledBookings.jsp";
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/user/bookings/active");
                    return;
            }

            request.getRequestDispatcher(targetJsp).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath() + "/pages/dashboards/userdash/userdashmain.jsp?error=fetch_failed");
        }
    }
}
