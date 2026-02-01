package com.editor.websocket;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import com.editor.dao.SessionCodeDAO;

@ServerEndpoint("/ws/editor/{sessionCode}")
public class CodeEditorSocket {

    private static final ConcurrentHashMap<String, Set<Session>> SESSION_USERS =
            new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session,
                       @PathParam("sessionCode") String sessionCode) {

        SESSION_USERS
            .computeIfAbsent(sessionCode, k -> ConcurrentHashMap.newKeySet())
            .add(session);

        System.out.println("WS CONNECTED: " + sessionCode);
    }

    @OnMessage
    public void onMessage(String code,
                          @PathParam("sessionCode") String sessionCode) {

        new SessionCodeDAO().updateCodeBySessionCode(sessionCode, code);

        Set<Session> users = SESSION_USERS.get(sessionCode);
        if (users == null) return;

        for (Session s : users) {
            if (s.isOpen()) {
                s.getAsyncRemote().sendText(code);
            }
        }
    }

    @OnClose
    public void onClose(Session session,
                        @PathParam("sessionCode") String sessionCode) {

        Set<Session> users = SESSION_USERS.get(sessionCode);
        if (users != null) {
            users.remove(session);
        }

        System.out.println("WS DISCONNECTED: " + sessionCode);
    }
}
