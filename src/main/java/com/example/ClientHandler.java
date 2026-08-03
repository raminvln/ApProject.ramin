package com.example;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

public class ClientHandler implements Runnable {
    private Socket socket;

    public ClientHandler(Socket socket) {
        this.socket = socket;
    }

    @Override
    public void run() {
        try {
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            StringBuilder json = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null && !line.isEmpty()) {
                json.append(line);
            }
            String jsonString = json.toString();
            Gson gson = new Gson();
            Request request = gson.fromJson(jsonString, Request.class);
            Response response = new Response();

            String responString = gson.toJson(response);
            out.println(responString);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // handler methods
    public Response handleLogin(Request request) {
        Response response = new Response();
        User user = null;
        JsonObject payload = request.getPayload();
        String userName = payload.get("userName").getAsString();
        String password = payload.get("password").getAsString();
        for (User sampleUser : UserManager.getUsers()) {
            if (sampleUser.getUserName().equals(userName)) {
                user = sampleUser;
            }
        }
        if (user == null) {
            response.setStatusCode(401);
            response.setMessage("User with username " + userName + "not found");
            return response;
        }
        if (user.isBanned()) {
            response.setStatusCode(403);
            response.setMessage("User" + userName + "is banned");
            return response;
        }

        if (!user.getPassword().equals(password)) {
            response.setStatusCode(401);
            response.setMessage("Invalid password");
            return response;
        }
        JsonObject data = new JsonObject();
        data.addProperty("displayName", user.getDisplayName());
        data.addProperty("photoCount", user.getPictures().size());
        data.addProperty("albumCount", user.getAlbums().size());
        response.setStatusCode(200);
        response.setMessage("Login successful");
        response.setPayload(data);
        return response;
    }

}
