
<%@ page import="java.util.*,com.sft.model.FileRecord,com.sft.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<FileRecord> files =
        (List<FileRecord>) request.getAttribute("files");

    List<Map<String,Object>> recipients =
        (List<Map<String,Object>>) request.getAttribute("recipients");

    String selectedFileId =
        (String) request.getAttribute("selectedFileId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Share File | SecureVault</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            padding: 30px 16px;
            background:
                radial-gradient(ellipse at top, #122b40 0%, #0b1120 65%);
        }

        .share-container {
            max-width: 680px;
            margin: 0 auto;
        }

        .back-link {
            display: inline-block;
            color: #22d3ee;
            text-decoration: none;
            margin-bottom: 22px;
        }

        .back-link:hover {
            color: #a5f3fc;
        }

        .share-card {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 18px;
            padding: 32px;
            box-shadow: 0 20px 60px #00000025;
        }

        .share-icon {
            width: 70px;
            height: 70px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 32px;
            background: #22d3ee15;
            border: 1px solid #22d3ee55;
            border-radius: 18px;
            margin-bottom: 20px;
        }

        .eyebrow {
            color: #22d3ee;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        .share-card h1 {
            color: #e5edf7;
            font-size: 29px;
            font-weight: 700;
            margin: 10px 0;
        }

        .subtitle {
            color: #94a3b8;
            line-height: 1.6;
        }

        .field-label {
            display: block;
            color: #dbe7f5;
            font-weight: 600;
            margin: 22px 0 8px;
        }

        .dark-select {
            width: 100%;
            padding: 13px;
            color: #e5edf7;
            background-color: #0b1525;
            border: 1px solid #34445a;
            border-radius: 9px;
            outline: none;
        }

        .dark-select:focus {
            border-color: #22d3ee;
            box-shadow: 0 0 0 3px #22d3ee20;
        }

        .dark-select option {
            color: #e5edf7;
            background: #111c2f;
        }

        .permission-note {
            margin-top: 18px;
            padding: 14px;
            border-radius: 10px;
            background: #22d3ee0c;
            border: 1px solid #22d3ee30;
            color: #a9c5d8;
            font-size: 13px;
            line-height: 1.6;
        }

        .share-submit {
            width: 100%;
            padding: 13px;
            margin-top: 25px;
            border: none;
            border-radius: 9px;
            color: #07111e;
            background: #22d3ee;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        .share-submit:hover {
            background: #a5f3fc;
            transform: translateY(-1px);
        }

        .notice {
            padding: 13px 15px;
            border-radius: 9px;
            margin: 20px 0;
        }

        .success {
            background: #22c55e12;
            border: 1px solid #22c55e50;
            color: #86efac;
        }

        .error {
            background: #f8717112;
            border: 1px solid #f8717150;
            color: #fca5a5;
        }

        .empty-message {
            padding: 18px;
            background: #0b1525;
            border: 1px solid #29384d;
            border-radius: 10px;
            color: #cbd5e1;
            margin-top: 22px;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 22px;
            margin-top: 25px;
        }

        .footer-links a {
            color: #22d3ee;
            text-decoration: none;
        }

        .footer-links a:hover {
            color: #a5f3fc;
        }

        @media (max-width: 480px) {
            .share-card {
                padding: 23px 18px;
            }

            .share-card h1 {
                font-size: 25px;
            }
        }
    </style>
</head>

<body>

<div class="share-container">

    <a class="back-link" href="dashboard.jsp">
        ← Back to Dashboard
    </a>

    <main class="share-card">

        <div class="share-icon">🔗</div>

        <div class="eyebrow">SECURE FILE MANAGEMENT</div>

        <h1>Share a File</h1>

        <p class="subtitle">
            Choose a file, select a recipient, and assign the appropriate
            access permission.
        </p>

        <% if ("1".equals(request.getParameter("success"))) { %>

            <div class="notice success" role="status">
                ✓ File shared successfully!
            </div>

        <% } %>

        <% if ("1".equals(request.getParameter("error"))) { %>

            <div class="notice error" role="alert">
                Sharing failed. Please check the file, recipient,
                permission, and server logs.
            </div>

        <% } %>

        <% if (files == null || files.isEmpty()) { %>

            <div class="empty-message">
                📂 You have no files to share. Upload a file first.
                <div class="mt-3">
                    <a href="upload" class="btn btn-cyber">
                        ⬆ Upload File
                    </a>
                </div>
            </div>

        <% } else if (recipients == null || recipients.isEmpty()) { %>

            <div class="empty-message">
                👥 No other active users are available to share with.
            </div>

        <% } else { %>

            <form action="share" method="post">

                <label class="field-label" for="fileId">
                    📁 Choose File
                </label>

                <select class="dark-select" id="fileId"
                        name="fileId" required>

                    <% for (FileRecord file : files) {
                        boolean selected = selectedFileId != null
                            && selectedFileId.equals(
                                String.valueOf(file.getId())
                            );
                    %>

                        <option value="<%= file.getId() %>"
                            <%= selected ? "selected" : "" %>>
                            <%= HtmlUtil.escape(file.getOriginalName()) %>
                        </option>

                    <% } %>

                </select>

                <label class="field-label" for="recipientId">
                    👤 Share With
                </label>

                <select class="dark-select" id="recipientId"
                        name="recipientId" required>

                    <% for (Map<String,Object> recipient : recipients) { %>

                        <option value="<%= recipient.get("id") %>">
                            <%= HtmlUtil.escape(
                                String.valueOf(recipient.get("username"))
                            ) %>
                        </option>

                    <% } %>

                </select>

                <label class="field-label" for="permission">
                    🔐 Access Permission
                </label>

                <select class="dark-select" id="permission"
                        name="permission" required>

                    <option value="VIEW">👁 View Only</option>
                    <option value="DOWNLOAD">⬇ View and Download</option>

                </select>

                <div class="permission-note" id="permissionNote">
                    👁 <strong>View Only:</strong>
                    The recipient receives viewing access, not download access.
                </div>

                <button class="share-submit" type="submit">
                    🔗 Share Securely
                </button>

            </form>

        <% } %>

    </main>

    <nav class="footer-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="files">My Files</a>
        <a href="shared-files">Shared With Me</a>
    </nav>

</div>

<script>
    const permission = document.getElementById("permission");
    const permissionNote = document.getElementById("permissionNote");

    if (permission && permissionNote) {
        permission.addEventListener("change", function () {
            if (this.value === "DOWNLOAD") {
                permissionNote.innerHTML =
                    "⬇ <strong>View and Download:</strong> " +
                    "The recipient receives viewing and download access.";
            } else {
                permissionNote.innerHTML =
                    "👁 <strong>View Only:</strong> " +
                    "The recipient receives viewing access, " +
                    "not download access.";
            }
        });
    }
</script>

</body>
</html>
