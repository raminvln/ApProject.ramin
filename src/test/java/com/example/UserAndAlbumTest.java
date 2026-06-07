package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class UserAndAlbumTest {
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
    public void addPicture() {
        ali.addPicture(p1);
        ali.addPicture(p2);
        ali.addPicture(p3);
        ali.addPicture(p4);
        ali.addPicture(p5);
        ali.addPicture(p1); // it wont add again
        ali.addPicture(p8); // ali is not the owner of this picture
        taghi.addPicture(p6);
        taghi.addPicture(p7);
        taghi.addPicture(p8);
        taghi.addPicture(p9);
        taghi.addPicture(p10);
        taghi.addPicture(p1); // taghi is not the owner of this picture
        taghi.addPicture(p9); // it wont add again
        assertEquals(5, ali.getPictures().size());
        assertTrue(ali.getPictures().contains(p1)); // adding right pictures to ali
        assertTrue(ali.getPictures().contains(p2)); //
        assertTrue(ali.getPictures().contains(p3)); //
        assertTrue(ali.getPictures().contains(p4)); //
        assertTrue(ali.getPictures().contains(p5)); //

        assertFalse(ali.getPictures().contains(p6)); // wrong pictures didn't add
        assertFalse(ali.getPictures().contains(p7)); //
        assertFalse(ali.getPictures().contains(p8)); //
        assertFalse(ali.getPictures().contains(p9)); //
        assertFalse(ali.getPictures().contains(p10)); //

        assertEquals(5, taghi.getPictures().size());
        assertTrue(taghi.getPictures().contains(p6));
        assertTrue(taghi.getPictures().contains(p7));
        assertTrue(taghi.getPictures().contains(p8));
        assertTrue(taghi.getPictures().contains(p9));
        assertTrue(taghi.getPictures().contains(p10));

        assertFalse(taghi.getPictures().contains(p1));
        assertFalse(taghi.getPictures().contains(p2));
        assertFalse(taghi.getPictures().contains(p3));
        assertFalse(taghi.getPictures().contains(p4));
        assertFalse(taghi.getPictures().contains(p5));
    }

    @Test
    public void removePictureTest() {
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

        ali.removePicture(p1);
        ali.removePicture(p3);

        taghi.removePicture(p7);
        taghi.removePicture(p9);

        assertTrue(taghi.getPictures().contains(p6));
        assertTrue(taghi.getPictures().contains(p8));
        assertTrue(taghi.getPictures().contains(p10));
        assertFalse(taghi.getPictures().contains(p7));
        assertFalse(taghi.getPictures().contains(p9));

        assertTrue(ali.getPictures().contains(p2));
        assertTrue(ali.getPictures().contains(p4));
        assertTrue(ali.getPictures().contains(p5));
        assertFalse(ali.getPictures().contains(p1));
        assertFalse(ali.getPictures().contains(p3));
    }

    @Test
    public void addAlbumTest() {
        ali.addAlbum(a1);
        ali.addAlbum(a2);
        taghi.addAlbum(a3);
        taghi.addAlbum(a4);
        ali.addAlbum(a1);
        ali.addAlbum(a3);
        taghi.addAlbum(a1);
        taghi.addAlbum(a3);
        assertEquals(2, ali.getAlbums().size()); // we don't add a same album twoice
        assertTrue(ali.getAlbums().contains(a1));
        assertTrue(ali.getAlbums().contains(a2));
        assertFalse(ali.getAlbums().contains(a3)); // this album doesn't belong to ali
        assertEquals(2, taghi.getAlbums().size());
        assertTrue(taghi.getAlbums().contains(a3));
        assertTrue(taghi.getAlbums().contains(a4));
        assertFalse(taghi.getAlbums().contains(a1));
    }

    @Test
    public void removeAlbumTest() {
        ali.addAlbum(a1);
        ali.addAlbum(a2);
        taghi.addAlbum(a3);
        taghi.addAlbum(a4);

        ali.removeAlbum(a1);
        taghi.removeAlbum(a3);
        assertEquals(1, ali.getAlbums().size());
        assertEquals(1, taghi.getAlbums().size());
        assertTrue(ali.getAlbums().contains(a2));
        assertFalse(ali.getAlbums().contains(a1));
        assertTrue(taghi.getAlbums().contains(a4));
        assertFalse(taghi.getAlbums().contains(a3));
    }

    @Test
    public void addPictureToAlbumTest() {
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

        ali.addAlbum(a1); // this album is already added
        ali.addAlbum(a4); // this album doesn't belong to ali

        taghi.addAlbum(a3);
        taghi.addAlbum(a4);

        taghi.addAlbum(a3); // this album is already added
        taghi.addAlbum(a2); // this album doesn't bolong to taghi

        a1.addPicture(p1);
        a1.addPicture(p2);
        a2.addPicture(p3);
        a2.addPicture(p4);
        a2.addPicture(p5);

        a1.addPicture(p7); // this picture doesn't belong to owner of a1
        a1.addPicture(p2); // this picture is already added to this album and it won't be added again

        a3.addPicture(p6);
        a3.addPicture(p7);
        a3.addPicture(p8);
        a4.addPicture(p9);
        a4.addPicture(p10);

        a3.addPicture(p2); // this picture doesn't belong to owner of a3
        a3.addPicture(p7); // this picture has already added to this album and won't add again

        assertEquals(2, ali.getAlbums().size());
        assertEquals(2, taghi.getAlbums().size());

        assertTrue(ali.getAlbums().contains(a1));
        assertTrue(ali.getAlbums().contains(a2));
        assertFalse(ali.getAlbums().contains(a3));
        assertFalse(ali.getAlbums().contains(a4));
        assertTrue(taghi.getAlbums().contains(a3));
        assertTrue(taghi.getAlbums().contains(a4));
        assertFalse(taghi.getAlbums().contains(a1));
        assertFalse(taghi.getAlbums().contains(a2));

        assertEquals(2, a1.getPictures().size());
        assertEquals(3, a2.getPictures().size());
        assertEquals(3, a3.getPictures().size());
        assertEquals(2, a4.getPictures().size());

        assertTrue(a1.getPictures().contains(p1));
        assertTrue(a1.getPictures().contains(p2));
        assertFalse(a1.getPictures().contains(p3));
        assertFalse(a1.getPictures().contains(p4));
        assertFalse(a1.getPictures().contains(p5));
        assertFalse(a1.getPictures().contains(p6));
        assertFalse(a1.getPictures().contains(p7));
        assertFalse(a1.getPictures().contains(p8));
        assertFalse(a1.getPictures().contains(p9));
        assertFalse(a1.getPictures().contains(p10));

        assertTrue(a2.getPictures().contains(p3));
        assertTrue(a2.getPictures().contains(p4));
        assertTrue(a2.getPictures().contains(p5));
        assertFalse(a2.getPictures().contains(p1));
        assertFalse(a2.getPictures().contains(p2));
        assertFalse(a2.getPictures().contains(p6));
        assertFalse(a2.getPictures().contains(p7));
        assertFalse(a2.getPictures().contains(p8));
        assertFalse(a2.getPictures().contains(p9));
        assertFalse(a2.getPictures().contains(p10));

        assertTrue(a3.getPictures().contains(p6));
        assertTrue(a3.getPictures().contains(p7));
        assertTrue(a3.getPictures().contains(p8));
        assertFalse(a3.getPictures().contains(p1));
        assertFalse(a3.getPictures().contains(p2));
        assertFalse(a3.getPictures().contains(p3));
        assertFalse(a3.getPictures().contains(p4));
        assertFalse(a3.getPictures().contains(p5));
        assertFalse(a3.getPictures().contains(p9));
        assertFalse(a3.getPictures().contains(p10));

        assertTrue(a4.getPictures().contains(p9));
        assertTrue(a4.getPictures().contains(p10));
        assertFalse(a4.getPictures().contains(p1));
        assertFalse(a4.getPictures().contains(p2));
        assertFalse(a4.getPictures().contains(p3));
        assertFalse(a4.getPictures().contains(p4));
        assertFalse(a4.getPictures().contains(p5));
        assertFalse(a4.getPictures().contains(p6));
        assertFalse(a4.getPictures().contains(p7));
        assertFalse(a4.getPictures().contains(p8));
    }

    @Test
    public void removePictureFromAlbumTest() {
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

        a2.removePicture(p3);
        a4.removePicture(p10);

        assertEquals(2, a1.getPictures().size());
        assertEquals(1, a4.getPictures().size());
    }

    @Test
    public void copyImageToAlbumTest() {
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

        ali.copyImageToAlbum(p2, a2);
        taghi.copyImageToAlbum(p6, a4);

        ali.copyImageToAlbum(p1, a1); // this picture already exists
        ali.copyImageToAlbum(p6, a1); // ali is not the owner of this picture

        taghi.copyImageToAlbum(p4, a4); // taghi is not the owner of this picture
        taghi.copyImageToAlbum(p9, a4); // this picture already exists
        assertEquals(4, a2.getPictures().size());
        assertEquals(3, a4.getPictures().size());
        assertTrue(a2.getPictures().contains(p2));
        assertTrue(a4.getPictures().contains(p6));
        assertFalse(a1.getPictures().contains(p6));
        assertFalse(a4.getPictures().contains(p4));
    }

    @Test
    public void moveImageToAnotherTest() {
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

        ali.moveImageToAnother(p2, a1, a2);
        taghi.moveImageToAnother(p6, a3, a4);

        assertEquals(1, a1.getPictures().size());
        assertEquals(4, a2.getPictures().size());
        assertEquals(2, a3.getPictures().size());
        assertEquals(3, a4.getPictures().size());

        assertTrue(a1.getPictures().contains(p1));
        assertTrue(a2.getPictures().contains(p2));
        assertTrue(a2.getPictures().contains(p3));
        assertTrue(a2.getPictures().contains(p4));
        assertTrue(a2.getPictures().contains(p5));

        assertTrue(a3.getPictures().contains(p7));
        assertTrue(a3.getPictures().contains(p8));
        assertTrue(a4.getPictures().contains(p6));
        assertTrue(a4.getPictures().contains(p9));
        assertTrue(a4.getPictures().contains(p10));
    }

    @Test
    public void likeAndUnlikeTest() {
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

        p1.setPublic(true);
        p2.setPublic(true);
        p3.setPublic(true);
        p4.setPublic(true);
        p8.setPublic(true);
        p9.setPublic(true);

        User hasan = new User("09999999899", "9876iuytREW");
        User hossein = new User("hossein@gmail.com", "nullNist123");
        User mohammad = new User("mohammad@gmail.com", "mohammadNObari89667");

        hasan.likePicture(p1);
        hasan.likePicture(p2);
        hasan.likePicture(p3);

        hossein.likePicture(p1);
        hossein.likePicture(p4);
        taghi.likePicture(p4);

        mohammad.likePicture(p1);
        mohammad.likePicture(p2);
        mohammad.likePicture(p3);

        assertEquals(3, p1.getLikes());
        assertEquals(2, p2.getLikes());
        assertEquals(2, p3.getLikes());
        assertEquals(2, p4.getLikes());

        assertTrue(p1.getLikers().contains(mohammad));
        assertTrue(p1.getLikers().contains(hasan));
        assertTrue(p1.getLikers().contains(hossein));
        hasan.unLikePicture(p1);
        assertEquals(2, p1.getLikes());
        mohammad.unLikePicture(p4); // mohammad hasn't liked this picture so it's likes number doesn't change
        assertEquals(2, p4.getLikes());

        // some changes may be needed
    }
}
