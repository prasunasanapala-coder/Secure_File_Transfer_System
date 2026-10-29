
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sft.util.HtmlUtil" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | SecureVault</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: radial-gradient(ellipse at top, #122b40 0%, #0b1120 65%);
        }

        .register-container {
            width: 100%;
            max-width: 460px;
        }

        .brand {
            text-align: center;
            color: #22d3ee;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: 1px;
            margin-bottom: 25px;
        }

        .register-card {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 18px;
            padding: 34px;
            box-shadow: 0 20px 60px #00000030;
        }

        .register-icon {
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
            margin-bottom: 25px;
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

        .hint {
            color: #94a3b8;
            font-size: 12px;
            margin-top: 7px;
            line-height: 1.5;
        }

        .register-btn {
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

        .register-btn:hover {
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
            overflow-wrap: anywhere;
        }

        .login-link {
            text-align: center;
            color: #94a3b8;
            font-size: 14px;
            margin-top: 24px;
        }

        .login-link a {
            color: #22d3ee;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            color: #a5f3fc;
        }

        .security-note {
            text-align: center;
            color: #64748b;
            font-size: 12px;
            margin-top: 22px;
        }

        @media (max-width: 480px) {
            .register-card {
                padding: 25px 20px;
            }

            h1 {
                font-size: 25px;
            }
        }
    </style>
</head>

<body>

<div class="register-container">

    <div class="brand">🛡 SECUREVAULT</div>

    <main class="register-card">

        <div class="register-icon">👤</div>

        <div class="text-center">
            <div class="eyebrow">SECURE FILE MANAGEMENT</div>
            <h1>Create an Account</h1>
            <p class="subtitle">
                Register to access your secure file-sharing workspace.
            </p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message" role="alert">
                ⚠ <%= HtmlUtil.escape(
                    String.valueOf(request.getAttribute("error"))
                ) %>
            </div>
        <% } %>

        <form action="register" method="post">

            <label class="field-label" for="username">
                Username
            </label>

            <input class="field-input"
                   type="text"
                   id="username"
                   name="username"
                   placeholder="Choose a username"
                   autocomplete="username"
                   required
                   pattern="[A-Za-z0-9_]{3,50}"
                   minlength="3"
                   maxlength="50"
                   title="Use 3-50 letters, numbers, or underscores">

            <div class="hint">
                Use 3–50 letters, numbers, or underscores.
            </div>

            <label class="field-label" for="password">
                Password
            </label>

            <input class="field-input"
                   type="password"
                   id="password"
                   name="password"
                   placeholder="Create a password"
                   autocomplete="new-password"
                   required
                   maxlength="72"
                   title="Enter your password">

            <div class="hint">
                Choose a strong, unique password.
            </div>

            <button class="register-btn" type="submit">
                Create Account →
            </button>

        </form>

        <div class="login-link">
            Already registered?
            <a href="login.jsp">Sign in</a>
        </div>

    </main>

    <div class="security-note">
        🔒 SecureVault · Secure File Transfer System
    </div>

</div>

</body>
</html>
