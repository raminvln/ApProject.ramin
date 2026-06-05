package com.example;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Picture {
    // از این فیلد صاحب میخوام حداقل فعلا در این فاز مثل گالری گوشی فرد استفاده کنم
    // ینی این عکس توی گالری گوشی فرد هست و تا اون را اضافه نکنه خب توی حساب کاربریش
    // نمیاد
    private String name;
    private User owner;
    private boolean commentsAllowed = false;
    private boolean isPublic = false;
    private LocalDateTime timeOfAdd;
    private List<Album> albums = new ArrayList<>();
    private List<String> tags = new ArrayList<>();
    private String caption;
    private List<String> peopleInPicture = new ArrayList<>();
    private boolean isLikedByTheOwner = false;
    private int likes = 0;
    private List<Comment> comments = new ArrayList<>();

    public Picture(String name, User owner) {
        this.name = name;
        this.owner = owner;
    }

    public String getCaption() {
        return caption;
    }

    public int getLikes() {
        return likes;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public boolean isLikedByTheOwner() {
        return isLikedByTheOwner;
    }

    public void setLikedByTheOwner(boolean isLiked) {
        this.isLikedByTheOwner = isLiked;
    }

    public List<Album> getAlbums() {
        return albums;
    }

    public List<String> getTags() {
        return tags;
    }

    public String getCaptions() {
        return caption;
    }

    public List<String> getPeopleInPicture() {
        return peopleInPicture;
    }

    public LocalDateTime getTimeOfAdd() {
        return timeOfAdd;
    }

    public User getOwner() {
        return owner;
    }

    public void setTimeOfAdd(LocalDateTime timeOfAdd) {
        this.timeOfAdd = timeOfAdd;
    }

    public boolean isPublic() {
        return isPublic;
    }

    public String getName() {
        return name;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public boolean isCommentsAllowed() {
        return commentsAllowed;
    }

    public void setPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    public void setCommentsAllowed(boolean commentsAllowed) {
        this.commentsAllowed = commentsAllowed;
    }

    public void addTag(String tag) {
        tags.add(tag);
    }

    public void addPerson(String person) {
        peopleInPicture.add(person);
    }

    public void increaseLikes() {
        likes++;
    }

    public void addComment(Comment comment) {
        comments.add(comment);
    }
}
