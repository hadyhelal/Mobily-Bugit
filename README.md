# Bug It - Bug Tracking iOS Application

<p align="center">
  <img src="Images/appstore.png" alt="Screenshot" width="150"/>
</p>

<p align="center" style="display: flex; gap: 10px;">
<img src="Images/screen1.gif" width="375" height="812" />
</p>

## Overview

**Mobily BugIt** is an iOS application built with Swift and SwiftUI, designed for tracking and managing software bugs. It enables users to capture screenshots, describe issues, and store bug reports in Google Sheets. Additionally, it allows importing images from other applications for streamlined bug documentation.


## Features

- **Data Management**: Supports UserDefaults for storing bug reports based on the iOS version.
- **Dependancy Injection**: Utilizes Factory for modular and testable architecture.
- **User-Friendly Interface**: Built with SwiftUI for a seamless and visually appealing experience.
- **Bug Reporting**: Allows users to capture or select images and provide descriptions for bug reports.
- **Cloud Storage**: Saves reports in Google Sheets, with each day having its own sheet/tab for easy organization.
- **Image Handling**: Supports receiving images from external applications to create bug entries.
- **Share Extension**: Enables sharing bug-related content from other apps directly into Mobily BugIt.
- **Unit Testing**: Test the ViewModel and mock its dependencies to ensure the correctness of test cases.

## Requirements

**Functionality**:
   - Capture or select images to report bugs.
   - Upload bug details to Google Sheets with daily tabs.
   - Integrate with external services for image storage.
   - Receive images from third-party apps for bug reporting.


## Architecture

### MVVM Design Pattern

The app follows the Model-View-ViewModel (MVVM) architecture to ensure separation of concerns and maintainability:

- **Model**: Represents the data layer and business logic (e.g., BugModel, Bug)
- **View**: Defines the user interface using SwiftUI (e.g., BugReportView, ShareView).
- **ViewModel**: Manages user actions and data handling (e.g., BugReportViewModel, ShareViewModel).

This architectural approach helps keep the codebase scalable, organized, and testable.
