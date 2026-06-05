package com.example;

import java.util.ArrayList;
import java.util.List;

public class User {
    private boolean isBanned = false;
    private String name;
    private String password;
    private List<Picture> pictures = new ArrayList<>();
    private List<Album> albums = new ArrayList<>();

    public User(String name, String password) {
        this.name = name;
        this.password = password;
    }

    public boolean isBanned() {
        return isBanned;
    }

    public void setBanned(boolean isBanned) {
        this.isBanned = isBanned;
    }

    public String getName() {
        return name;
    }

    // for changing username
    void setNAme(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    // for changing password
    void setPassword(String password) {
        this.password = password;
    }

    public List<Picture> getPictures() {
        return pictures;
    }

    public List<Album> getAlbums() {
        return albums;
    }

    public void addPicture(Picture picture) {
        pictures.add(picture);
    }

    public void addAlbum(Album album) {
        albums.add(album);
    }

    public void removePicture(Picture picture) {
        pictures.remove(picture);
    }

    public void removeAlbum(Album album) {
        albums.remove(album);
    }

    public void copyImageToAlbum(Picture picture, Album destAlbum) {
        if (!destAlbum.getPictures().contains(picture)) {
            destAlbum.getPictures().add(picture);
        }
    }

    public void transferImageToAnother(Picture picture, Album originAlbum, Album destAlbum) {
        if (!destAlbum.getPictures().contains(picture)) {
            copyImageToAlbum(picture, destAlbum);
        }
        originAlbum.getPictures().remove(picture);
    }
}