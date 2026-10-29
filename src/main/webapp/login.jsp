
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | SecureVault</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 24px;
            background: radial-gradient(ellipse at top, #122b40 0%, #0b1120 65%);
        }

        .login-container {
            width: 100%;
            max-width: 440px;
        }

        .brand {
            text-align: center;
            color: #22d3ee;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: 1px;
            margin-bottom: 25px;
        }

        .login-card {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 18px;
            padding: 34px;
            box-shadow: 0 20px 60px #00000030;
        }

        .shield {
            width: 72px;
            height: 72px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 22px;
            font-size: 34px;
            border-radius: 20px;
            background: #22d3ee15;
            border: 1px solid #22d3ee50;
        }

        .eyebrow {
            color: #22d3ee;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        h1 {
            color: #e5edf7;
            font-size: 28px;
            font-weight: 700;
            margin: 10px 0;
        }

        .subtitle {
            color: #94a3b8;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 26px;
        }

        .field-label {
            display: block;
            color: #dbe7f5;
            font-size: 14px;
            font-weight: 600;
            margin: 18px 0 8px;
        }

        .field-input {
            width: 100%;
            padding: 12px 13px;
            background: #0b1525;
            color: #e5edf7;
            border: 1px solid #34445a;
            border-radius: 9px;
            outline: none;
        }

        .field-input:focus {
            border-color: #22d3ee;
            box-shadow: 0 0 0 3px #22d3ee20;
        }

        .field-input::placeholder {
            color: #64748b;
        }

        .login-btn {
            width: 100%;
            padding: 13px;
            margin-top: 25px;
            background: #22d3ee;
            color: #07111e;
            border: none;
            border-radius: 9px;
            font-weight: 700;
            cursor: pointer;
            transition: .2s;
        }

        .login-btn:hover {
            background: #a5f3fc;
            transform: translateY(-1px);
        }

        .error-message {
            padding: 12px;
            margin: 18px 0;
            border-radius: 9px;
            background: #f8717112;
            border: 1px solid #f8717150;
            color: #fca5a5;
            font-size: 14px;
        }

        .register-link {
            text-align: center;
            color: #94a3b8;
            font-size: 14px;
            margin-top: 24px;
        }

        .register-link a {
            color: #22d3ee;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            color: #a5f3fc;
        }

        .security-note {
            text-align: center;
            color: #64748b;
            font-size: 12px;
            margin-top: 22px;
        }

        @media (max-width: 480px) {
            .login-card {
                padding: 25px 20px;
            }
        }
    </style>
</head>

<body>

<div class="login-container">

    <div class="brand">🛡 SECUREVAULT</div>

    <main class="login-card">

        <div class="shield">🔐</div>

        <div class="text-center">
            <div class="eyebrow">SECURE FILE MANAGEMENT</div>
            <h1>Welcome Back</h1>
            <p class="subtitle">
                Sign in to access your secure workspace.
            </p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message" role="alert">
                ⚠ Invalid username or password. Please try again.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <label class="field-label" for="username">
                Username
            </label>

            <input class="field-input"
                   id="username"
                   type="text"
                   name="username"
                   placeholder="Enter your username"
                   autocomplete="username"
                   required>

            <label class="field-label" for="password">
                Password
            </label>

            <input class="field-input"
                   id="password"
                   type="password"
                   name="password"
                   placeholder="Enter your password"
                   autocomplete="current-password"
                   required>

            <button class="login-btn" type="submit">
                Sign In →
            </button>

        </form>

        <div class="register-link">
            Don't have an account?
            <a href="register.jsp">Create an account</a>
        </div>

    </main>

    <div class="security-note">
        🔒 SecureVault · Secure File Transfer System
    </div>

</div>

</body>
</html>
