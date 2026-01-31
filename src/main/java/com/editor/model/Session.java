package com.editor.model;

public class Session {

    private int id;
    private String sessionCode;
    private int hostId;

    public Session() {}

    public Session(String sessionCode, int hostId) {
        this.sessionCode = sessionCode;
        this.hostId = hostId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSessionCode() {
        return sessionCode;
    }

    public void setSessionCode(String sessionCode) {
        this.sessionCode = sessionCode;
    }

    public int getHostId() {
        return hostId;
    }

    public void setHostId(int hostId) {
        this.hostId = hostId;
    }
}
