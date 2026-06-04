package com.example;

import java.util.ArrayList;
import java.util.List;

public class User {
    private boolean isBanned = false;
    private String name;
    private String pssword;
    private boolean isLoggedOut;
    private List<Picture> pictures = new ArrayList<>();
    private List<Album> albums = new ArrayList<>();

    public User(String name, String pssword, boolean isLoggedOut, List<Picture> pictures, List<Album> albums) {
        this.name = name;
        this.pssword = pssword;
        this.isLoggedOut = isLoggedOut;
        this.pictures = pictures;
        this.albums = albums;
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

    public void setName(String name) {
        this.name = name;
    }

    public String getPssword() {
        return pssword;
    }

    public void setPssword(String pssword) {
        this.pssword = pssword;
    }

    public boolean isLoggedOut() {
        return isLoggedOut;
    }

    public void setLoggedOut(boolean isLoggedOut) {
        this.isLoggedOut = isLoggedOut;
    }

    public List<Picture> getPictures() {
        return pictures;
    }

    public void setPictures(List<Picture> pictures) {
        this.pictures = pictures;
    }

    public List<Album> getAlbums() {
        return albums;
    }

    public void setAlbums(List<Album> albums) {
        this.albums = albums;
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
            List<Picture> list = destAlbum.getPictures();
            list.add(picture);
            destAlbum.setPictures(list);
        }
    }

    public void transferImageToAnother(Picture picture, Album originAlbum, Album destAlbum) {
        if (!destAlbum.getPictures().contains(picture)) {
            copyImageToAlbum(picture, destAlbum);
        }
        List<Picture> list = originAlbum.getPictures();
        list.remove(picture);
        originAlbum.setPictures(list);
    }
}