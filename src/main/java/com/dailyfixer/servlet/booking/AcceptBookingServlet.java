package com.dailyfixer.servlet.booking;

import com.dailyfixer.dao.BookingDAO;
import com.dailyfixer.dao.ChatDAO;
import com.dailyfixer.dao.RecurringContractDAO;
import com.dailyfixer.model.Booking;
import com.dailyfixer.model.Chat;
import com.dailyfixer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/bookings/accept")
public class AcceptBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            
            if (currentUser == null || !"technician".equalsIgnoreCase(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/pages/authentication/login.jsp");
                return;
            }
            
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null || booking.getTechnicianId() != currentUser.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized");
                return;
            }
            
            // Update booking status
            bookingDAO.updateBookingStatus(bookingId, "ACCEPTED");

            // If this is the first booking of a recurring contract, activate the
            // contract and auto-generate months 2-12 as ACCEPTED bookings.
            if (booking.getRecurringContractId() != null && Integer.valueOf(1).equals(booking.getRecurringSequence())) {
                RecurringContractDAO contractDAO = new RecurringContractDAO();
                contractDAO.updateContractStatus(booking.getRecurringContractId(), "ACTIVE");
                bookingDAO.createRecurringBookings(booking.getRecurringContractId(), booking);
            }

            // Create chat for this booking
            ChatDAO chatDAO = new ChatDAO();
            Chat existingChat = chatDAO.getChatByBookingId(bookingId);
            
            if (existingChat == null) {
                Chat chat = new Chat();
                chat.setBookingId(bookingId);
                chat.setUserId(booking.getUserId());
                chat.setTechnicianId(booking.getTechnicianId());
                chatDAO.createChat(chat);
            }
            
            response.sendRedirect(request.getContextPath() + "/bookings/requests?accepted=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error accepting booking: " + e.getMessage());
        }
    }
}
