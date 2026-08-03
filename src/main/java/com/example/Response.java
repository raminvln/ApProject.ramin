package com.example;

import com.google.gson.JsonObject;

public class Response {
    private int statusCode;
    private String message;
    private JsonObject payload;
    public int getStatusCode() {
        return statusCode;
    }
    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }
    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }
    public JsonObject getPayload() {
        return payload;
    }
    public void setPayload(JsonObject payload) {
        this.payload = payload;
    }
}
