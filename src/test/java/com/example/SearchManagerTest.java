package com.example;

import static org.junit.jupiter.api.Assertions.*;
import java.time.LocalDate;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class SearchManagerTest {
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

    Album a1;
    Album a2;
    Album a3;
    Album a4;

    @BeforeEach
    public void initialize() {

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

        a1 = new Album("mashin", ali);
        a2 = new Album("gol", ali);

        a3 = new Album("mashin", taghi);
        a4 = new Album("gol", taghi);

        UserManager.addUser(ali);
        UserManager.addUser(taghi);

        ali.addPicture(p1);
        ali.addPicture(p2);
        ali.addPicture(p3);
        ali.addPicture(p4);
        ali.addPicture(p5);

        taghi.addPicture(p6);
        taghi.addPicture(p7);
        taghi.addPicture(p8);
        taghi.addPicture(p9);
        taghi.addPicture(p10);

        ali.addAlbum(a1);
        ali.addAlbum(a2);

        taghi.addAlbum(a3);
        taghi.addAlbum(a4);

        a1.addPicture(p1);
        a1.addPicture(p2);

        a2.addPicture(p3);
        a2.addPicture(p4);
        a2.addPicture(p5);

        a3.addPicture(p6);
        a3.addPicture(p7);
        a3.addPicture(p8);
        a4.addPicture(p9);
        a4.addPicture(p10);

        p1.addTag("car");
        p1.addTag("iran");
        p2.addTag("car");
        p3.addTag("flower");
        p4.addTag("flower");
        p5.addTag("nature");

        p1.setPublic(true);
        p2.setPublic(true);
        p3.setPublic(true);
        p1.addComment(new Comment(taghi, "beautiful car"));
        p1.addComment(new Comment(taghi, "red car"));
        p2.addComment(new Comment(taghi, "old car"));
        p3.addComment(new Comment(ali, "nice flower"));
    }

    @Test
    public void searchByAlbumTest() {

        List<Picture> result = SearchManager.searchByAlbum("mashin", ali);
        assertEquals(2, result.size());
        assertTrue(result.contains(p1));
        assertTrue(result.contains(p2));
    }

    @Test
    public void searchByNameTest() {
        List<Picture> result = SearchManager.searchByName("pri", ali);
        assertEquals(1, result.size());
        assertTrue(result.contains(p1));
    }

    @Test
    public void searchByTagTest() {
        List<Picture> result = SearchManager.searchByTag("car", ali);
        assertEquals(2, result.size());
        assertTrue(result.contains(p1));
        assertTrue(result.contains(p2));
        assertFalse(result.contains(p3));
    }

    @Test
    public void searchByCommentTest() {
        List<Picture> result = SearchManager.searchByComment("beautiful", ali);
        assertEquals(1, result.size());
        assertTrue(result.contains(p1));
    }

    @Test
    public void sortByNameTest() {
        List<Picture> result = SearchManager.sortByName(ali);
        assertEquals(p2, result.get(0)); // l90
        assertEquals(p5, result.get(1)); // laleh
        assertEquals(p4, result.get(2)); // narges
        assertEquals(p1, result.get(3)); // pride
        assertEquals(p3, result.get(4)); // roz
    }

    @Test
    public void sortByLikesTest() {

        User user1 = new User("user1@gmail.com", "Password123");
        User user2 = new User("user2@gmail.com", "Password123");
        User user3 = new User("user3@gmail.com", "Password123");
        user1.likePicture(p1);
        user2.likePicture(p1);
        user3.likePicture(p1);
        user1.likePicture(p2);
        List<Picture> result = SearchManager.sortByLikes(ali);
        assertEquals(p1, result.get(0));
        assertEquals(p2, result.get(1));
    }

    @Test
    public void filterMoreThanLikesTest() {
        User user1 = new User("user1@gmail.com", "Password123");
        User user2 = new User("user2@gmail.com", "Password123");
        p1.increaseLikes(user1);
        p1.increaseLikes(user2);
        p2.increaseLikes(user1);
        List<Picture> result = SearchManager.filterMoreThanLikes(ali, 1);
        assertEquals(1, result.size());
        assertTrue(result.contains(p1));
    }

    @Test
    public void filterAfterThisDateTest() {
        p1.setTimeOfAdd(LocalDate.of(2024, 1, 1).atTime(10, 0));
        p2.setTimeOfAdd(LocalDate.of(2024, 6, 1).atTime(10, 0));
        p3.setTimeOfAdd(LocalDate.of(2025, 1, 1).atTime(10, 0));
        p4.setTimeOfAdd(LocalDate.of(2025, 5, 1).atTime(10, 0));
        p5.setTimeOfAdd(LocalDate.of(2023, 1, 1).atTime(10, 0));
        List<Picture> result = SearchManager.filterAfterThisDate(ali, LocalDate.of(2024, 6, 1).atStartOfDay());
        assertEquals(3, result.size());
        assertTrue(result.contains(p3));
        assertTrue(result.contains(p4));
        assertTrue(result.contains(p2));
        assertFalse(result.contains(p1));
        assertFalse(result.contains(p5));
    }

    @Test
    public void searchByDateTest() {
        p1.setTimeOfAdd(LocalDate.of(2025, 1, 1).atTime(10, 0));
        p2.setTimeOfAdd(LocalDate.of(2025, 1, 1).atTime(15, 30));
        p3.setTimeOfAdd(LocalDate.of(2025, 2, 1).atTime(9, 0));
        p4.setTimeOfAdd(LocalDate.of(2024, 1, 1).atTime(12, 0));
        p5.setTimeOfAdd(LocalDate.of(2023, 1, 1).atTime(8, 0));
        List<Picture> result = SearchManager.searchByDate(LocalDate.of(2025, 1, 1), ali);
        assertEquals(2, result.size());
        assertTrue(result.contains(p1));
        assertTrue(result.contains(p2));
        assertFalse(result.contains(p3));
        assertFalse(result.contains(p4));
        assertFalse(result.contains(p5));
    }

    @Test
    public void sortByDateTimeTest() {

        p1.setTimeOfAdd(LocalDate.of(2024, 1, 1).atTime(10, 0));
        p2.setTimeOfAdd(LocalDate.of(2025, 1, 1).atTime(10, 0));
        p3.setTimeOfAdd(LocalDate.of(2025, 1, 1).atTime(15, 0));
        p4.setTimeOfAdd(LocalDate.of(2023, 5, 1).atTime(20, 0));
        p5.setTimeOfAdd(LocalDate.of(2022, 1, 1).atTime(1, 0));
        List<Picture> result = SearchManager.sortByDateTime(ali);

        assertEquals(5, result.size());
        assertEquals(p3, result.get(0));
        assertEquals(p2, result.get(1));
        assertEquals(p1, result.get(2));
        assertEquals(p4, result.get(3));
        assertEquals(p5, result.get(4));
    }

    
}
