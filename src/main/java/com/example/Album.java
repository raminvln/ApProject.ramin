package com.example;

import java.util.*;

public class Album {
    private String name;
    private List<Picture> pictures = new ArrayList<>();

    public String getName() {
        return name;
    }

    // for changing album name
    public void setName(String name) {
        this.name = name;
    }

    public List<Picture> getPictures() {
        return pictures;
    }

    public void addPicture(User user, Picture picture) {
        if (user.getPictures().contains(picture) && !pictures.contains(picture)) {
            pictures.add(picture);
            picture.getAlbums().add(this);
        }
    }

    public void removePicture(Picture picture) {
        if (pictures.contains(picture)) {
            pictures.remove(picture);
            picture.getAlbums().remove(this);
        }
    }
}
