package com.editor.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
    "jdbc:mysql://127.0.0.1:3306/realtime_editor"
  + "?useSSL=false"
  + "&allowPublicKeyRetrieval=true"
  + "&serverTimezone=UTC";



    //private static final String URL = "jdbc:mysql://localhost:3306/realtime_editor";
    private static final String USER = "editor_user";
private static final String PASS = "30August2004";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
