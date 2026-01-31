package com.editor.controller;

import com.editor.dao.*;
import com.editor.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/createSession")
public class CreateSessionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1️⃣ Check login
            HttpSession httpSession = request.getSession();
            User user = (User) httpSession.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // 2️⃣ Generate session code
            String sessionCode = UUID.randomUUID()
                    .toString()
                    .substring(0, 6)
                    .toUpperCase();

            // 3️⃣ Create session
            SessionDAO sessionDAO = new SessionDAO();
            int sessionId = sessionDAO.createSession(sessionCode, user.getId());

            // 4️⃣ Add host to session_users
            SessionUserDAO sessionUserDAO = new SessionUserDAO();
            sessionUserDAO.addUserToSession(sessionId, user.getId(), "HOST");

            // 5️⃣ Create default Main.java
            SessionCodeDAO codeDAO = new SessionCodeDAO();
            codeDAO.createDefaultCode(sessionId);

            // 6️⃣ Save session info in HTTP session
            httpSession.setAttribute("sessionId", sessionId);
            httpSession.setAttribute("sessionCode", sessionCode);

            // 7️⃣ Redirect to editor
            response.sendRedirect("editor");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
