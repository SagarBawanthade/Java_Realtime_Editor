package com.editor.dao;

import java.sql.*;

public class SessionCodeDAO {

    // CREATE DEFAULT CODE
    public void createDefaultCode(int sessionId) throws Exception {

        String code =
            "public class Main {\n" +
            "    public static void main(String[] args) {\n" +
            "        System.out.println(\"Hello from session\");\n" +
            "    }\n" +
            "}";

        String sql =
            "INSERT INTO session_code(session_id, language, code) VALUES (?, ?, ?)";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, sessionId);
        ps.setString(2, "java");
        ps.setString(3, code);

        ps.executeUpdate();

        ps.close();
        con.close();
    }

    // LOAD CODE
    public String getCode(int sessionId) throws Exception {

        String sql = "SELECT code FROM session_code WHERE session_id = ?";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, sessionId);
        ResultSet rs = ps.executeQuery();

        String code = "";
        if (rs.next()) {
            code = rs.getString("code");
        }

        rs.close();
        ps.close();
        con.close();

        return code;
    }

    // SAVE CODE
    public void updateCode(int sessionId, String code) throws Exception {

        String sql =
            "UPDATE session_code SET code = ?, updated_at = NOW() WHERE session_id = ?";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, code);
        ps.setInt(2, sessionId);

        ps.executeUpdate();

        ps.close();
        con.close();
    }
}
