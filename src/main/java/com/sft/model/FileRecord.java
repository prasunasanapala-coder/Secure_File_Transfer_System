
package com.sft.model;

import java.sql.Timestamp;

public class FileRecord {

    private int id;
    private String originalName;
    private String storageKey;
    private int uploadedBy;
    private long fileSize;
    private Timestamp uploadedAt;

    public FileRecord(int id, String originalName,
            String storageKey, int uploadedBy,
            long fileSize, Timestamp uploadedAt) {
        this.id = id;
        this.originalName = originalName;
        this.storageKey = storageKey;
        this.uploadedBy = uploadedBy;
        this.fileSize = fileSize;
        this.uploadedAt = uploadedAt;
    }

    public int getId() { return id; }
    public String getOriginalName() { return originalName; }
    public String getStorageKey() { return storageKey; }
    public int getUploadedBy() { return uploadedBy; }
    public long getFileSize() { return fileSize; }
    public Timestamp getUploadedAt() { return uploadedAt; }
}
