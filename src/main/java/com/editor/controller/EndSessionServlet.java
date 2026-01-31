package com.editor.controller;

import com.editor.dao.SessionDAO;
import com.editor.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/endSession")
public class EndSessionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession httpSession = request.getSession();

            User user = (User) httpSession.getAttribute("user");
            Integer sessionId = (Integer) httpSession.getAttribute("sessionId");
            String role = (String) httpSession.getAttribute("role");

            if (user == null || sessionId == null) {
                response.sendRedirect("login");
                return;
            }

            // Only HOST can end session
            if (!"HOST".equals(role)) {
                response.sendRedirect("editor");
                return;
            }

            SessionDAO sessionDAO = new SessionDAO();
            sessionDAO.deleteSession(sessionId);

            // Clear session
            httpSession.removeAttribute("sessionId");
            httpSession.removeAttribute("sessionCode");
            httpSession.removeAttribute("role");

            response.sendRedirect("dashboard");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
