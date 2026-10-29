
package com.sft.controller;

import com.sft.dao.UserDAO;
import com.sft.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet("/delete-user")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");

        if (!"ADMIN".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int userId;

        try {
            userId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid user ID");
            return;
        }

        // Prevent an administrator from deactivating their own account.
        if (userId == admin.getId()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "You cannot deactivate your own account here.");
            return;
        }

        try {
            UserDAO dao = new UserDAO();

            if (dao.deactivateUser(userId)) {
                response.sendRedirect(
                    request.getContextPath()
                    + "/users?deactivated=1");
            } else {
                response.sendRedirect(
                    request.getContextPath()
                    + "/users?error=notfound");
            }

        } catch (Exception e) {
            getServletContext().log("User deactivation failed.", e);
            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
