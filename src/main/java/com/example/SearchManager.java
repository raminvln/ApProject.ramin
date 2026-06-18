package com.example;

import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

public class SearchManager {
        private SearchManager() {
        }

        public static List<Picture> searchByAlbum(String albumName, User user) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getAlbumsNames().stream()
                                                .anyMatch(name -> name.contains(albumName)))
                                .collect(Collectors.toList());
        }

        public static List<Picture> searchByName(String pictureName, User user) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getName().toLowerCase().contains(pictureName.toLowerCase()))
                                .collect(Collectors.toList());
        }

        public static List<Picture> searchByComment(String commentText, User user) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getComments().stream()
                                                .anyMatch(comment -> comment.getText().toLowerCase()
                                                                .contains(commentText.toLowerCase())))
                                .collect(Collectors.toList());
        }

        public static List<Picture> searchByTag(String tagSearch, User user) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getTags().stream()
                                                .anyMatch(tag -> tag.toLowerCase().contains(tagSearch.toLowerCase())))
                                .collect(Collectors.toList());
        }

        public static List<Picture> searchByDate(LocalDate localDate, User user) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getTimeOfAdd().toLocalDate().equals(localDate))
                                .collect(Collectors.toList());
        }

        public static List<Picture> sortByDateTime(User user) {
                return user.getPictures().stream()
                                .sorted((picture1, picture2) -> picture2.getTimeOfAdd()
                                                .compareTo(picture1.getTimeOfAdd()))
                                .collect(Collectors.toList());
        }

        public static List<Picture> sortByName(User user) {
                return user.getPictures().stream()
                                .sorted((picture1, picture2) -> picture1.getName().compareTo(picture2.getName()))
                                .collect(Collectors.toList());
        }

        public static List<Picture> sortByLikes(User user) {
                return user.getPictures().stream()
                                .sorted((picture1, picture2) -> Integer.compare(picture2.getLikes(),
                                                picture1.getLikes()))
                                .collect(Collectors.toList());
        }

        public static List<Picture> filterMoreThanLikes(User user, int likes) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getLikes() > likes)
                                .collect(Collectors.toList());
        }

        public static List<Picture> filterAfterThisDate(User user, LocalDateTime dateTime) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getTimeOfAdd().isAfter(dateTime))
                                .collect(Collectors.toList());
        }
}
