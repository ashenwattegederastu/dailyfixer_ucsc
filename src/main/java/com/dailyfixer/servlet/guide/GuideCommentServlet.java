package com.dailyfixer.servlet.guide;

import com.dailyfixer.dao.GuideCommentDAO;
import com.dailyfixer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for adding and deleting comments on guides.
 * URL: /guides/comment
 */
@WebServlet("/guides/comment")
public class GuideCommentServlet extends HttpServlet {

    private GuideCommentDAO commentDAO = new GuideCommentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String guideIdParam = request.getParameter("guideId");

        if (guideIdParam == null || guideIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/guides");
            return;
        }

        int guideId;
        try {
            guideId = Integer.parseInt(guideIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/guides");
            return;
        }

        if ("add".equals(action)) {
            // Add a new comment
            String comment = request.getParameter("comment");
            if (comment != null && !comment.trim().isEmpty()) {
                commentDAO.addComment(guideId, currentUser.getUserId(), comment.trim());
            }
        } else if ("delete".equals(action)) {
            // Delete a comment (only if owner)
            String commentIdParam = request.getParameter("commentId");
            if (commentIdParam != null) {
                try {
                    int commentId = Integer.parseInt(commentIdParam);
                    commentDAO.deleteComment(commentId, currentUser.getUserId());
                } catch (NumberFormatException e) {
                    // Ignore invalid comment ID
                }
            }
        }

        // Redirect back to guide view
        response.sendRedirect(request.getContextPath() + "/guides/view?id=" + guideId);
    }
}
