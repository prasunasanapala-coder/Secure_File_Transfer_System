
package com.sft.dao;

import com.sft.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ShareDAO {

    // Create or update a recipient's permission for a file.
    public boolean shareFile(int fileId, int ownerId,
                             int recipientId, String permission)
            throws SQLException {

        if (!"VIEW".equals(permission)
                && !"DOWNLOAD".equals(permission)) {
            return false;
        }

        String ownerSql =
            "SELECT id FROM files WHERE id=? AND uploaded_by=?";

        String deleteSql =
            "DELETE FROM file_shares WHERE file_id=? AND shared_with_user_id=?";

        String insertSql = """
            INSERT INTO file_shares
                (file_id, shared_with_user_id, permission_id)
            SELECT ?, ?, permission_id
            FROM permissions
            WHERE permission_name = ?
            """;

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            try {
                // Verify ownership before changing existing permissions.
                try (PreparedStatement ps = con.prepareStatement(ownerSql)) {
                    ps.setInt(1, fileId);
                    ps.setInt(2, ownerId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }
                    }
                }

                // Replace the recipient's previous permission.
                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setInt(1, fileId);
                    ps.setInt(2, recipientId);
                    ps.executeUpdate();
                }

                int inserted;
                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setInt(1, fileId);
                    ps.setInt(2, recipientId);
                    ps.setString(3, permission);
                    inserted = ps.executeUpdate();
                }

                if (inserted != 1) {
                    con.rollback();
                    return false;
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

    public boolean hasPermission(int fileId, int userId,
                                 String permission)
            throws SQLException {

        String sql = """
            SELECT 1
            FROM file_shares
            WHERE file_id = ?
              AND shared_with_user_id = ?
              AND permission_id = (
                  SELECT permission_id
                  FROM permissions
                  WHERE permission_name = ?
              )
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, fileId);
            ps.setInt(2, userId);
            ps.setString(3, permission);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Map<String, Object>> getSharedFiles(int userId)
            throws SQLException {

        String sql = """
            SELECT f.id, f.original_name, f.file_size,
                   u.username AS owner_name,
                   p.permission_name
            FROM file_shares s
            JOIN files f ON f.id = s.file_id
            JOIN users u ON u.id = f.uploaded_by
            JOIN permissions p
              ON p.permission_id = s.permission_id
            WHERE s.shared_with_user_id = ?
            ORDER BY s.shared_at DESC
            """;

        List<Map<String, Object>> result = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("name", rs.getString("original_name"));
                    row.put("size", rs.getLong("file_size"));
                    row.put("owner", rs.getString("owner_name"));
                    row.put("permission",
                            rs.getString("permission_name"));
                    result.add(row);
                }
            }
        }

        return result;
    }
}
