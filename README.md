
# Secure File Transfer System

A Java web application for managing, uploading, downloading, and sharing files with authenticated users.

## Features
- User registration, login, and logout
- Password hashing with BCrypt
- File upload and download
- File sharing with VIEW and DOWNLOAD permissions
- User dashboard and file management
- Admin user management
- Account deactivation and reactivation
- MySQL database integration

## Technology Stack
- Java
- Jakarta Servlets and JSP
- JDBC
- MySQL 8
- Apache Tomcat 11
- HTML, CSS, Bootstrap

## Project Structure
- `src/main/java/com/sft/controller` — Servlets
- `src/main/java/com/sft/dao` — Database access
- `src/main/java/com/sft/filter` — Authentication filter
- `src/main/java/com/sft/model` — Model classes
- `src/main/java/com/sft/util` — Utility classes
- `src/main/webapp` — JSP pages and CSS

## Setup
1. Install JDK, Eclipse Enterprise Edition, MySQL, and Tomcat 11.
2. Create the `SecureFileDB` database and required tables.
3. Configure database credentials outside the published source code.
4. Configure the local file-storage directory.
5. Add the MySQL JDBC driver to the project.
6. Configure Tomcat in Eclipse and run the web application.

## Security Notes
Do not commit passwords, private configuration, or uploaded user files.
Verify that shared-file permissions are checked on the server for every request.
