
package com.sft.controller;

import com.sft.dao.FileDAO;
import com.sft.dao.ShareDAO;
import com.sft.model.FileRecord;
import com.sft.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {

    private static final Path STORAGE =
        Paths.get("C:/SecureFileStorage").toAbsolutePath().normalize();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null ||
            !(session.getAttribute("user") instanceof User)) {
            resp.sendError(401, "Please log in.");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            if (id <= 0) {
                resp.sendError(400, "Invalid file ID.");
                return;
            }

            FileDAO fileDAO = new FileDAO();
            ShareDAO shareDAO = new ShareDAO();

            FileRecord file = fileDAO.findById(id);

            if (file == null) {
                resp.sendError(404, "File not found.");
                return;
            }

            boolean owner = file.getUploadedBy() == user.getId();
            boolean admin = "ADMIN".equals(user.getRole());

            boolean sharedDownload =
                shareDAO.hasPermission(id, user.getId(), "DOWNLOAD");

            if (!owner && !admin && !sharedDownload) {
                resp.sendError(403, "Download permission denied.");
                return;
            }

            Path path = STORAGE.resolve(file.getStorageKey()).normalize();

            if (!path.startsWith(STORAGE) ||
                !Files.isRegularFile(path)) {
                resp.sendError(404, "Stored file not found.");
                return;
            }

            resp.setContentType("application/octet-stream");
            resp.setHeader("X-Content-Type-Options", "nosniff");
            resp.setHeader(
                "Content-Disposition",
                "attachment; filename=\"download-" + id + "\""
            );
            resp.setContentLengthLong(Files.size(path));

            try (InputStream in = Files.newInputStream(path);
                 OutputStream out = resp.getOutputStream()) {
                in.transferTo(out);
            }

        } catch (NumberFormatException e) {
            resp.sendError(400, "Invalid file ID.");
        } catch (Exception e) {
            throw new IOException("Download failed.", e);
        }
    }
}
