package com.example;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class SearchManager {
    private SearchManager() {
    }

    public static List<Picture> searchByAlbum(String albumName, User user) {
        return user.getPictures().stream()
                .filter(picture -> picture.getAlbums().stream()
                        .anyMatch(album -> album.getName().toLowerCase().contains(albumName)))
                .collect(Collectors.toList());
    }

    public static List<Picture> searchByName(String pictureName, User user) {
        return user.getPictures().stream()
                .filter(picture -> picture.getName().toLowerCase().contains(pictureName))
                .collect(Collectors.toList());
    }

    public static List<Picture> searchByComment(String commentText, User user) {
        return user.getPictures().stream()
                .filter(picture -> picture.getComments().stream()
                        .anyMatch(comment -> comment.getText().toLowerCase().contains(commentText)))
                .collect(Collectors.toList());
    }

    public static List<Picture> searchByTag(String tagSearch, User user) {
        return user.getPictures().stream()
                .filter(picture -> picture.getTags().stream()
                        .anyMatch(tag -> tag.toLowerCase().contains(tagSearch)))
                .collect(Collectors.toList());
    }

    public static List<Picture> searchByDate(LocalDate localDate, User user) {
        return user.getPictures().stream()
                .filter(picture -> picture.getTimeOfAdd().toLocalDate().equals(localDate))
                .collect(Collectors.toList());
    }
    
}
