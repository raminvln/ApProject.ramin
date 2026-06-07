package com.example;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class User {
    private String userName;
    private String password;
    private List<Picture> pictures = new ArrayList<>();
    private List<Album> albums = new ArrayList<>();
    private boolean isBanned = false;

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
    public void setUserName(String name) {
        this.userName = name;
    }

    public String getPassword() {
        return password;
    }

    // for changing password
    public void setPassword(String password) {
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
        if (album.getOwner().equals(this) && !albums.contains(album)) {
            albums.add(album);
        }
    }

    public void removePicture(Picture picture) {
        pictures.remove(picture);
    }

    public void removeAlbum(Album album) {
        albums.remove(album);
    }

    public void copyImageToAlbum(Picture picture, Album destAlbum) {
        if (!destAlbum.getPictures().contains(picture) && destAlbum.getOwner().equals(this)
                && picture.getOwner().equals(this)) {
            destAlbum.addPicture(picture);
        }

    }

    public void moveImageToAnother(Picture picture, Album originAlbum, Album destAlbum) {
        if (!destAlbum.getPictures().contains(picture) && destAlbum.getOwner().equals(this)
                && originAlbum.getOwner().equals(this) && picture.getOwner().equals(this)) {
            copyImageToAlbum(picture, destAlbum);
            originAlbum.removePicture(picture);
            picture.getAlbums().remove(originAlbum);
        }
    }

    public void likePicture(Picture picture) {
        if (picture.isPublic()) {
            picture.increaseLikes(this);
        }
    }

    public void unLikePicture(Picture picture) {
        picture.decreasLikes(this);
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

    @Override
    public String toString() {
        return "User [userName=" + userName + ", password=" + password + "]";
    }
}