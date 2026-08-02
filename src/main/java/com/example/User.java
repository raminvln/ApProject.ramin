package com.example;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class User {
    private String displayName;
    private String userName;
    private String password;
    private List<Picture> pictures = new ArrayList<>();
    private List<Album> albums = new ArrayList<>();
    private boolean isBanned = false;

    public User(String displayName, String name, String password) {
        this.displayName = displayName;
        this.userName = name;
        this.password = password;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
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
        if (!isBanned && picture.getOwnerName().equals(userName) && !pictures.contains(picture)) {
            pictures.add(picture);
            picture.setTimeOfAdd(LocalDateTime.now());
        }
    }

    public void addAlbum(Album album) {
        if (!isBanned && album.getOwnerName().equals(userName) && !albums.contains(album)) {
            albums.add(album);
        }
    }

    public void removePicture(Picture picture) {
        if (!isBanned) {
            pictures.remove(picture);
        }
    }

    public void removeAlbum(Album album) {
        if (!isBanned) {
            albums.remove(album);
        }
    }

    public void copyImageToAlbum(Picture picture, Album destAlbum) {
        if (!isBanned && !destAlbum.getPictures().contains(picture.getName())
                && destAlbum.getOwnerName().equals(userName)
                && picture.getOwnerName().equals(userName)) {
            destAlbum.addPicture(picture);
        }

    }

    public void moveImageToAnother(Picture picture, Album originAlbum, Album destAlbum) {
        if (!isBanned && !destAlbum.getPictures().contains(picture.getName())
                && destAlbum.getOwnerName().equals(userName)
                && originAlbum.getOwnerName().equals(userName) && picture.getOwnerName().equals(userName)) {
            copyImageToAlbum(picture, destAlbum);
            originAlbum.removePicture(picture);
            picture.getAlbumsNames().remove(originAlbum.getName());
        }
    }

    // این دو تا فعلا سیو ندارن
    public void changeUserName(String newName) {
        if (!isBanned && UserManager.isUserNameAllowed(newName)) {
            if (!UserManager.userNameExists(newName)) {
                userName = newName;
            }
        }
    }

    public void changePassword(String newPassword) {
        if (!isBanned && UserManager.isPasswordAllowed(newPassword))
            password = newPassword;
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