package com.example;


public class Admin extends User {


    public Admin(String name, String password) {
        super(name, password);
    }

    public static void addUser(User user) {
        if (!UserManager.getUsers().contains(user) && UserManager.isPasswordAllowed(user.getPassword())
                && UserManager.isUserNameAllowed(user.getUserName()))
            UserManager.getUsers().add(user);
    }
    
    public static void removeUser(User user) {
        UserManager.removeUser(user);
    }

    public void banUser(User user) {
        user.setBanned(true);
    }

    public void unBanUser(User user) {
        user.setBanned(false);
    }

    public void changeUserName(User user, String newName) {
        user.setUserName(newName);
    }

    public void changePassword(User user, String newPassword) {
        user.setPassword(newPassword);
    }
    public int pictureCount(User user) {
        return user.getPictures().size();
    }
    public int albumCount(User user) {
        return user.getAlbums().size();
    }
}