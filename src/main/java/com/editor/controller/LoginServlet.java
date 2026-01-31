package com.editor.controller;

import com.editor.dao.UserDAO;
import com.editor.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.MessageDigest;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // SHOW LOGIN PAGE
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }

    // HANDLE LOGIN
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());

            StringBuilder hashedPassword = new StringBuilder();
            for (byte b : hash) {
                hashedPassword.append(String.format("%02x", b));
            }

            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);

            if (user != null && user.getPasswordHash().equals(hashedPassword.toString())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect("dashboard");
            } else {
                response.sendRedirect("login");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
