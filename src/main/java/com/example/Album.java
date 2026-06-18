package com.example;

import java.io.IOException;
import java.util.*;

public class Album {
    private String name;
    private String ownerName;
    private List<Picture> pictures = new ArrayList<>();

    public Album(String name, String ownerName) {
        this.name = name;
        this.ownerName = ownerName;
    }

    public String getName() {
        return name;
    }

    public String getOwnerName() {
        return ownerName;
    }

    // for changing album name
    public void setName(String name) {
        this.name = name;
    }

    public List<Picture> getPictures() {
        return pictures;
    }

    public void addPicture(Picture picture)  {
        if (UserManager.getUsers().stream()
                .filter(user -> user.getUserName().equals(ownerName))
                .findFirst()
                .orElse(null)
                .getPictures()
                .contains(picture) && !pictures.contains(picture)
                && ownerName.equals(picture.getOwnerName())) {
            pictures.add(picture);
            picture.getAlbumsNames().add(name);
            try {
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void removePicture(Picture picture)  {
        if (pictures.contains(picture)) {
            pictures.remove(picture);
            picture.getAlbumsNames().remove(name);
            try {
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
