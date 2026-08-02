package com.example;

import java.util.*;

public class Album {
    private String name;
    private String ownerName;
    private List<String> pictureNames = new ArrayList<>();

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

    public List<String> getPictures() {
        return pictureNames;
    }

    public void addPicture(Picture picture)  {
        if (UserManager.getUsers().stream()
                .filter(user -> user.getUserName().equals(ownerName))
                .findFirst()
                .orElse(null)
                .getPictures()
                .contains(picture) && !pictureNames.contains(picture.getName())
                && ownerName.equals(picture.getOwnerName())) {
            pictureNames.add(picture.getName());
            picture.getAlbumsNames().add(name);
        }
    }

    public void removePicture(Picture picture)  {
        if (pictureNames.contains(picture.getName())) {
            pictureNames.remove(picture.getName());
            picture.getAlbumsNames().remove(name);
        }
    }
}
