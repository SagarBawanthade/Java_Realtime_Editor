package com.editor.controller;

import com.editor.dao.UserDAO;
import com.editor.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.MessageDigest;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    // SHOW SIGNUP PAGE
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/signup.jsp")
               .forward(request, response);
    }

    // HANDLE SIGNUP
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!password.equals(confirmPassword)) {
                response.sendRedirect("signup");
                return;
            }

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());

            StringBuilder hashedPassword = new StringBuilder();
            for (byte b : hash) {
                hashedPassword.append(String.format("%02x", b));
            }

            User user = new User(username, email, hashedPassword.toString());
            new UserDAO().save(user);

            response.sendRedirect("login");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
