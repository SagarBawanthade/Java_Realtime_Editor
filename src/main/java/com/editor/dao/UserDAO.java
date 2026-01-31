package com.editor.dao;

import com.editor.model.User;
import java.sql.*;

public class UserDAO {

    // CREATE USER (SIGN UP)
    public void save(User user) throws Exception {

        String sql = "INSERT INTO users(username, email, password_hash) VALUES (?, ?, ?)";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, user.getUsername());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPasswordHash());

        ps.executeUpdate();

        ps.close();
        con.close();
    }

    // FIND USER BY EMAIL (LOGIN)
    public User findByEmail(String email) throws Exception {

        String sql = "SELECT * FROM users WHERE email = ?";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, email);

        ResultSet rs = ps.executeQuery();

        User user = null;

        if (rs.next()) {
            user = new User();
            user.setId(rs.getInt("id"));
            user.setUsername(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setPasswordHash(rs.getString("password_hash"));
        }

        rs.close();
        ps.close();
        con.close();

        return user;
    }
}
