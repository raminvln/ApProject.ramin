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
        ali = new User("AliAlavi@gmail.com", "abcdDEfg3456");
        taghi = new User("TaghiTaghavi@gmail.com", "hijkLmNoe345");
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
        p11 = new Picture("yaran.jpg",ali);
        a1 = new Album("mashin", ali);
        a2 = new Album("gol", ali);
        a3 = new Album("mashin", taghi);
        a4 = new Album("gol", taghi);
        users = new ArrayList<>();
        UserManager.addUser(ali);
        UserManager.addUser(taghi);
        users.add(ali);
        users.add(taghi);
    }

    @Test
    public void addCommentTest() {
        Comment comment1 = new Comment(ali, "it is beautiful");
        Comment comment2 = new Comment(taghi, "OMG");
        p9.addComment(comment2);
        p9.addComment(comment1);
        assertEquals(0, p9.getComments().size());
        p9.setPublic(true);
        p9.addComment(comment2);
        p9.addComment(comment1);
        assertEquals(2, p9.getComments().size());
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
