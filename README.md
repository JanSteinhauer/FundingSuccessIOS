# Funding Success - README

## Overview

**Funding Success** is an innovative platform designed to enhance the scholarship experience for both students and donors. By leveraging cutting-edge Generative AI (GenAI), the platform optimizes student-donor matching, streamlines impact tracking, and fosters lasting relationships through data-driven decisions. 

This platform is akin to a portfolio manager for donors, providing personalized insights into student progress and return on investment (ROI), while offering students continuous financial support.

## Key Features

1. **Smart Matching:**
   - **GenAI Matching Algorithm**: Tailors connections between students and donors based on shared interests, academic achievements, and goals. Our algorithm leverages data from top institutions like Harvard, Stanford, UT Austin, and MIT to ensure impactful and meaningful matches.
   - **Continuous Connections**: Matches are maintained across semesters, removing the time-consuming rematching process and ensuring continuity in support.

2. **Performance Transparency:**
   - **Verified Student Reviews**: The platform generates verified performance reviews, comparing students' achievements against their peers, ensuring donors have a clear understanding of the student's progress and success.
   - **Clear ROI for Donors**: Donors receive detailed, data-backed reports that help them make informed decisions about continuing their support or reallocating their contributions.

3. **Informed Funding Decisions:**
   - The platform allows donors to manage their “scholarship portfolio,” assessing which students to continue supporting based on comprehensive performance data, much like a financial portfolio.

## Target Audience

- **Students**: Those in need of financial support for their academic journey.
- **Donors**: Purpose-driven philanthropists and committed supporters who wish to provide continuous support, while tracking the impact of their contributions.
- **Loan Institutions**: Organizations looking to engage with a highly relevant market of students and parents.

## Founders

- **Jan Steinhauer** – Co-Founder & CTO
- **Octavio Kano-Galvan** – Co-Founder & CMO

Here’s the updated installation guide for the **Funding Success iOS App**, including Firebase setup and without mentioning CocoaPods:

---

# Funding Success iOS App - Installation Guide

## Prerequisites

Before you can build and run the Funding Success iOS app, ensure you have the following installed on your machine:

1. **macOS**: Ensure you are running macOS 11.0 (Big Sur) or later.
2. **Xcode**: Install Xcode 14.0 or later from the [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835).
3. **Apple Developer Account**: To run the app on a physical device, ensure you are logged in with a valid Apple Developer Account in Xcode.
4. **Firebase**: The app requires Firebase for backend services, such as authentication and database management. Ensure you have a Firebase project set up.

## Step-by-Step Installation

### 1. **Clone the Repository**

Start by cloning the repository from your preferred source (e.g., GitHub, GitLab). Replace the `<repository-url>` with the actual URL of the project repository.

```bash
git clone <repository-url>
cd fundingSuccess
```

### 2. **Open the Project in Xcode**

Once you have the repository cloned, open the project in Xcode:

- Double-click on the `.xcodeproj` file inside the project directory, or run the following command in your terminal:

   ```bash
   open fundingSuccess.xcodeproj
   ```

### 3. **Firebase Setup**

The app integrates with Firebase for authentication and data management. Follow these steps to configure Firebase:

1. **Create a Firebase Project**: 
   - Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.

2. **Add iOS App in Firebase**:
   - In the Firebase Console, click on "Add App" and select iOS.
   - Enter the **Bundle ID** of your app, which you can find in the Xcode project settings under the **General** tab.
   - Follow the instructions to download the `GoogleService-Info.plist` file.

3. **Add `GoogleService-Info.plist` to Xcode**:
   - After downloading `GoogleService-Info.plist`, drag it into your Xcode project, making sure to check the box for "Copy items if needed."
   - Ensure the file is added to all relevant targets.

4. **Install Firebase SDK**:
   Firebase SDK is integrated via Swift Package Manager (SPM). Follow these steps to ensure the packages are correctly installed:
   - In Xcode, go to **File > Add Packages**.
   - Search for `firebase-ios-sdk` or enter the following URL: `https://github.com/firebase/firebase-ios-sdk`.
   - Select the Firebase libraries required for your project (e.g., Firebase Authentication, Firestore, etc.) and integrate them into the app.

5. **Enable Firebase Services**:
   - Ensure that relevant Firebase services such as **Authentication** and **Firestore Database** are enabled from the Firebase Console.

### 4. **Configure the Project**

1. **Team Signing**: In Xcode, navigate to the project settings and under **Signing & Capabilities**, select your development team to sign the app. This is required to run the app on a physical device.

2. **Bundle Identifier**: Ensure the bundle identifier is unique, especially if you’re running the app on your device. You can edit it in the project settings under **General**.

3. **Build Configuration**: Make sure the correct **build configuration** (Debug/Release) is selected based on your testing or production environment.

### 5. **Build the Project**

Once everything is set up, you can build the project by clicking the **Build** button in Xcode (the play button at the top left) or by running:

```bash
Cmd + B
```

This will compile the code and prepare the app for running.
