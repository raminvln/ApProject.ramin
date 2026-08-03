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
                                                .anyMatch(name -> name.toLowerCase().contains(albumName.toLowerCase())))
                                .collect(Collectors.toList());
        }

        public static List<Picture> searchByName(String pictureName, User user) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getName().toLowerCase().contains(pictureName.toLowerCase()))
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

        public static List<Picture> filterAfterThisDate(User user, LocalDateTime dateTime) {
                return user.getPictures().stream()
                                .filter(picture -> picture.getTimeOfAdd().isAfter(dateTime))
                                .collect(Collectors.toList());
        }
}
