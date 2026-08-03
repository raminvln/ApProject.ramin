package com.example;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class UserManager {
    private static List<User> users = new ArrayList<>();
    private static String photPattern = "^0[0-9]{10}$";
    private static String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$";

    private UserManager() {
    }

    public static synchronized void addUser(User user) {
        if (!users.contains(user) && isPasswordAllowed(user.getPassword()) && isUserNameAllowed(user.getUserName())) {
            users.add(user);
            try {
                DataBase.saveUserToFile(user);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static synchronized void removeUser(User user)  {
        users.remove(user);
        try {
            DataBase.deleteUserFile(user);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static synchronized boolean isPasswordAllowed(String password) {
        if (password.matches(passwordPattern))
            return true;
        return false;
    }

    public static synchronized boolean isUserNameAllowed(String userName) {
        if (userName.matches(emailPattern) || userName.matches(photPattern))
            return true;
        return false;
    }

    public synchronized static List<User> getUsers() {
        return users;
    }
    public synchronized static void setUsers(List<User> users2) {
        users = users2;
    }
    public synchronized static boolean userNameExists(String userName) {
        for (User user : users) {
            if (userName.equals(user.getUserName())) {
                return true;
            }
        }
        return false;
    } 
}
