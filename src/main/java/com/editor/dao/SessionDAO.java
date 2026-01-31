package com.editor.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class SessionDAO {

    // CREATE SESSION (HOST)
    public int createSession(String sessionCode, int hostId) throws Exception {

        String sql = "INSERT INTO sessions(session_code, host_id) VALUES (?, ?)";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps =
                con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        ps.setString(1, sessionCode);
        ps.setInt(2, hostId);

        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        rs.next();
        int sessionId = rs.getInt(1);

        rs.close();
        ps.close();
        con.close();

        return sessionId;
    }

    // FIND SESSION BY SESSION CODE (JOIN)
    public Integer findSessionIdByCode(String sessionCode) throws Exception {

        String sql = "SELECT id FROM sessions WHERE session_code = ?";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, sessionCode);

        ResultSet rs = ps.executeQuery();

        Integer sessionId = null;
        if (rs.next()) {
            sessionId = rs.getInt("id");
        }

        rs.close();
        ps.close();
        con.close();

        return sessionId;
    }
}
