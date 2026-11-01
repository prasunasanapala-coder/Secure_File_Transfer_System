
package com.sft.controller;

import com.sft.dao.FileDAO;
import com.sft.dao.ShareDAO;
import com.sft.model.FileRecord;
import com.sft.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(urlPatterns = {"/view", "/view-shared"})
public class ViewFileServlet extends HttpServlet {

    private static final Path STORAGE =
        Paths.get("C:/SecureFileStorage")
             .toAbsolutePath().normalize();

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

            FileRecord file = new FileDAO().findById(id);

            if (file == null) {
                resp.sendError(404, "File not found.");
                return;
            }

            ShareDAO shareDAO = new ShareDAO();

            boolean owner = file.getUploadedBy() == user.getId();
            boolean admin = "ADMIN".equals(user.getRole());

            boolean canView =
                shareDAO.hasPermission(id, user.getId(), "VIEW");

            boolean canDownload =
                shareDAO.hasPermission(id, user.getId(), "DOWNLOAD");

            if (!owner && !admin && !canView && !canDownload) {
                resp.sendError(403, "View permission denied.");
                return;
            }

            Path path =
                STORAGE.resolve(file.getStorageKey()).normalize();

            if (!path.startsWith(STORAGE) ||
                !Files.isRegularFile(path)) {
                resp.sendError(404, "Stored file not found.");
                return;
            }

            String contentType = Files.probeContentType(path);

            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            boolean safeInline =
                contentType.equals("application/pdf") ||
                contentType.equals("image/png") ||
                contentType.equals("image/jpeg") ||
                contentType.equals("image/gif") ||
                contentType.equals("image/webp") ||
                contentType.equals("text/plain");

            resp.setHeader("X-Content-Type-Options", "nosniff");

            if (safeInline) {
                resp.setContentType(contentType);
                resp.setHeader(
                    "Content-Disposition",
                    "inline; filename=\"file-" + id + "\""
                );
            } else {
                resp.setContentType("application/octet-stream");
                resp.setHeader(
                    "Content-Disposition",
                    "attachment; filename=\"file-" + id + "\""
                );
            }

            resp.setContentLengthLong(Files.size(path));

            try (var in = Files.newInputStream(path);
                 var out = resp.getOutputStream()) {
                in.transferTo(out);
            }

        } catch (NumberFormatException e) {
            resp.sendError(400, "Invalid file ID.");

        } catch (Exception e) {
            throw new IOException("Unable to view file.", e);
        }
    }
}
