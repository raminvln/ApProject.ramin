package com.example;

import java.time.*;

public class Comment {
    private User author;
    private String text;
    private LocalDateTime creationTime;

    public Comment(User author, String text, LocalDateTime creationTime) {
        this.author = author;
        this.text = text;
        this.creationTime = creationTime;
    }

    public User getAuthor() {
        return author;
    }

    public String getText() {
        return text;
    }

    public LocalDateTime getCreationTime() {
        return creationTime;
    }

}
