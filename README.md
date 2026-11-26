Seed Volunteer Companion (seed_v1)

A cross-platform desktop and mobile application built with Flutter and Firebase to help student volunteers and program administrators coordinate English tutoring sessions, manage student rosters, and access teaching resources.

Purpose

The Seed Volunteer Companion streamlines communication and scheduling for volunteer-led English literacy programs. It gives volunteers a single workspace to track their assigned learners, upcoming sessions, and teaching materials, while giving program administrators real-time tools to organize rosters, announcements, and volunteer permissions.

Current Features

1. Authentication & Role-Based Access

Firebase Authentication: Secure sign-up and login flow using email and password, with automatic session persistence across app launches.

Volunteer & Admin Roles: Syncs user profiles in real time from Cloud Firestore (volunteers collection) to dynamically unlock administrative tools for authorized coordinators.

2. Volunteer Dashboard & Profile

Live Statistics: Displays each volunteer's assigned student count, completed volunteer sessions, and logged volunteer hours.

Personal Profile: Shows the volunteer's name, email, school affiliation, bio, and role status.

3. Student Roster & Session Scheduling

Assigned Learner Tracking: Automatically matches volunteers with their assigned students and displays student grade levels, ages, and English proficiency tiers (Starter, Beginner, Intermediate, Advanced).

Session Schedule: Lists weekly tutoring slots (Monday, Wednesday, Friday) with session times, room locations, upcoming dates, and paired student/volunteer details.

4. Teaching Resource Library

Curated Guides: Built-in reference cards categorized by Engagement, Literacy, Wellbeing, and Assessment—including Icebreaker Games, Phonics Cheat Sheets, Shyness Strategies, Vocabulary Sheets, Storytelling Starters, and a CEFR-aligned Progress Rubric.

5. Live Announcements

Program Updates: Real-time announcement feed synced via Firestore, supporting pinned priority notices and chronological sorting.

6. Admin Management Panel

Announcement Management: Create, pin/unpin, and delete program-wide announcements.

Student Management: Add, edit, and remove student records, assign English proficiency levels, and pair students with registered volunteers (automatically cleaning up orphaned sessions when a student is removed).

Session Slot Management: Create, update, and delete recurring tutoring slots and room assignments.

Volunteer Permissions: View all registered volunteers and grant or revoke administrator privileges.

Tech Stack

Frontend: Flutter (Dart), Google Fonts (Inter & Nunito), reactive state management via ValueNotifier & ValueListenableBuilder

Backend: Firebase Authentication & Cloud Firestore (real-time snapshot listeners)

Target Platforms: Windows Desktop, macOS, Linux, iOS, Android, and Web