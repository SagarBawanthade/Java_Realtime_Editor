package com.editor.model;

public class SessionCode {

    private int sessionId;
    private String language;
    private String code;

    public SessionCode() {}

    public SessionCode(int sessionId, String language, String code) {
        this.sessionId = sessionId;
        this.language = language;
        this.code = code;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}
