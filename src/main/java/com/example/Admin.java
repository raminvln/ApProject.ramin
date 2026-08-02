package com.example;

public class Admin extends User {

    public Admin(String diplayName, String name, String password) {
        super(diplayName, name, password);
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
            }
        }
    }

    public void changePassword(User user, String newPassword) {
        if (UserManager.isPasswordAllowed(newPassword)) {
            user.setPassword(newPassword);
        }
    }

    public int getPictureCount(User user) {
        return user.getPictures().size();
    }

    public int getAlbumCount(User user) {
        return user.getAlbums().size();
    }
}