package com.editor.controller;

import com.editor.dao.*;
import com.editor.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/joinSession")
public class JoinSessionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession httpSession = request.getSession();
            User user = (User) httpSession.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String sessionCode = request.getParameter("sessionCode");

            // 1️⃣ Find session
            SessionDAO sessionDAO = new SessionDAO();
            Integer sessionId = sessionDAO.findSessionIdByCode(sessionCode);

            if (sessionId == null) {
                response.sendRedirect("dashboard.jsp");
                return;
            }

            // 2️⃣ Add participant
            SessionUserDAO sessionUserDAO = new SessionUserDAO();
            sessionUserDAO.addUserToSession(sessionId, user.getId(), "PARTICIPANT");

            // 3️⃣ Save session info
            httpSession.setAttribute("sessionId", sessionId);
            httpSession.setAttribute("sessionCode", sessionCode);
            httpSession.setAttribute("role", "PARTICIPANT");

            // 4️⃣ Redirect to editor
            response.sendRedirect("editor");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
