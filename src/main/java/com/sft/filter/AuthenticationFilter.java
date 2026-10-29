
package com.sft.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI()
                         .substring(req.getContextPath().length());

        // Pages accessible without logging in
        if (path.equals("/login.jsp")
                || path.equals("/register.jsp")
                || path.equals("/login")
                || path.equals("/register")
                || path.equals("/index.jsp")
                || path.equals("/")) {
            chain.doFilter(request, response);
            return;
        }

        // Allow CSS and other static resources
        if (path.startsWith("/css/")
                || path.startsWith("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        // Check whether a valid login session exists
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}
