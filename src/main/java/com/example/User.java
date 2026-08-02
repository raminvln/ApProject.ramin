package com.example;

import java.io.IOException;
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
        if (!isBanned && picture.getOwnerName().equals(userName) && !pictures.contains(picture)) {
            pictures.add(picture);
            picture.setTimeOfAdd(LocalDateTime.now());
            try {
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void addAlbum(Album album) {
        if (!isBanned && album.getOwnerName().equals(userName) && !albums.contains(album)) {
            albums.add(album);
            try {
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void removePicture(Picture picture) {
        if (!isBanned) {
            pictures.remove(picture);
            try {
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void removeAlbum(Album album) {
        if (!isBanned) {
            albums.remove(album);
            try {
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void copyImageToAlbum(Picture picture, Album destAlbum)  {
        if (!isBanned && !destAlbum.getPictures().contains(picture.getName()) && destAlbum.getOwnerName().equals(userName)
                && picture.getOwnerName().equals(userName)) {
            try {
                destAlbum.addPicture(picture);
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    public void moveImageToAnother(Picture picture, Album originAlbum, Album destAlbum)  {
        if (!isBanned && !destAlbum.getPictures().contains(picture.getName()) && destAlbum.getOwnerName().equals(userName)
                && originAlbum.getOwnerName().equals(userName) && picture.getOwnerName().equals(userName)) {
            copyImageToAlbum(picture, destAlbum);
            try {
                originAlbum.removePicture(picture);
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
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