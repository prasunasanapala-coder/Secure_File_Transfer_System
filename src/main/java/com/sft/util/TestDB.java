
package com.sft.util;

import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection()) {
            System.out.println("MySQL connected successfully!");
            System.out.println("Database: "
                + con.getCatalog());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
