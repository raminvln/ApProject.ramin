package com.example;

import java.time.*;

public class Comment {
    private String authorName;
    private String text;
    private LocalDateTime creationTime;

    public Comment(String authorName, String text) {
        this.authorName = authorName;
        this.text = text;
    }

    public String getAuthor() {
        return authorName;
    }

    public String getText() {
        return text;
    }

    public LocalDateTime getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(LocalDateTime creationTime) {
        this.creationTime = creationTime;
    }

}
