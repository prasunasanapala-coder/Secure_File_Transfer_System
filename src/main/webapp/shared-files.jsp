
<%@ page import="java.util.*" %>
<%@ page import="com.sft.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<Map<String,Object>> sharedFiles =
        (List<Map<String,Object>>) request.getAttribute("sharedFiles");

    if (sharedFiles == null) {
        sharedFiles = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shared With Me | SecureVault</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            padding: 30px 18px;
            background: radial-gradient(ellipse at top, #122b40 0%, #0b1120 65%);
        }

        .page-container {
            max-width: 1150px;
            margin: auto;
        }

        .back-link {
            color: #22d3ee;
            text-decoration: none;
        }

        .back-link:hover {
            color: #a5f3fc;
        }

        .eyebrow {
            color: #22d3ee;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            margin-top: 28px;
        }

        h1 {
            color: #e5edf7;
            font-weight: 700;
            margin: 10px 0;
        }

        .subtitle {
            color: #94a3b8;
            line-height: 1.7;
            max-width: 680px;
            margin-bottom: 28px;
        }

        .summary-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 12px;
            padding: 15px 18px;
            margin-bottom: 22px;
        }

        .count {
            background: #22d3ee18;
            border: 1px solid #22d3ee40;
            color: #22d3ee;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        .files-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }

        .file-card {
            display: flex;
            flex-direction: column;
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 16px;
            padding: 23px;
            min-width: 0;
            transition: transform .2s, border-color .2s;
        }

        .file-card:hover {
            transform: translateY(-4px);
            border-color: #22d3ee;
        }

        .file-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 56px;
            height: 56px;
            font-size: 27px;
            border-radius: 14px;
            background: #22d3ee15;
            border: 1px solid #22d3ee35;
            margin-bottom: 20px;
        }

        .filename {
            color: #e5edf7;
            font-size: 18px;
            font-weight: 700;
            overflow-wrap: anywhere;
            margin-bottom: 12px;
        }

        .owner {
            color: #94a3b8;
            font-size: 14px;
            overflow-wrap: anywhere;
        }

        .permission {
            display: inline-block;
            align-self: flex-start;
            margin: 8px 0 20px;
            padding: 7px 11px;
            border-radius: 20px;
            background: #22d3ee12;
            border: 1px solid #22d3ee40;
            color: #22d3ee;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .5px;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 9px;
            margin-top: auto;
            padding-top: 5px;
        }

        .action-btn {
            display: inline-block;
            border-radius: 8px;
            padding: 10px 13px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: filter .2s;
        }

        .action-btn:hover {
            filter: brightness(1.2);
        }

        .view-btn {
            color: #22d3ee;
            background: #22d3ee12;
            border: 1px solid #22d3ee45;
        }

        .download-btn {
            color: #86efac;
            background: #22c55e12;
            border: 1px solid #22c55e45;
        }

        .empty-card {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 16px;
            text-align: center;
            padding: 50px 20px;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 16px;
        }

        .empty-card h2 {
            color: #e5edf7;
            font-size: 23px;
        }

        .empty-card p {
            color: #94a3b8;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 22px;
            margin-top: 30px;
        }

        .footer-links a {
            color: #22d3ee;
            text-decoration: none;
        }

        .footer-links a:hover {
            color: #a5f3fc;
        }

        @media (max-width: 500px) {
            body {
                padding: 22px 12px;
            }

            .file-card {
                padding: 19px;
            }
        }
    </style>
</head>

<body>

<div class="page-container">

    <a class="back-link" href="dashboard.jsp">
        ← Back to Dashboard
    </a>

    <div class="eyebrow">SECUREVAULT / SHARED ACCESS</div>

    <h1>📂 Shared With Me</h1>

    <p class="subtitle">
        Access files shared by other users. Available actions depend
        on the permissions assigned to your account.
    </p>

    <div class="summary-bar">
        <div>
            <strong style="color:#e5edf7;">Shared file library</strong>
            <div class="small mt-1" style="color:#94a3b8;">
                Files accessible to your account
            </div>
        </div>

        <span class="count">
            <%= sharedFiles.size() %> shared file(s)
        </span>
    </div>

    <% if (sharedFiles.isEmpty()) { %>

        <div class="empty-card">
            <div class="empty-icon">📂</div>
            <h2>No shared files yet</h2>
            <p>When another user shares a file with you, it will appear here.</p>

            <a href="dashboard.jsp" class="btn btn-cyber mt-2">
                Return to Dashboard
            </a>
        </div>

    <% } else { %>

        <div class="files-grid">

        <% for (Map<String,Object> file : sharedFiles) {

            String name = HtmlUtil.escape(
                String.valueOf(file.get("name")));

            String owner = HtmlUtil.escape(
                String.valueOf(file.get("owner")));

            String permission = String.valueOf(file.get("permission"));

            Object fileId = file.get("id");

            boolean canView =
                "VIEW".equals(permission) ||
                "DOWNLOAD".equals(permission);

            boolean canDownload = "DOWNLOAD".equals(permission);

            boolean validId = fileId instanceof Number;
        %>

            <article class="file-card">

                <div class="file-icon">📄</div>

                <div class="filename"><%= name %></div>

                <p class="owner">
                    Shared by <strong style="color:#cbd5e1;"><%= owner %></strong>
                </p>

                <span class="permission">
                    🔐 <%= HtmlUtil.escape(permission) %> ACCESS
                </span>

                <div class="actions">

                    <% if (validId && canView) { %>
                        <a class="action-btn view-btn"
                           href="view-shared?id=<%= ((Number) fileId).intValue() %>">
                            👁 View
                        </a>
                    <% } %>

                    <% if (validId && canDownload) { %>
                        <a class="action-btn download-btn"
                           href="download?id=<%= ((Number) fileId).intValue() %>">
                            ⬇ Download
                        </a>
                    <% } %>

                </div>

            </article>

        <% } %>

        </div>

    <% } %>

    <footer class="footer-links">
        <a href="files">← My Files</a>
        <a href="dashboard.jsp">Dashboard</a>
    </footer>

</div>

</body>
</html>
