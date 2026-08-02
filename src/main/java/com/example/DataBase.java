package com.example;

import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.util.List;
import java.nio.file.Path;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.lang.reflect.Type;
import com.google.gson.reflect.TypeToken;


public class DataBase {
    
    public static void saveUsersToFile() throws IOException {
        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .setPrettyPrinting()
                .create();
        String json = gson.toJson(UserManager.getUsers());
        Files.writeString(Path.of("users.json"), json);
    }

    public static void loadUsersFromFile()throws IOException{
        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .setPrettyPrinting()
                .create();
        String json = Files.readString(Path.of("users.json"));
        Type lisType = new TypeToken<List<User>>() {} .getType();
        UserManager.setUsers(gson.fromJson(json,lisType));
    }
}
