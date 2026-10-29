
package com.sft.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC Driver not found. Check WEB-INF/lib.", e
            );
        }

        String url = System.getenv("SFT_DB_URL");
        String user = System.getenv("SFT_DB_USER");
        String password = System.getenv("SFT_DB_PASSWORD");

        if (url == null || user == null || password == null) {
            throw new SQLException(
                "Database configuration missing. Set SFT_DB_URL, " +
                "SFT_DB_USER, and SFT_DB_PASSWORD."
            );
        }

        return DriverManager.getConnection(url, user, password);
    }

    public static void main(String[] args) {
        try (Connection connection = getConnection()) {
            System.out.println("MySQL connected successfully!");
            System.out.println("Database: " + connection.getCatalog());
        } catch (SQLException e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}
