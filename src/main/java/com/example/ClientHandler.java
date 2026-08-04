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
                case "/pictures":
                    response = handlePictures(request);
                    break;
                case "/pictures/add":
                    response = handlePicturesAdd(request);
                    break;
                case "/pictures/delete":
                    response = handlePicturesDelete(request);
                    break;
                case "/pictures/favorite":
                    response = handlePicturesFavorite(request);
                    break;
                case "/albums":
                    response = handleAlbums(request);
                    break;
                case "/albums/create":
                    response = handleAlbumsCreate(request);
                    break;
                case "/albums/delete":
                    response = handleAlbumsDelete(request);
                    break;
                case "/albums/add-picture":
                    response = handleAlbumsAddPicture(request);
                    break;
                case "/albums/remove-picture":
                    response = handleAlbumsRemovePicture(request);
                    break;
                case "/albums/copy-picture":
                    response = handleAlbumsCopyPicture(request);
                    break;
                case "/albums/move-picture":
                    response = handleAlbumsMovePicture(request);
                    break;
                case "/profile":
                    response = handleAlbumsMovePicture(request);
                    break;
                case "/profile/update-displayname":
                    response = handleAlbumsMovePicture(request);
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

    /////////////////////
    /////////////////////
    // HANDLER METHODS //
    /////////////////////
    /////////////////////

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

    public Response handlePictures(Request request) {
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

    public Response handlePicturesAdd(Request request) {
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

    public Response handlePicturesDelete(Request request) {
        User user = findUser(request.getUserName());
        JsonObject payload = request.getPayload();
        Response response = new Response();
        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }
        String pictureName = payload.get("pictureName").getAsString();
        Picture picture = user.getPictures().stream().filter(pic -> pic.getName().equals(pictureName)).findFirst()
                .orElse(null);

        if (picture == null) {
            response.setStatusCode(404);
            response.setMessage("This picture dosn't exist");
            return response;
        }
        for (Album album : user.getAlbums()) {
            album.removePicture(picture);
        }
        user.getPictures().remove(picture);
        try {
            DataBase.saveUserToFile(user);
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
            return response;
        }
        response.setStatusCode(200);
        response.setMessage("The picture deleted successfully");
        return response;
    }

    public Response handlePicturesFavorite(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject payload = request.getPayload();
        String pictureName = payload.get("pictureName").getAsString();
        Picture picture = user.getPictures().stream().filter(pic -> pic.getName().equals(pictureName)).findFirst()
                .orElse(null);

        if (picture == null) {
            response.setStatusCode(404);
            response.setMessage("This picture dosn't exist");
            return response;
        }
        if (picture.isLikedByTheOwner()) {
            picture.setLikedByTheOwner(false);
            response.setStatusCode(200);
            response.setMessage("The picture unliked successflly");
        } else {
            picture.setLikedByTheOwner(true);
            response.setStatusCode(200);
            response.setMessage("The picutre liked succsessflly");
        }
        try {
            DataBase.saveUserToFile(user);
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
            return response;
        }
        return response;
    }

    public Response handleAlbums(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();
        JsonObject payload = new JsonObject();
        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }
        payload.add("albums", new Gson().toJsonTree(user.getAlbums()));
        response.setStatusCode(200);
        response.setMessage("albums are ready");
        response.setPayload(payload);
        return response;
    }

    public Response handleAlbumsCreate(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject payload = request.getPayload();
        String albumName = payload.get("name").getAsString();
        if (!user.getAlbums().stream().anyMatch(album -> album.getName().equals(albumName))) {
            Album album = new Album(albumName, user.getUserName());
            user.addAlbum(album);
            try {
                DataBase.saveUserToFile(user);
                response.setStatusCode(200);
                response.setMessage("album" + albumName + "created succsessflly");
            } catch (IOException e) {
                response.setStatusCode(500);
                response.setMessage("Fail to save");
            }
        } else {
            response.setStatusCode(409);
            response.setMessage("Album with this name already exists");
        }
        return response;
    }

    public Response handleAlbumsDelete(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }
        JsonObject payload = request.getPayload();
        String albumName = payload.get("albumName").getAsString();
        Album album = user.getAlbums().stream().filter(alb -> alb.getName().equals(albumName)).findFirst()
                .orElse(null);

        if (album == null) {
            response.setStatusCode(404);
            response.setMessage("This album dosn't exist");
            return response;
        }
        for (Picture picture : user.getPictures()) {
            picture.getAlbumsNames().remove(album.getName());
        }
        user.getAlbums().remove(album);
        try {
            DataBase.saveUserToFile(user);
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
            return response;
        }
        response.setStatusCode(200);
        response.setMessage("The album deleted successfully");
        return response;
    }

    public Response handleAlbumsAddPicture(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject payload = request.getPayload();
        String albumName = payload.get("albumName").getAsString();
        String pictureName = payload.get("pictureName").getAsString();

        Album album = user.getAlbums().stream()
                .filter(alb -> alb.getName().equals(albumName))
                .findFirst()
                .orElse(null);

        if (album == null) {
            response.setStatusCode(404);
            response.setMessage("Album not found");
            return response;
        }

        Picture picture = user.getPictures().stream()
                .filter(pic -> pic.getName().equals(pictureName))
                .findFirst()
                .orElse(null);

        if (picture == null) {
            response.setStatusCode(404);
            response.setMessage("Picture not found");
            return response;
        }
        album.addPicture(picture);
        try {
            DataBase.saveUserToFile(user);
            response.setStatusCode(200);
            response.setMessage("Picture added to album successfully");
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
        }
        return response;
    }

    public Response handleAlbumsRemovePicture(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject payload = request.getPayload();
        String albumName = payload.get("albumName").getAsString();
        String pictureName = payload.get("pictureName").getAsString();
        Album album = user.getAlbums().stream()
                .filter(alb -> alb.getName().equals(albumName))
                .findFirst()
                .orElse(null);

        if (album == null) {
            response.setStatusCode(404);
            response.setMessage("Album not found");
            return response;
        }

        Picture picture = user.getPictures().stream()
                .filter(pic -> pic.getName().equals(pictureName))
                .findFirst()
                .orElse(null);

        if (picture == null) {
            response.setStatusCode(404);
            response.setMessage("Picture not found");
            return response;
        }
        album.removePicture(picture);
        try {
            DataBase.saveUserToFile(user);
            response.setStatusCode(200);
            response.setMessage("Picture removed from album successfully");
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
        }
        return response;
    }

    public Response handleAlbumsCopyPicture(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject payload = request.getPayload();
        String fromAlbumName = payload.get("fromAlbum").getAsString();
        String toAlbumName = payload.get("toAlbum").getAsString();
        String pictureName = payload.get("pictureName").getAsString();

        Album fromAlbum = user.getAlbums().stream()
                .filter(alb -> alb.getName().equals(fromAlbumName))
                .findFirst()
                .orElse(null);
        if (fromAlbum == null) {
            response.setStatusCode(404);
            response.setMessage("Source album not found");
            return response;
        }
        Album toAlbum = user.getAlbums().stream()
                .filter(alb -> alb.getName().equals(toAlbumName))
                .findFirst()
                .orElse(null);
        if (toAlbum == null) {
            response.setStatusCode(404);
            response.setMessage("Destination album not found");
            return response;
        }
        Picture picture = user.getPictures().stream()
                .filter(pic -> pic.getName().equals(pictureName))
                .findFirst()
                .orElse(null);
        if (picture == null) {
            response.setStatusCode(404);
            response.setMessage("Picture not found");
            return response;
        }
        user.copyImageToAlbum(picture, toAlbum);
        try {
            DataBase.saveUserToFile(user);
            response.setStatusCode(200);
            response.setMessage("Picture copied to album successfully");
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
        }
        return response;
    }

    public Response handleAlbumsMovePicture(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject payload = request.getPayload();
        String fromAlbumName = payload.get("fromAlbum").getAsString();
        String toAlbumName = payload.get("toAlbum").getAsString();
        String pictureName = payload.get("pictureName").getAsString();

        Album fromAlbum = user.getAlbums().stream()
                .filter(alb -> alb.getName().equals(fromAlbumName))
                .findFirst()
                .orElse(null);

        if (fromAlbum == null) {
            response.setStatusCode(404);
            response.setMessage("Source album not found");
            return response;
        }

        Album toAlbum = user.getAlbums().stream()
                .filter(alb -> alb.getName().equals(toAlbumName))
                .findFirst()
                .orElse(null);

        if (toAlbum == null) {
            response.setStatusCode(404);
            response.setMessage("Destination album not found");
            return response;
        }

        Picture picture = user.getPictures().stream()
                .filter(pic -> pic.getName().equals(pictureName))
                .findFirst()
                .orElse(null);

        if (picture == null) {
            response.setStatusCode(404);
            response.setMessage("Picture not found");
            return response;
        }

        user.moveImageToAnother(picture, fromAlbum, toAlbum);

        try {
            DataBase.saveUserToFile(user);
            response.setStatusCode(200);
            response.setMessage("Picture moved to album successfully");
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
        }

        return response;
    }

    public Response handleProfile(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject data = new JsonObject();
        data.addProperty("displayName", user.getDisplayName());
        data.addProperty("userName", user.getUserName());
        data.addProperty("photoCount", user.getPictures().size());
        data.addProperty("albumCount", user.getAlbums().size());

        response.setStatusCode(200);
        response.setMessage("Profile loaded");
        response.setPayload(data);
        return response;
    }

    public Response handleProfileUpdateDisplayname(Request request) {
        User user = findUser(request.getUserName());
        Response response = new Response();

        if (user == null) {
            response.setStatusCode(404);
            response.setMessage("User not found");
            return response;
        }

        JsonObject payload = request.getPayload();
        String newDisplayName = payload.get("displayName").getAsString();

        user.setDisplayName(newDisplayName);

        try {
            DataBase.saveUserToFile(user);
            response.setStatusCode(200);
            response.setMessage("Display name updated");
        } catch (IOException e) {
            response.setStatusCode(500);
            response.setMessage("Failed to save");
        }

        return response;
    }

    public User findUser(String userName) {
        return UserManager.getUsers().stream().filter(user1 -> user1.getUserName().equals(userName))
                .findFirst().orElse(null);
    }

}