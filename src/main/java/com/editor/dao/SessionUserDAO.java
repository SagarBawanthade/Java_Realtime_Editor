package com.editor.dao;

import java.sql.*;

public class SessionUserDAO {

    public void addUserToSession(int sessionId, int userId, String role)
            throws Exception {

        String sql =
            "INSERT INTO session_users(session_id, user_id, role) VALUES (?, ?, ?)";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, sessionId);
        ps.setInt(2, userId);
        ps.setString(3, role);

        ps.executeUpdate();

        ps.close();
        con.close();
    }
}
