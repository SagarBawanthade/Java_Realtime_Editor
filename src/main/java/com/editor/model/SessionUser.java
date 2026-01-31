package com.editor.model;

public class SessionUser {

    private int sessionId;
    private int userId;
    private String role; // HOST or PARTICIPANT

    public SessionUser() {}

    public SessionUser(int sessionId, int userId, String role) {
        this.sessionId = sessionId;
        this.userId = userId;
        this.role = role;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
