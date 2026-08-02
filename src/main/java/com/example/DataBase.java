package com.example;

import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.nio.file.Path;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


public class DataBase {

    public static void saveUserToFile(User user) throws IOException {
        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .setPrettyPrinting()
                .create();
        String json = gson.toJson(user);
        Files.writeString(Path.of("src/users/" + user.getUserName() + ".json"), json);
    }

    public static void deleteUserFile(User user) throws IOException {
        Files.deleteIfExists(
                Path.of("src/users/" + user.getUserName() + ".json"));
    }

    public static void loadUsersFromFile() throws IOException {

        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .setPrettyPrinting()
                .create();
        List<User> users = new ArrayList<>();

        Files.list(Path.of("src/users")).forEach(path -> {
            try {
                String json = Files.readString(path);
                User user = gson.fromJson(json, User.class);
                users.add(user);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
        UserManager.setUsers(users);
    }

}
