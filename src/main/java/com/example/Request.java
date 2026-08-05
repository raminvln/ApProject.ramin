package com.example;

import com.google.gson.JsonObject;


public class Request {
    private String method;
    private String username;
    private String route;
    private JsonObject payload;
    public String getMethod() {
        return method;
    }
    public void setMethod(String method) {
        this.method = method;
    }
    public String getusername() {
        return username;
    }
    public void setusername(String username) {
        this.username = username;
    }
    public String getRoute() {
        return route;
    }
    public void setRoute(String route) {
        this.route = route;
    }
    public JsonObject getPayload() {
        return payload;
    }
    public void setPayload(JsonObject payload) {
        this.payload = payload;
    }
}
