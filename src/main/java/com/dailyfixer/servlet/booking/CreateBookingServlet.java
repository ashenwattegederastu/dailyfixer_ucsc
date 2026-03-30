package com.dailyfixer.servlet.booking;

import com.dailyfixer.dao.BookingDAO;
import com.dailyfixer.dao.ServiceDAO;
import com.dailyfixer.dao.TechnicianAvailabilityDAO;
import com.dailyfixer.model.Booking;
import com.dailyfixer.model.Service;
import com.dailyfixer.model.TechnicianAvailability;
import com.dailyfixer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/bookings/create")
public class CreateBookingServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String serviceIdStr = request.getParameter("serviceId");
            if (serviceIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/services");
                return;
            }
            
            int serviceId = Integer.parseInt(serviceIdStr);
            ServiceDAO serviceDAO = new ServiceDAO();
            Service service = serviceDAO.getServiceById(serviceId);
            
            if (service == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Service not found");
                return;
            }
            
            // Get technician availability
            TechnicianAvailabilityDAO availabilityDAO = new TechnicianAvailabilityDAO();
            TechnicianAvailability availability = availabilityDAO.getAvailabilityByTechnicianId(service.getTechnicianId());
            
            request.setAttribute("service", service);
            request.setAttribute("availability", availability);
            request.setAttribute("technicianId", service.getTechnicianId());
            request.getRequestDispatcher("/pages/bookings/create-booking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // Get form parameters
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String bookingDateStr = request.getParameter("bookingDate");
            String bookingTimeStr = request.getParameter("bookingTime");
            String phoneNumber = request.getParameter("phoneNumber");
            String problemDescription = request.getParameter("problemDescription");
            String locationAddress = request.getParameter("locationAddress");
            String latitudeStr = request.getParameter("latitude");
            String longitudeStr = request.getParameter("longitude");
            
            // Get service and technician info
            ServiceDAO serviceDAO = new ServiceDAO();
            Service service = serviceDAO.getServiceById(serviceId);
            
            if (service == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid service");
                return;
            }
            
            // Validate availability
            TechnicianAvailabilityDAO availabilityDAO = new TechnicianAvailabilityDAO();
            TechnicianAvailability availability = availabilityDAO.getAvailabilityByTechnicianId(service.getTechnicianId());
            
            LocalDate bookingDate = LocalDate.parse(bookingDateStr);
            LocalTime bookingTime = LocalTime.parse(bookingTimeStr);
            
            if (availability != null && !isValidBookingTime(availability, bookingDate, bookingTime)) {
                request.setAttribute("error", "The selected date/time is not available for this technician");
                request.setAttribute("service", service);
                request.setAttribute("availability", availability);
                request.getRequestDispatcher("/pages/bookings/create-booking.jsp").forward(request, response);
                return;
            }
            
            // Create booking
            Booking booking = new Booking();
            booking.setUserId(currentUser.getUserId());
            booking.setTechnicianId(service.getTechnicianId());
            booking.setServiceId(serviceId);
            booking.setBookingDate(Date.valueOf(bookingDate));
            booking.setBookingTime(Time.valueOf(bookingTime));
            booking.setPhoneNumber(phoneNumber);
            booking.setProblemDescription(problemDescription);
            booking.setLocationAddress(locationAddress);
            
            if (latitudeStr != null && !latitudeStr.isEmpty()) {
                booking.setLocationLatitude(new BigDecimal(latitudeStr));
            }
            if (longitudeStr != null && !longitudeStr.isEmpty()) {
                booking.setLocationLongitude(new BigDecimal(longitudeStr));
            }
            
            booking.setStatus("REQUESTED");
            
            BookingDAO bookingDAO = new BookingDAO();
            bookingDAO.createBooking(booking);
            
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/userdash/userdashmain.jsp?bookingSuccess=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating booking: " + e.getMessage());
        }
    }
    
    private boolean isValidBookingTime(TechnicianAvailability availability, LocalDate date, LocalTime time) {
        // Check if day is available
        DayOfWeek dayOfWeek = date.getDayOfWeek();
        boolean dayAvailable = false;
        
        switch (dayOfWeek) {
            case MONDAY: dayAvailable = availability.isMonday(); break;
            case TUESDAY: dayAvailable = availability.isTuesday(); break;
            case WEDNESDAY: dayAvailable = availability.isWednesday(); break;
            case THURSDAY: dayAvailable = availability.isThursday(); break;
            case FRIDAY: dayAvailable = availability.isFriday(); break;
            case SATURDAY: dayAvailable = availability.isSaturday(); break;
            case SUNDAY: dayAvailable = availability.isSunday(); break;
        }
        
        if (!dayAvailable) {
            return false;
        }
        
        // Check if time is within window
        LocalTime startTime = availability.getStartTime().toLocalTime();
        LocalTime endTime = availability.getEndTime().toLocalTime();
        
        return !time.isBefore(startTime) && !time.isAfter(endTime);
    }
}
