
package com.sft.controller;

import com.sft.dao.FileDAO;
import com.sft.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 11 * 1024 * 1024
)
public class UploadServlet extends HttpServlet {

    private static final Path STORAGE =
        Paths.get("C:/SecureFileStorage").toAbsolutePath().normalize();

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/upload.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        Part part = req.getPart("file");

        if (part == null || part.getSize() == 0
                || part.getSubmittedFileName() == null) {
            resp.sendError(400, "Please select a file.");
            return;
        }

        String originalName = Paths.get(part.getSubmittedFileName())
                .getFileName().toString();

        if (originalName.isBlank() || originalName.length() > 255) {
            resp.sendError(400, "Invalid filename.");
            return;
        }

        String storageKey = UUID.randomUUID().toString();
        Path target = STORAGE.resolve(storageKey).normalize();

        if (!target.getParent().equals(STORAGE)) {
            resp.sendError(400, "Invalid storage path.");
            return;
        }

        boolean saved = false;

        try {
            Files.createDirectories(STORAGE);

            try (InputStream input = part.getInputStream()) {
                Files.copy(input, target);
            }

            new FileDAO().addFile(
                originalName,
                storageKey,
                user.getId(),
                part.getSize()
            );

            saved = true;
            resp.sendRedirect(req.getContextPath() + "/files");

        } catch (Exception e) {
            throw new ServletException("Upload failed.", e);

        } finally {
            if (!saved) {
                Files.deleteIfExists(target);
            }
        }
    }
}
