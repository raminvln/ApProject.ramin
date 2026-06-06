package com.example;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class User {
    private boolean isBanned = false;
    private String userName;
    private String password;
    private List<Picture> pictures = new ArrayList<>();
    private List<Album> albums = new ArrayList<>();

    public User(String name, String password) {
        this.userName = name;
        this.password = password;
    }

    public boolean isBanned() {
        return isBanned;
    }

    protected void setBanned(boolean isBanned) {
        this.isBanned = isBanned;
    }

    public String getUserName() {
        return userName;
    }

    // for changing username
    void setUserName(String name) {
        this.userName = name;
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
        if (picture.getOwner().equals(this) && !pictures.contains(picture)) {
            pictures.add(picture);
            picture.setTimeOfAdd(LocalDateTime.now());
        }
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
            destAlbum.addPicture(this, picture);
        }

    }

    public void moveImageToAnother(Picture picture, Album originAlbum, Album destAlbum) {
        if (!destAlbum.getPictures().contains(picture)) {
            copyImageToAlbum(picture, destAlbum);
        }
        originAlbum.getPictures().remove(picture);
        picture.getAlbums().remove(originAlbum);
    }

    public void likePicture(Picture picture) {
        picture.increaseLikes();
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((userName == null) ? 0 : userName.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        User other = (User) obj;
        if (userName == null) {
            if (other.userName != null)
                return false;
        } else if (!userName.equals(other.userName))
            return false;
        return true;
    }
}