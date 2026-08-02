package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class PictureTest {
    User ali;
    User taghi;
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
    Picture p11;
    Album a1;
    Album a2;
    Album a3;
    Album a4;
    List<User> users;

    @BeforeEach
    public void initializeAndSomeAdd() {
        UserManager.getUsers().clear();
        ali = new User("ali","AliAlavi@gmail.com", "abcdDEfg3456");
        taghi = new User("taghi","TaghiTaghavi@gmail.com", "hijkLmNoe345");
        p1 = new Picture("pride.jpg", ali.getUserName());
        p2 = new Picture("l90.jpg", ali.getUserName());
        p3 = new Picture("roz.jpg", ali.getUserName());
        p4 = new Picture("narges.jpg", ali.getUserName());
        p5 = new Picture("laleh.jpg", ali.getUserName());
        p6 = new Picture("peikan.jpg", taghi.getUserName());
        p7 = new Picture("dena.jpg", taghi.getUserName());
        p8 = new Picture("shahin.jpg", taghi.getUserName());
        p9 = new Picture("meimoon.jpg", taghi.getUserName());
        p10 = new Picture("yakh.jpg", taghi.getUserName());
        p11 = new Picture("yaran.jpg",ali.getUserName());
        a1 = new Album("mashin", ali.getUserName());
        a2 = new Album("gol", ali.getUserName());
        a3 = new Album("mashin", taghi.getUserName());
        a4 = new Album("gol", taghi.getUserName());
        users = new ArrayList<>();
        UserManager.addUser(ali);
        UserManager.addUser(taghi);
        users.add(ali);
        users.add(taghi);
    }

    @Test
    public void addPerson() {
        p11.addPerson("Ali");
        p11.addPerson("Taghi");
        p11.addPerson("Naghi");
        assertEquals(3, p11.getPeopleInPicture().size());
        assertEquals(List.of("Ali","Taghi","Naghi"), p11.getPeopleInPicture());
    }
    //some changes may be needed
}
