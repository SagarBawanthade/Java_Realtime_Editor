package com.editor.controller;

import com.editor.dao.SessionDAO;
import com.editor.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/editor")
public class EditorServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        Integer sessionId = (Integer) session.getAttribute("sessionId");

        // 1️⃣ User must be logged in and inside a session
        if (user == null || sessionId == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 2️⃣ Check if session still exists (HOST may have ended it)
            SessionDAO sessionDAO = new SessionDAO();
            if (!sessionDAO.sessionExists(sessionId)) {

                // Clean HTTP session
                session.removeAttribute("sessionId");
                session.removeAttribute("sessionCode");
                session.removeAttribute("role");

                // Redirect user safely
                response.sendRedirect("dashboard");
                return;
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        // 3️⃣ Everything is valid → show editor
        request.getRequestDispatcher("/WEB-INF/views/editor.jsp")
               .forward(request, response);
    }
}
