package com.example;

import java.util.*;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

public class UserManagerTest {
    User ali;
    User taghi;
    User admin;
    List<User> users;

    @BeforeEach
    public void initializeAndSomeAdd() {
        UserManager.getUsers().clear();
        ali = new User("AliAlavi@gmail.com", "abcdDEfg3456");
        taghi = new User("TaghiTaghavi@gmail.com", "hijkLmNoe345");
        admin = new Admin("AdiAdavi@gmail.com", "qrsTUV123");
        users = new ArrayList<>();
        UserManager.addUser(admin);
        UserManager.addUser(ali);
        UserManager.addUser(taghi);
        users.add(admin);
        users.add(ali);
        users.add(taghi);
    }

    @Test
    public void passwordAllowedTest() {
        assertTrue(UserManager.isPasswordAllowed("qwueuO489"));
        assertTrue(UserManager.isPasswordAllowed("QWWEi3009009"));
        assertTrue(UserManager.isPasswordAllowed("3333uI7665422"));
        assertTrue(UserManager.isPasswordAllowed("7u8iO987643"));
        assertTrue(!UserManager.isPasswordAllowed("12344io087po")); // no capital
        assertTrue(!UserManager.isPasswordAllowed("129I9874LFJ")); // no small letter
        assertTrue(!UserManager.isPasswordAllowed("OOOOooopegus")); // no number
        assertTrue(!UserManager.isPasswordAllowed("qwueuO4")); // length less than 8
    }

    @Test
    public void isUserNameAllowedTest() {
        assertTrue(UserManager.isUserNameAllowed("09987642190"));
        assertTrue(UserManager.isUserNameAllowed("amirnaeini@gmail.com"));
        assertTrue(!UserManager.isUserNameAllowed("9135647999")); // doesn't have the 0
        assertTrue(!UserManager.isUserNameAllowed("hasan@")); // it's not completed
    }

    @Test
    public void addUserTest() {
        assertEquals(users, UserManager.getUsers());
        UserManager.removeUser(taghi);
        users.remove(taghi);
        taghi = new User("TaghiTaghavi@gmail.com", "hijkLmNoe");
        UserManager.addUser(taghi);
        assertEquals(users, UserManager.getUsers()); // taghi is not in the list becuase his password is invalid
        taghi.setPassword("hijkLmNoe345"); // change his password (admin cannot do that becuase taghi is not in the list
                                           // yet)
        UserManager.addUser(taghi);
        users.add(taghi);
        assertEquals(users, UserManager.getUsers()); // taghi added to the list
    }

    @Test
    public void removeUserTest() {
        users.remove(ali);
        UserManager.removeUser(ali);
        assertEquals(users, UserManager.getUsers());
    }

    @Test
    public void userNameExistsTest() {
        UserManager.removeUser(ali);
        assertFalse(UserManager.userNameExists("AliAlavi@gmail.com"));
        UserManager.addUser(ali);
        users.add(ali);
        assertTrue(UserManager.userNameExists("AliAlavi@gmail.com"));
        assertTrue(UserManager.userNameExists("AdiAdavi@gmail.com"));
        assertTrue(UserManager.userNameExists("TaghiTaghavi@gmail.com"));
        System.out.println(UserManager.getUsers());
    }
}
