package com.example;

import java.io.IOException;

public class Admin extends User {

    public Admin(String name, String password) {
        super(name, password);
    }

    public void banUser(User user) {
        user.setBanned(true);
    }

    public void unBanUser(User user) {
        user.setBanned(false);
    }

    public void changeUserName(User user, String newName) {
        if (UserManager.isUserNameAllowed(newName)) {
            if (!UserManager.userNameExists(newName)) {
                user.setUserName(newName);
                try {
                    DataBase.saveUsersToFile();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public void changePassword(User user, String newPassword) {
        if (UserManager.isPasswordAllowed(newPassword)){
            user.setPassword(newPassword);
            try {
                DataBase.saveUsersToFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public int getPictureCount(User user) {
        return user.getPictures().size();
    }

    public int getAlbumCount(User user) {
        return user.getAlbums().size();
    }
}