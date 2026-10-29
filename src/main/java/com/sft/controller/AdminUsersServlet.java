
package com.sft.controller;

import com.sft.dao.UserDAO;
import com.sft.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        if (!"ADMIN".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            UserDAO dao = new UserDAO();

            request.setAttribute("users", dao.getAllUsers());

            request.getRequestDispatcher(
                "/admin-users.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            getServletContext().log(
                "Could not load users.", e);

            throw new ServletException(
                "Could not load user management page.", e);
        }
    }
}
