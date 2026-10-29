
package com.sft.controller;

import com.sft.dao.UserDAO;
import com.sft.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/user-action")
public class AdminUserActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String base = request.getContextPath();
        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(base + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");

        if (!"ADMIN".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int id;

        try {
            id = Integer.parseInt(request.getParameter("id"));
            if (id <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            response.sendRedirect(base + "/admin/users?result=invalid");
            return;
        }

        if (id == admin.getId()) {
            response.sendRedirect(base + "/admin/users?result=self");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();
        String result;

        try {
            switch (action == null ? "" : action) {
                case "deactivate":
                    result = dao.deactivateUser(id)
                            ? "deactivated" : "notfound";
                    break;

                case "reactivate":
                    result = dao.reactivateUser(id)
                            ? "reactivated" : "notfound";
                    break;

                case "delete":
                    result = dao.permanentlyDeleteUser(id)
                            ? "deleted" : "notfound";
                    break;

                default:
                    result = "invalid";
            }

        } catch (SQLException e) {
            getServletContext().log(
                    "Admin user action failed.", e);

            // The DAO deliberately blocks deletion if the account
            // owns files or has activity history.
            if ("delete".equals(action)) {
                result = "blocked";
            } else {
                result = "error";
            }
        }

        response.sendRedirect(
                base + "/admin/users?result=" + result);
    }
}
