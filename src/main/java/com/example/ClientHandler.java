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
            switch (request.getRoute()) {

                case "/login":
                    response = handleLogin(request);
                    break;
                case "/register":
                    response = handleRegister(request);
                    break;
                case "/photos":
                    response = handlePhotos(request);
                    break;
                case "/photos/add":
                    response = handlePhotosAdd(request);
                    break;
                default:
                    response.setStatusCode(404);
                    response.setMessage("Route not found");
                    break;
            }
            String responString = gson.toJson(response);
            out.println(responString);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // handler methods
    public Response handleLogin(Request request) {
        Response response = new Response();
        JsonObject payload = request.getPayload();
        User user = findUser(payload.get("userName").getAsString());
        String userName = payload.get("userName").getAsString();
        String password = payload.get("password").getAsString();

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

    public Response handleRegister(Request request) {
        Response response = new Response();
        JsonObject payload = request.getPayload();
        String displayName = payload.get("displayName").getAsString();
        String userName = payload.get("userName").getAsString();
        String password = payload.get("password").getAsString();
        User user = new User(displayName, userName, password);
        switch (UserManager.addUser(user)) {
            case "added":
                response.setStatusCode(200);
                response.setMessage("Account with username " + user.getUserName() + "signed up successfully.");
                break;
            case "badpassword":
                response.setStatusCode(400);
                response.setMessage("password is not allowed");
                break;
            case "badusername":
                response.setStatusCode(400);
                response.setMessage("username is not allowed");
                break;
            case "alreadyhaveaccount":
                response.setStatusCode(409);
                response.setMessage("this username(email or phonenumbder) already exists");
                break;
            default:
                break;
        }
        return response;
    }

    public Response handlePhotos(Request request) {
        Response response = new Response();
        User user = findUser(request.getUserName());
        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }
        JsonObject payload = new JsonObject();
        payload.add("pictures", new Gson().toJsonTree(user.getPictures()));
        response.setPayload(payload);
        response.setMessage("pictures are ready");
        response.setStatusCode(200);
        return response;
    }

    public Response handlePhotosAdd(Request request) {
        User user = findUser(request.getUserName());
        if (user == null) {
            Response response = new Response();
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }
        JsonObject payload = request.getPayload();
        Picture picture = new Picture(payload.get("name").getAsString(), payload.get("ownerName").getAsString());
        if (payload.has("caption"))
            picture.setCaption(payload.get("caption").getAsString());
        if (payload.has("albumNames")) {
            picture.setAlbumNames(payload.getAsJsonArray("albumNames")
                    .asList()
                    .stream()
                    .map(jsonElement -> jsonElement.getAsString())
                    .toList());
        }
        if (payload.has("peopleInPicture")) {
            picture.setPeopleInPicture(payload.getAsJsonArray("peopleInPicture")
                    .asList()
                    .stream()
                    .map(jsonElement -> jsonElement.getAsString())
                    .toList());
        }
        if (payload.has("tags")) {
            picture.setTags(payload.getAsJsonArray("tags")
                    .asList()
                    .stream()
                    .map(jsonElement -> jsonElement.getAsString())
                    .toList());
        }

        user.addPicture(picture);
        Response response = new Response();
        try {
            DataBase.saveUserToFile(user);
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
            return response;
        }
        response.setStatusCode(200);
        response.setMessage("picture added successfully");
        return response;
    }

    public User findUser(String userName) {
        return UserManager.getUsers().stream().filter(user1 -> user1.getUserName().equals(userName))
                .findFirst().orElse(null);
    }

}