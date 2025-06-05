package com.wallet.entity;

public enum NotificationType {
    DEPOSIT("입금"),
    WITHDRAW("출금"),
    SYSTEM("시스템");

    private final String description;

    NotificationType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
} 