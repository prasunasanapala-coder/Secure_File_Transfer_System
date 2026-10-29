
package com.sft.controller;

import com.sft.dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || !username.matches("[A-Za-z0-9_]{3,50}")
                || password == null || password.length() < 10
                || password.length() > 72) {
            req.setAttribute("error",
                "Use a 3-50 character username and a password of 10-72 characters.");
            req.getRequestDispatcher("/register.jsp")
                .forward(req, resp);
            return;
        }

        try {
            new UserDAO().register(username, password);
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            req.setAttribute("error", "Username already exists.");
            req.getRequestDispatcher("/register.jsp")
                .forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Registration failed", e);
        }
    }
}
