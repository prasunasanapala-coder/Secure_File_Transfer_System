
<%@ page import="java.util.List,java.util.Collections,com.sft.model.User,com.sft.model.FileRecord,com.sft.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<FileRecord> files =
        (List<FileRecord>) request.getAttribute("files");

    if (files == null) {
        files = Collections.emptyList();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Files | SecureVault</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
        }

        .files-container {
            max-width: 1250px;
            margin: auto;
            padding: 32px 22px;
        }

        .page-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 18px;
            margin-bottom: 28px;
        }

        .eyebrow {
            color: #22d3ee;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        .page-heading h1 {
            font-size: 32px;
            font-weight: 700;
            margin: 8px 0;
        }

        .subtitle {
            color: #94a3b8;
            margin: 0;
        }

        .user-strip {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 22px;
            color: #94a3b8;
        }

        .role {
            display: inline-block;
            background: #22d3ee18;
            border: 1px solid #22d3ee55;
            color: #22d3ee;
            border-radius: 20px;
            padding: 4px 10px;
            font-size: 12px;
        }

        .files-panel {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 15px;
            padding: 22px;
            overflow-x: auto;
        }

        .panel-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .count {
            background: #182b40;
            color: #22d3ee;
            border-radius: 20px;
            padding: 6px 12px;
            font-size: 13px;
        }

        .table {
            --bs-table-bg: transparent;
            --bs-table-color: #e5edf7;
            --bs-table-border-color: #29384d;
            margin-bottom: 0;
            min-width: 750px;
            vertical-align: middle;
        }

        .table thead th {
            color: #94a3b8;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 15px 12px;
            border-bottom: 1px solid #34445a;
            white-space: nowrap;
        }

        .table tbody td {
            padding: 17px 12px;
        }

        .table tbody tr:hover > * {
            --bs-table-bg: #18263b;
            --bs-table-color: #e5edf7;
        }

        .file-name {
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .file-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #22d3ee15;
            border-radius: 9px;
            width: 38px;
            height: 38px;
            margin-right: 10px;
            font-size: 19px;
            flex-shrink: 0;
        }

        .file-cell {
            display: flex;
            align-items: center;
            min-width: 190px;
        }

        .action-group {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 7px;
        }

        .action-group form {
            margin: 0;
        }

        .action-btn {
            display: inline-block;
            text-decoration: none;
            border: 1px solid transparent;
            border-radius: 7px;
            padding: 8px 10px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
        }

        .btn-download {
            color: #22d3ee;
            background: #22d3ee12;
            border-color: #22d3ee45;
        }

        .btn-share {
            color: #a5b4fc;
            background: #818cf812;
            border-color: #818cf845;
        }

        .btn-delete {
            color: #f87171;
            background: #f8717112;
            border-color: #f8717145;
        }

        .action-btn:hover {
            filter: brightness(1.2);
        }

        .empty-state {
            text-align: center;
            padding: 55px 15px;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .empty-state p {
            color: #94a3b8;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 24px;
            margin-top: 25px;
        }

        .footer-links a {
            color: #22d3ee;
            text-decoration: none;
        }

        .footer-links a:hover {
            color: #a5f3fc;
        }

        @media (max-width: 600px) {
            .files-container {
                padding: 22px 12px;
            }

            .page-heading h1 {
                font-size: 26px;
            }

            .files-panel {
                padding: 14px;
            }
        }
    </style>
</head>

<body>

<div class="files-container">

    <!-- Page heading -->
    <header class="page-heading">
        <div>
            <div class="eyebrow">SECUREVAULT / WORKSPACE</div>
            <h1>📁 My Files</h1>
            <p class="subtitle">
                Manage your uploads and share files securely.
            </p>
        </div>

        <div class="d-flex flex-wrap gap-2">
            <a href="upload" class="btn btn-cyber">
                ＋ Upload File
            </a>

            <a href="shared-files" class="btn btn-outline-cyber">
                🔗 Shared With Me
            </a>
        </div>
    </header>

    <!-- User information -->
    <div class="user-strip">
        Signed in as
        <strong class="text-light">
            <%= HtmlUtil.escape(user.getUsername()) %>
        </strong>

        &nbsp; · &nbsp; Role:
        <span class="role">
            <%= HtmlUtil.escape(user.getRole()) %>
        </span>
    </div>

    <!-- File list -->
    <section class="files-panel">

        <div class="panel-heading">
            <div>
                <h4 class="mb-1">Your file library</h4>
                <p class="subtitle small mb-0">
                    Files available in your workspace
                </p>
            </div>

            <span class="count">
                <%= files.size() %> file(s)
            </span>
        </div>

        <% if (files.isEmpty()) { %>

            <div class="empty-state">
                <div class="empty-icon">📂</div>
                <h4>No files yet</h4>
                <p>Upload your first file to get started.</p>

                <a href="upload" class="btn btn-cyber mt-2">
                    ⬆ Upload Your First File
                </a>
            </div>

        <% } else { %>

            <table class="table">
                <thead>
                    <tr>
                        <th>File</th>
                        <th>Size (bytes)</th>
                        <th>Uploaded</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                <% for (FileRecord file : files) { %>

                    <tr>
                        <td>
                            <div class="file-cell">
                                <span class="file-icon">📄</span>
                                <span class="file-name">
                                    <%= HtmlUtil.escape(file.getOriginalName()) %>
                                </span>
                            </div>
                        </td>

                        <td>
                            <%= file.getFileSize() %>
                        </td>

                        <td>
                            <%= file.getUploadedAt() %>
                        </td>

                        <td>
                            <div class="action-group">

                                <a class="action-btn btn-download"
                                   href="download?id=<%= file.getId() %>">
                                    ⬇ Download
                                </a>

                                <a class="action-btn btn-share"
                                   href="share?fileId=<%= file.getId() %>">
                                    🔗 Share
                                </a>

                                <% if ("ADMIN".equals(user.getRole())
                                    || file.getUploadedBy() == user.getId()) { %>

                                    <form action="${pageContext.request.contextPath}/delete"
                                          method="post"
                                          onsubmit="return confirm('Are you sure you want to delete this file?');">

                                       <input type="hidden" name="id" value="<%= file.getId() %>">

                                       <button type="submit" class="btn btn-danger">
                                           Delete
                                       </button>
                                    </form>

                                <% } %>

                            </div>
                        </td>
                    </tr>

                <% } %>
                </tbody>
            </table>

        <% } %>

    </section>

    <!-- Footer navigation -->
    <footer class="footer-links">
        <a href="dashboard.jsp">← Dashboard</a>
        <a href="upload">＋ Upload File</a>
        <a href="shared-files">🔗 Shared With Me</a>
    </footer>

</div>

</body>
</html>
