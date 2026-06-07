package com.example;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class UserTest {
    User ali;
    User taghi;
    User admin;
    Picture p1;
    Picture p2;
    Picture p3;
    Picture p4;
    Picture p5;
    Picture p6;
    Picture p7;
    Picture p8;
    Picture p9;
    Picture p10;
    Album a1;
    Album a2;
    Album a3;
    Album a4;
    List<User> users;

    @BeforeEach
    public void initializeAndSomeAdd() {
        UserManager.getUsers().clear();
        ali = new User("AliAlavi@gmail.com", "abcdDEfg3456");
        taghi = new User("TaghiTaghavi@gmail.com", "hijkLmNoe345");
        admin = new Admin("AdiAdavi@gmail.com", "qrsTUV123");
        p1 = new Picture("pride.jpg", ali);
        p2 = new Picture("l90.jpg", ali);
        p3 = new Picture("roz.jpg", ali);
        p4 = new Picture("narges.jpg", ali);
        p5 = new Picture("laleh.jpg", ali);
        p6 = new Picture("peikan.jpg", taghi);
        p7 = new Picture("dena.jpg", taghi);
        p8 = new Picture("shahin.jpg", taghi);
        p9 = new Picture("meimoon.jpg", taghi);
        p10 = new Picture("yakh.jpg", taghi);
        a1 = new Album("mashin", ali);
        a2 = new Album("mashin", ali);
        a3 = new Album("gol", ali);
        a4 = new Album("gol", taghi);
        users = new ArrayList<>();
        UserManager.addUser(admin);
        UserManager.addUser(ali);
        UserManager.addUser(taghi);
        users.add(admin);
        users.add(ali);
        users.add(taghi);
    }
    @Test
    public void addPicture() {

    }

}
