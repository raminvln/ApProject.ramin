package com.example;

import java.util.*;

public class Album {
    List<Picture> pictures = new ArrayList<>();

    public Album(List<Picture> pictures) {
        this.pictures = pictures;
    }

    public List<Picture> getPictures() {
        return pictures;
    }

    public void setPictures(List<Picture> pictures) {
        this.pictures = pictures;
    }

    public void addPicture(Picture picture) {
        pictures.add(picture);
    }

    public void removePicture(Picture picture) {
        pictures.remove(picture);
    }
}
