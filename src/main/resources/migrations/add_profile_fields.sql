-- Migration: Add bio and profile_picture_path to users table
-- Date: 2026-03-01

ALTER TABLE users
  ADD COLUMN bio TEXT DEFAULT NULL AFTER city,
  ADD COLUMN profile_picture_path VARCHAR(255) DEFAULT NULL AFTER bio;
