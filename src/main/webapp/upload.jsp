
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload File | SecureVault</title>

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
            background:
                radial-gradient(ellipse at top, #122b40 0%, #0b1120 60%);
        }

        .upload-container {
            width: 100%;
            max-width: 650px;
        }

        .brand {
            text-align: center;
            color: #22d3ee;
            font-weight: 700;
            font-size: 18px;
            letter-spacing: 1px;
            margin-bottom: 24px;
        }

        .upload-card {
            background: #111c2f;
            border: 1px solid #29384d;
            border-radius: 20px;
            padding: 35px;
            box-shadow: 0 20px 60px #00000030;
        }

        .upload-icon {
            width: 76px;
            height: 76px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 35px;
            background: #22d3ee15;
            border: 1px solid #22d3ee55;
            border-radius: 20px;
        }

        .eyebrow {
            color: #22d3ee;
            font-size: 12px;
            letter-spacing: 2px;
            font-weight: 700;
        }

        .upload-card h1 {
            font-size: 29px;
            font-weight: 700;
            margin: 10px 0;
        }

        .subtitle {
            color: #94a3b8;
            line-height: 1.6;
        }

        .drop-area {
            margin: 28px 0 18px;
            padding: 30px 18px;
            text-align: center;
            border: 2px dashed #36516a;
            border-radius: 14px;
            background: #0b1525;
            transition: border-color 0.2s, background 0.2s;
        }

        .drop-area:focus-within,
        .drop-area:hover {
            border-color: #22d3ee;
            background: #102033;
        }

        .file-input {
            display: block;
            width: 100%;
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #29384d;
            border-radius: 9px;
            color: #cbd5e1;
            background: #111c2f;
        }

        .file-input::file-selector-button {
            background: #22d3ee;
            color: #07111e;
            border: none;
            border-radius: 6px;
            padding: 8px 12px;
            margin-right: 12px;
            cursor: pointer;
        }

        .file-info {
            color: #94a3b8;
            font-size: 13px;
            margin-top: 12px;
            overflow-wrap: anywhere;
        }

        .upload-btn {
            width: 100%;
            border: none;
            border-radius: 9px;
            padding: 13px;
            background: #22d3ee;
            color: #07111e;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        .upload-btn:hover {
            background: #a5f3fc;
            transform: translateY(-1px);
        }

        .security-note {
            background: #22c55e10;
            border: 1px solid #22c55e35;
            color: #86efac;
            border-radius: 10px;
            padding: 13px;
            font-size: 13px;
            margin-top: 22px;
        }

        .navigation {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 22px;
            margin-top: 24px;
        }

        .navigation a {
            color: #22d3ee;
            text-decoration: none;
            font-size: 14px;
        }

        .navigation a:hover {
            color: #a5f3fc;
        }

        @media (max-width: 480px) {
            .upload-card {
                padding: 24px 18px;
            }

            .upload-card h1 {
                font-size: 25px;
            }
        }
    </style>
</head>

<body>

<div class="upload-container">

    <div class="brand">🛡 SECUREVAULT</div>

    <main class="upload-card">

        <div class="text-center">
            <div class="upload-icon">⬆️</div>

            <div class="eyebrow">SECURE FILE MANAGEMENT</div>

            <h1>Upload a File</h1>

            <p class="subtitle">
                Add a file to your workspace and manage it securely.
            </p>
        </div>

        <form action="upload" method="post"
              enctype="multipart/form-data">

            <div class="drop-area">
                <div style="font-size:28px;">📁</div>

                <h5 class="mt-3">Choose a file to upload</h5>

                <p class="subtitle small mb-0">
                    Select a file from your device.
                </p>

                <input class="file-input"
                       type="file"
                       id="file"
                       name="file"
                       required>

                <div class="file-info" id="fileInfo">
                    No file selected
                </div>
            </div>

            <div class="d-flex justify-content-between
                        align-items-center mb-3">
                <span class="subtitle small">Maximum file size</span>
                <strong style="color:#22d3ee;">10 MB</strong>
            </div>

            <button class="upload-btn" type="submit">
                ⬆ Upload File
            </button>

        </form>

        <div class="security-note">
            🔐 <strong>Secure workspace</strong><br>
            Your application stores uploaded files outside the public web directory.
        </div>

    </main>

    <nav class="navigation">
        <a href="dashboard.jsp">← Dashboard</a>
        <a href="files">📁 My Files</a>
        <a href="shared-files">🔗 Shared With Me</a>
    </nav>

</div>

<script>
    const fileInput = document.getElementById("file");
    const fileInfo = document.getElementById("fileInfo");

    fileInput.addEventListener("change", function () {
        if (this.files.length > 0) {
            const file = this.files[0];
            const sizeMB = (file.size / (1024 * 1024)).toFixed(2);

            fileInfo.textContent =
                file.name + " · " + sizeMB + " MB";
        } else {
            fileInfo.textContent = "No file selected";
        }
    });
</script>

</body>
</html>
