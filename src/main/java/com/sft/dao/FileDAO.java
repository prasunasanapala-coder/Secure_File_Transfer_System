
package com.sft.dao;

import com.sft.model.FileRecord;
import com.sft.util.DBConnection;

import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FileDAO {

    public void addFile(String name, String key,
            int userId, long size) throws SQLException {

        String sql = "INSERT INTO files "
                + "(original_name, storage_key, uploaded_by, file_size) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, key);
            ps.setInt(3, userId);
            ps.setLong(4, size);
            ps.executeUpdate();
        }
    }

    public List<FileRecord> getFiles(int userId, boolean admin)
            throws SQLException {

        List<FileRecord> files = new ArrayList<>();

        String sql = "SELECT id, original_name, storage_key, "
                + "uploaded_by, file_size, uploaded_at FROM files "
                + (admin ? "" : "WHERE uploaded_by = ? ")
                + "ORDER BY uploaded_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (!admin) {
                ps.setInt(1, userId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    files.add(new FileRecord(
                        rs.getInt("id"),
                        rs.getString("original_name"),
                        rs.getString("storage_key"),
                        rs.getInt("uploaded_by"),
                        rs.getLong("file_size"),
                        rs.getTimestamp("uploaded_at")
                    ));
                }
            }
        }

        return files;
    }

    public FileRecord findById(int id) throws SQLException {
        String sql = "SELECT id, original_name, storage_key, "
                + "uploaded_by, file_size, uploaded_at "
                + "FROM files WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new FileRecord(
                        rs.getInt("id"),
                        rs.getString("original_name"),
                        rs.getString("storage_key"),
                        rs.getInt("uploaded_by"),
                        rs.getLong("file_size"),
                        rs.getTimestamp("uploaded_at")
                    );
                }
            }
        }

        return null;
    }




public boolean deleteFile(int id, int userId, boolean admin)
        throws SQLException {

    String checkSql = "SELECT uploaded_by FROM files WHERE id = ? FOR UPDATE";
    String deleteSharesSql = "DELETE FROM file_shares WHERE file_id = ?";
    String deleteFileSql = admin
            ? "DELETE FROM files WHERE id = ?"
            : "DELETE FROM files WHERE id = ? AND uploaded_by = ?";

    try (Connection con = DBConnection.getConnection()) {
        boolean oldAutoCommit = con.getAutoCommit();
        con.setAutoCommit(false);

        try {
            // 1. Verify the file exists and lock its database row.
            int ownerId;

            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                    ownerId = rs.getInt("uploaded_by");
                }
            }

            // 2. Allow only the owner or an admin to delete.
            if (!admin && ownerId != userId) {
                con.rollback();
                return false;
            }

            // 3. Delete sharing records referencing this file.
            try (PreparedStatement ps =
                         con.prepareStatement(deleteSharesSql)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // 4. Delete the file's database record.
            try (PreparedStatement ps =
                         con.prepareStatement(deleteFileSql)) {
                ps.setInt(1, id);

                if (!admin) {
                    ps.setInt(2, userId);
                }

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
            con.setAutoCommit(oldAutoCommit);
        }
    }
}
}
