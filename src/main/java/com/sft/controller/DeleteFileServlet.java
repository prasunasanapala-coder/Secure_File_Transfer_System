package com.sft.controller;

import com.sft.dao.FileDAO;
import com.sft.model.FileRecord;
import com.sft.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;

@WebServlet("/delete")
public class DeleteFileServlet extends HttpServlet {

    private static final Path STORAGE_DIR =
            Paths.get("C:/SecureFileStorage").toAbsolutePath().normalize();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
    	System.out.println("DELETE SERVLET CALLED");
    	System.out.println("File ID: " + request.getParameter("id"));

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        boolean admin = "ADMIN".equals(user.getRole());

        int fileId;

        try {
            fileId = Integer.parseInt(request.getParameter("id"));
            if (fileId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("files?error=invalid");
            return;
        }

        FileDAO dao = new FileDAO();

        try {
            FileRecord file = dao.findById(fileId);

            if (file == null) {
                response.sendRedirect("files?error=notfound");
                return;
            }

            if (!admin && file.getUploadedBy() != user.getId()) {
                response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You cannot delete this file."
                );
                return;
            }

            Path storedFile = STORAGE_DIR
                    .resolve(file.getStorageKey())
                    .normalize();

            if (!storedFile.startsWith(STORAGE_DIR)) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid file path."
                );
                return;
            }

            boolean deleted = dao.deleteFile(
                    fileId, user.getId(), admin);

            if (!deleted) {
                response.sendRedirect("files?error=failed");
                return;
            }

            try {
                Files.deleteIfExists(storedFile);
            } catch (IOException e) {
                getServletContext().log(
                    "Database record deleted, but stored file cleanup failed.",
                    e
                );
                response.sendRedirect("files?error=storage");
                return;
            }

            response.sendRedirect("files?deleted=1");

        } catch (SQLException e) {
            getServletContext().log("File deletion failed.", e);
            response.sendRedirect("files?error=failed");
        }
    }
}