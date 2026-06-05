package com.example;

import java.util.*;

public class Admin extends User{
    List<User> users = new ArrayList<>();
    public Admin(String name, String password) {
        super(name, password);
    }
}
