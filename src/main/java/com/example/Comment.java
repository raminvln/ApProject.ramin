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
}
