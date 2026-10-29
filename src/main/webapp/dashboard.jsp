
<%@ page import="com.sft.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sft.util.HtmlUtil" %>
<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Secure File Transfer</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
        }

        .sidebar {
            background: #0e192a;
            border-right: 1px solid #29384d;
            min-height: 100vh;
            padding: 28px 18px;
        }

        .brand {
            color: #22d3ee;
            font-size: 21px;
            font-weight: 700;
            margin-bottom: 38px;
        }

        .nav-link-custom {
            display: block;
            color: #94a3b8;
            padding: 13px 15px;
            margin-bottom: 10px;
            border-radius: 9px;
            transition: 0.2s;
        }

        .nav-link-custom:hover,
        .nav-link-custom.active {
            background: #182b40;
            color: #22d3ee;
        }

        .main-content {
            padding: 35px;
        }

        .welcome-card {
            background: linear-gradient(120deg, #12253b, #102c37);
            border: 1px solid #235064;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 28px;
        }

        .welcome-card h1 {
            font-size: clamp(25px, 3vw, 34px);
            font-weight: 700;
        }

        .stat-card {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 14px;
            padding: 22px;
            height: 100%;
            transition: 0.2s;
        }

        .stat-card:hover {
            border-color: #22d3ee;
            transform: translateY(-3px);
        }

        .stat-icon {
            font-size: 28px;
            margin-bottom: 15px;
        }

        .action-card {
            display: block;
            text-decoration: none;
            color: #e5edf7;
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 14px;
            padding: 24px;
            height: 100%;
            transition: 0.2s;
        }

        .action-card:hover {
            border-color: #22d3ee;
            background: #14243a;
            color: #22d3ee;
            transform: translateY(-3px);
        }

        .action-card p {
            color: #94a3b8;
            margin-top: 10px;
            margin-bottom: 0;
        }

        .role-badge {
            display: inline-block;
            color: #22d3ee;
            background: #22d3ee18;
            border: 1px solid #22d3ee55;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        .logout-btn {
            width: 100%;
            border: 1px solid #f87171;
            background: transparent;
            color: #f87171;
            border-radius: 9px;
            padding: 11px;
            margin-top: 25px;
        }

        .logout-btn:hover {
            background: #f8717118;
        }

        @media (max-width: 767px) {
            .sidebar {
                min-height: auto;
                border-right: none;
                border-bottom: 1px solid #29384d;
            }

            .main-content {
                padding: 20px;
            }

            .brand {
                margin-bottom: 18px;
            }
        }
    </style>
</head>

<body>
<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <aside class="col-md-3 col-lg-2 sidebar">
            <div class="brand">🛡 SecureVault</div>

            <p class="muted small text-uppercase mb-3">Workspace</p>

            <a class="nav-link-custom active" href="dashboard.jsp">
                🏠 &nbsp; Dashboard
            </a>

            <a class="nav-link-custom" href="upload">
                ⬆️ &nbsp; Upload File
            </a>

            <a class="nav-link-custom" href="files">
                📁 &nbsp; My Files
            </a>

            <a class="nav-link-custom" href="shared-files">
                🔗 &nbsp; Shared With Me
            </a>

            <div class="mt-4 pt-3 border-top"
                 style="border-color:#29384d !important;">
                <p class="muted small mb-2">SIGNED IN AS</p>

                <div class="text-light fw-semibold text-break">
                    <%= HtmlUtil.escape(user.getUsername()) %>                </div>

                <div class="mt-2">
                    <span class="role-badge">
                        <%= HtmlUtil.escape(user.getRole()) %>
                    </span>
                </div>

                <form action="logout" method="post">
                    <button class="logout-btn" type="submit">
                        ↪ &nbsp; Logout
                    </button>
                </form>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">

            <div class="d-flex justify-content-between align-items-center
                        flex-wrap gap-3 mb-4">
                <div>
                    <p class="muted mb-1">SECURE FILE MANAGEMENT</p>
                    <h2 class="mb-0">Dashboard</h2>
                </div>

                <span class="badge-cyber">● System Workspace</span>
            </div>

            <!-- Welcome Banner -->
            <section class="welcome-card">
                <p style="color:#22d3ee; font-weight:600;">
                    YOUR SECURE WORKSPACE
                </p>

                <h1 style="color: #f8fafc;">
                    Welcome back,
                    <%= HtmlUtil.escape(user.getUsername()) %> 👋
                </h1>

                <p class="muted mt-3 mb-0">
                    Manage your files, share them with authorized users,
                    and access files shared with you.
                </p>
            </section>

            <!-- Overview Cards -->
            <h4 class="mb-3">Workspace Overview</h4>

            <div class="row g-3 mb-5">
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-icon">🔐</div>
                        <h5 style="color: #f8fafc;">Account Security</h5>
                        <p class="muted mb-0">
                            Signed-in session
                        </p>
                        <div class="mt-3">
                            <span class="role-badge">Authenticated</span>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-icon">📂</div>
                        <h5 style="color: #f8fafc;">My Files</h5>
                        <p class="muted mb-3">
                            Manage your uploaded files.
                        </p>
                        <a href="files">Open file manager →</a>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-icon">🤝</div>
                        <h5 style="color: #f8fafc;">Shared Files</h5>
                        <p class="muted mb-3">
                            Access files shared with you.
                        </p>
                        <a href="shared-files">View shared files →</a>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <h4 class="mb-3">Quick Actions</h4>

            <div class="row g-3">
                <div class="col-md-6 col-xl-4">
                    <a href="upload" class="action-card">
                        <div class="stat-icon">⬆️</div>
                        <h5>Upload a File</h5>
                        <p>
                            Add a file to your secure workspace.
                        </p>
                        <div class="mt-3">Get started →</div>
                    </a>
                </div>

                <div class="col-md-6 col-xl-4">
                    <a href="files" class="action-card">
                        <div class="stat-icon">🗂️</div>
                        <h5>Manage My Files</h5>
                        <p>
                            Browse your files and available actions.
                        </p>
                        <div class="mt-3">Open files →</div>
                    </a>
                </div>

                <div class="col-md-6 col-xl-4">
                    <a href="shared-files" class="action-card">
                        <div class="stat-icon">🔗</div>
                        <h5>Shared With Me</h5>
                        <p>
                            View files and permissions granted to you.
                        </p>
                        <div class="mt-3">Explore sharing →</div>
                    </a>
                </div>
                
               <% if ("ADMIN".equals(user.getRole())) { %>

                 <div class="col-md-6 col-xl-4">
                     <a href="<%= request.getContextPath() %>/admin/users"
                        class="action-card">

                        <div class="stat-icon">👥</div>

                        <h5>Manage User Accounts</h5>

                       <p>
                           View user accounts, deactivate or reactivate users,
                           and manage permanent deletion.
                       </p>

                       <div class="mt-3">Open user management →</div>
                   </a>
              </div>

         <% } %> 
                
                
            </div>

            <footer class="text-center muted mt-5 pt-3">
                SecureVault · Secure File Transfer System
            </footer>

        </main>
    </div>
</div>
</body>
</html>
