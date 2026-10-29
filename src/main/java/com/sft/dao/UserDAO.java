
package com.sft.dao;

import com.sft.model.User;
import com.sft.util.DBConnection;
import com.sft.util.PasswordUtil;
import java.sql.*;

public class UserDAO {

    public boolean register(String username, String password)
            throws SQLException {

        String sql = "INSERT INTO users "
                   + "(username, password_hash, role) "
                   + "VALUES (?, ?, 'USER')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, PasswordUtil.hash(password));

            return ps.executeUpdate() == 1;
        }
    }

    public User authenticate(String username, String password)
            throws SQLException {

        String sql = "SELECT id, username, password_hash, role "
                   + "FROM users WHERE username = ? AND active = TRUE";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && PasswordUtil.verify(
                        password, rs.getString("password_hash"))) {

                    return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("role")
                    );
                }
            }
        }
        return null;
    }
   

public boolean deactivateUser(int userId) throws SQLException {
    String sql =
        "UPDATE users SET active = FALSE WHERE id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);
        return ps.executeUpdate() == 1;
    }
}


public java.util.List<java.util.Map<String, Object>> getAllUsers()
        throws java.sql.SQLException {

    String sql =
        "SELECT id, username, role, active FROM users ORDER BY id";

    java.util.List<java.util.Map<String, Object>> users =
        new java.util.ArrayList<>();

    try (java.sql.Connection con =
             com.sft.util.DBConnection.getConnection();
         java.sql.PreparedStatement ps =
             con.prepareStatement(sql);
         java.sql.ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            java.util.Map<String, Object> user =
                new java.util.HashMap<>();

            user.put("id", rs.getInt("id"));
            user.put("username", rs.getString("username"));
            user.put("role", rs.getString("role"));
            user.put("active", rs.getBoolean("active"));

            users.add(user);
        }
    }

    return users;
}


public boolean reactivateUser(int userId) throws SQLException {
    String sql = "UPDATE users SET active = TRUE WHERE id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId);
        return ps.executeUpdate() == 1;
    }
}


public boolean permanentlyDeleteUser(int userId)
        throws SQLException {

    try (Connection con = DBConnection.getConnection()) {
        con.setAutoCommit(false);

        try {
            // Check whether the user exists.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id FROM users WHERE id = ? FOR UPDATE")) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                }
            }

            // Preserve files owned by this user.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM files WHERE uploaded_by = ?")) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new SQLException(
                            "Cannot permanently delete this user: " +
                            "the account still owns files. Transfer " +
                            "ownership or handle those files first."
                        );
                    }
                }
            }

            // Preserve audit history by refusing permanent deletion
            // when activity records reference this user.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM activity_logs WHERE user_id = ?")) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new SQLException(
                            "This account has activity history. " +
                            "Deactivate it to preserve the audit trail."
                        );
                    }
                }
            }

            // Remove shares received by this user.
            try (PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM file_shares WHERE shared_with_user_id = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            // Remove role assignments.
            try (PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM user_roles WHERE user_id = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            // Delete the account only after dependency checks.
            try (PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM users WHERE id = ?")) {
                ps.setInt(1, userId);

                if (ps.executeUpdate() != 1) {
                    con.rollback();
                    return false;
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }
    }
}



}
