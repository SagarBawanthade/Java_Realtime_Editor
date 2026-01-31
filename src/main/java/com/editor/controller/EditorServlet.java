package com.editor.controller;

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

        if (user == null || sessionId == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/editor.jsp")
               .forward(request, response);
    }
}
