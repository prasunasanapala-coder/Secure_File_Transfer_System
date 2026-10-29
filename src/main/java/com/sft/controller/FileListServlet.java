
package com.sft.controller;

import com.sft.dao.FileDAO;
import com.sft.model.FileRecord;
import com.sft.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/files")
public class FileListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession(false)
                .getAttribute("user");

        try {
            boolean admin = "ADMIN".equals(user.getRole());

            List<FileRecord> files =
                new FileDAO().getFiles(user.getId(), admin);

            req.setAttribute("files", files);
            req.getRequestDispatcher("/files.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Unable to list files.", e);
        }
    }
}
