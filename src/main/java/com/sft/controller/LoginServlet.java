
package com.sft.controller;

import com.sft.dao.UserDAO;
import com.sft.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User user = new UserDAO().authenticate(
                username == null ? "" : username.trim(),
                password == null ? "" : password
            );

            if (user == null) {
                req.setAttribute("error",
                    "Invalid username or password.");
                req.getRequestDispatcher("/login.jsp")
                    .forward(req, resp);
                return;
            }

            HttpSession old = req.getSession(false);
            if (old != null) {
                old.invalidate();
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(20 * 60);

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");

        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}
