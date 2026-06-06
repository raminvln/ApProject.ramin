package com.example;

import java.util.*;
import org.junit.*;
import org.junit.jupiter.api.*;

// 7. برای مدیریت استثناها در تست
// (در assertها موجود است)
import static org.junit.jupiter.api.Assertions.*;

// 1. برای نوشتن تست 
import org.junit.jupiter.api.Test;

// 2. برای متدهای assert (اعتبارسنجی)
import static org.junit.jupiter.api.Assertions.*;

// 3. برای اجرای کد قبل/بعد از هر تست
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;

// 4. برای اجرای کد قبل/بعد از همه تست‌ها (یک بار)
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.AfterAll;

// 5. برای نامگذاری خوانای تست‌ها
import org.junit.jupiter.api.DisplayName;

// 6. برای غیرفعال کردن موقت تست‌ها
import org.junit.jupiter.api.Disabled;

public class ProjectTest {
    @Test
    public void addUserTest() {
        User ali = new User("AliAlavi@gmail.com", "abcdDEfg3456");
        User taghi = new User("TaghiTaghavi@gmail.com", "hijkLmNoe");
        User admin = new Admin("AdiAdavi@gmail.com", "qrsTUV123");
        Picture p1 = new Picture("pride.jpg", ali);
        Picture p2 = new Picture("l90.jpg", ali);
        Picture p3 = new Picture("roz.jpg", ali);
        Picture p4 = new Picture("narges.jpg", ali);
        Picture p5 = new Picture("laleh.jpg", ali);
        Picture p6 = new Picture("peikan.jpg", taghi);
        Picture p7 = new Picture("dena.jpg", taghi);
        Picture p8 = new Picture("shahin.jpg", taghi);
        Picture p9 = new Picture("meimoon.jpg", taghi);
        Picture p10 = new Picture("yakh.jpg", taghi);
        Album a1 = new Album("mashin", ali);
        Album a2 = new Album("mashin", ali);
        Album a3 = new Album("gol", ali);
        Album a4 = new Album("gol", taghi);
        UserManager.addUser(admin);
        UserManager.addUser(taghi);
        UserManager.addUser(ali);
        List<User> users = new ArrayList<>();
        users.add(admin);
        users.add(ali);
        assertEquals(users,UserManager.getUsers());
    }
}
