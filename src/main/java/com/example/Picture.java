package com.example;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Picture {
    // از این فیلد صاحب میخوام حداقل فعلا در این فاز مثل گالری گوشی فرد استفاده کنم
    // ینی این عکس توی گالری گوشی فرد هست و تا اون را اضافه نکنه خب توی حساب کاربریش
    // نمیاد
    private String name;
    private String ownerName;
    private boolean commentsAllowed = false;
    private LocalDateTime timeOfAdd;
    private List<String> albumNames = new ArrayList<>();
    private List<String> tags = new ArrayList<>();
    private String caption;
    private List<String> peopleInPicture = new ArrayList<>();
    private boolean isLikedByTheOwner = false;

    public Picture(String name, String ownerName) {
        this.name = name;
        this.ownerName = ownerName;
    }

    public void setPeopleInPicture(List<String> peopleInPicture) {
        this.peopleInPicture = peopleInPicture;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public String getCaption() {
        return caption;
    }
    
    public void setAlbumNames(List<String> albumNames) {
        this.albumNames = albumNames;
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

    public List<String> getAlbumsNames() {
        return albumNames;
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

    public String getOwnerName() {
        return ownerName;
    }

    public void setTimeOfAdd(LocalDateTime timeOfAdd) {
        this.timeOfAdd = timeOfAdd;
    }

    public String getName() {
        return name;
    }

    public boolean isCommentsAllowed() {
        return commentsAllowed;
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

    @Override
    public String toString() {
        return "Picture [name=" + name + ", ownerName=" + ownerName + ", timeOfAdd=" + timeOfAdd + "]";
    }
}
