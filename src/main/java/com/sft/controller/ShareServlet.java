
package com.sft.controller;

import com.sft.dao.FileDAO;
import com.sft.dao.ShareDAO;
import com.sft.model.FileRecord;
import com.sft.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.sft.util.DBConnection;

@WebServlet("/share")
public class ShareServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Only show files owned by this user.
            List<FileRecord> files =
                    new FileDAO().getFiles(user.getId(), false);

            List<Map<String, Object>> recipients = new ArrayList<>();

            String sql = """
                SELECT id, username
                FROM users
                WHERE active = TRUE AND id <> ?
                ORDER BY username
                """;

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, user.getId());

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> recipient = new HashMap<>();
                        recipient.put("id", rs.getInt("id"));
                        recipient.put("username", rs.getString("username"));
                        recipients.add(recipient);
                    }
                }
            }

            request.setAttribute("files", files);
            request.setAttribute("recipients", recipients);
            // Preselect the file clicked on the My Files page
            String selectedFileId = request.getParameter("fileId");
            request.setAttribute("selectedFileId", selectedFileId);
            request.getRequestDispatcher("/share.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load sharing page.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int fileId = Integer.parseInt(request.getParameter("fileId"));
            int recipientId =
                    Integer.parseInt(request.getParameter("recipientId"));

            String permission = request.getParameter("permission");

            if (!"VIEW".equals(permission)
                    && !"DOWNLOAD".equals(permission)) {
                response.sendError(400, "Invalid permission.");
                return;
            }

            boolean shared = new ShareDAO().shareFile(
                    fileId, user.getId(), recipientId, permission);

            if (shared) {
                response.sendRedirect("share?success=1");
            } else {
                response.sendRedirect("share?error=1");
            }

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid file or recipient.");
        } catch (SQLException e) {
            throw new ServletException("Unable to share file.", e);
        }
    }
}
