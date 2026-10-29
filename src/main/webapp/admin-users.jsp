
<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="com.sft.util.HtmlUtil" %>

<%
    Object data = request.getAttribute("users");

    if (data == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/users");
        return;
    }

    List<Map<String, Object>> users =
        (List<Map<String, Object>>) data;
%>

<%
    String result = request.getParameter("result");
    String message = null;
    String messageColor = "#86efac";

    if ("deactivated".equals(result)) {
        message = "User account deactivated successfully.";
    } else if ("reactivated".equals(result)) {
        message = "User account reactivated successfully.";
    } else if ("deleted".equals(result)) {
        message = "User account permanently deleted.";
    } else if ("blocked".equals(result)) {
        message = "Deletion blocked. The user may own files or have audit history.";
        messageColor = "#fca5a5";
    } else if ("notfound".equals(result)) {
        message = "User not found or no changes were made.";
        messageColor = "#fca5a5";
    } else if ("self".equals(result)) {
        message = "You cannot manage your own account here.";
        messageColor = "#fca5a5";
    } else if ("invalid".equals(result)) {
        message = "Invalid user action or ID.";
        messageColor = "#fca5a5";
    } else if ("error".equals(result)) {
        message = "The operation failed. Check the server log.";
        messageColor = "#fca5a5";
    }
%>

<% if (message != null) { %>
    <div style="padding:14px; margin:15px 0;
                border-radius:8px; background:#111c2f;
                color:<%= messageColor %>;">
        <%= HtmlUtil.escape(message) %>
    </div>
<% } %>



<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - User Management</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <style>
        body { background:#0b1120; color:#f8fafc;
               font-family:Arial,sans-serif; padding:25px; }
        .panel { background:#111c2f; padding:22px;
                 border-radius:12px; overflow-x:auto; }
        table { width:100%; border-collapse:collapse; }
        th, td { padding:13px; text-align:left;
                 border-bottom:1px solid #334155; }
        th { color:#22d3ee; }
        .active { color:#86efac; }
        .inactive { color:#fca5a5; }
        .btn { padding:8px 12px; border:0; border-radius:6px;
               cursor:pointer; margin:3px; }
        .toggle { background:#164e63; color:white; }
        .danger { background:#991b1b; color:white; }
        a { color:#67e8f9; }
    </style>
</head>

<body>
    <h1>Admin User Management</h1>
    <p>View accounts and manage their access.</p>

    <p>
        <a href="<%= request.getContextPath() %>/dashboard.jsp">
            Back to Dashboard
        </a>
    </p>

    <div class="panel">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
            <% for (Map<String, Object> u : users) {
                int id = (Integer) u.get("id");
                String username = (String) u.get("username");
                String role = (String) u.get("role");
                boolean active = (Boolean) u.get("active");
            %>
                <tr>
                    <td><%= id %></td>
                    <td><%= HtmlUtil.escape(username) %></td>
                    <td><%= HtmlUtil.escape(role) %></td>
                    <td class="<%= active ? "active" : "inactive" %>">
                        <%= active ? "Active" : "Deactivated" %>
                    </td>
                    <td>
                        <form method="post"
                              action="<%= request.getContextPath() %>/admin/user-action"
                              style="display:inline">
                            <input type="hidden" name="id"
                                   value="<%= id %>">
                            <input type="hidden" name="action"
                                   value="<%= active ? "deactivate" : "reactivate" %>">
                            <button class="btn toggle" type="submit">
                                <%= active ? "Deactivate" : "Reactivate" %>
                            </button>
                        </form>

                        
                        <form method="post"
                              action="<%= request.getContextPath() %>/admin/user-action"
                              style="display:inline"
                              onsubmit="return confirm('Permanently delete this account? This cannot be undone.');">

                           <input type="hidden" name="id" value="<%= id %>">
                           <input type="hidden" name="action" value="delete">

                           <button class="btn danger" type="submit">
                               Permanently Delete
                           </button>
                        </form>

                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
