//
//  ProfileView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/3/24.
//


import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @State private var userData: [String: Any]
    @State private var newProfilePicture: UIImage? = nil
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var experience: [ExperienceEntry] = []
    @State private var education: [EducationEntry] = []
    @State private var interests: [String] = []
    @State private var loans: [LoanEntry] = []
    @State private var projects: [ProjectEntry] = []
    
    @State private var showExperience = false
    @State private var showEducation = false
    @State private var showInterests = false
    @State private var showLoans = false
    @State private var showProjects = false
    
    @State private var showUniversities = false
    @State private var showDonorsLoan = false
    
    init(userData: [String: Any]) {
           self._userData = State(initialValue: userData)
       }
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileImageView(userData: $userData, newProfilePicture: $newProfilePicture)
                
                Group {
                    InputFieldView(label: "Name", text: $name)
                    InputFieldView(label: "Email", text: $email)
                    
                    if userData["isDonor"] as? Int == 0 {
                        SectionToggleView(showSection: $showExperience, title: "Experience")
                        if showExperience {
                            ExperienceListView(experience: $experience)
                        }
                        
                        SectionToggleView(showSection: $showEducation, title: "Education")
                        if showEducation {
                            EducationListView(education: $education)
                        }
                        
                        SectionToggleView(showSection: $showLoans, title: "Loans")
                        if showLoans {
                            LoanListView(loans: $loans)
                        }
                        
                        SectionToggleView(showSection: $showProjects, title: "Projects")
                        if showProjects {
                            ProjectListView(projects: $projects)
                        }
                    }
                    
                    if userData["isDonor"] as? Int == 1 {
                        SectionToggleView(showSection: $showUniversities, title: "University Preferences")
                        if showUniversities {
                            UniversityListView(universities: $education)
                        }
                        
                        SectionToggleView(showSection: $showDonorsLoan, title: "Loan Preferences")
                        if showDonorsLoan {
                            DonorLoanListView(loans: $loans)
                        }
                    }
                    
                    SectionToggleView(showSection: $showInterests, title: "Interests")
                    if showInterests {
                        InterestListView(interests: $interests)
                    }
                }
                
                Button(action: {
                    handleUpdateProfile()
                }) {
                    Text("Update Profile")
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .onAppear {
            loadUserData()
        }
    }
    
    func loadUserData() {
        // Load user data from Firestore
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(currentUserUid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                userData = document.data() ?? [:]
                name = userData["name"] as? String ?? ""
                email = userData["email"] as? String ?? ""
                experience = userData["experience"] as? [ExperienceEntry] ?? []
                education = userData["education"] as? [EducationEntry] ?? []
                interests = userData["interests"] as? [String] ?? []
                loans = userData["loans"] as? [LoanEntry] ?? []
                projects = userData["projects"] as? [ProjectEntry] ?? []
            } else {
                print("No such document!")
            }
        }
    }
    
    func handleUpdateProfile() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(currentUserUid)
        
        var newProfilePictureURL = userData["profilePictureURL"] as? String
        
        if let newProfilePicture = newProfilePicture {
            let storageRef = Storage.storage().reference().child("profilePictures/\(currentUserUid)")
            if let imageData = newProfilePicture.jpegData(compressionQuality: 0.75) {
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    guard let _ = metadata else {
                        print("Error uploading profile picture")
                        return
                    }
                    storageRef.downloadURL { url, error in
                        if let url = url {
                            newProfilePictureURL = url.absoluteString
                            updateFirestore(userRef: userRef, profilePictureURL: newProfilePictureURL)
                        }
                    }
                }
            }
        } else {
            updateFirestore(userRef: userRef, profilePictureURL: newProfilePictureURL)
        }
    }
    
    func updateFirestore(userRef: DocumentReference, profilePictureURL: String?) {
        userRef.setData([
            "name": name,
            "email": email,
            "profilePictureURL": profilePictureURL ?? "",
            "experience": experience,
            "education": education,
            "interests": interests,
            "loans": loans,
            "projects": projects
        ], merge: true) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully")
            }
        }
    }
}

struct ProfileImageView: View {
    @Binding var userData: [String: Any]
    @Binding var newProfilePicture: UIImage?
    
    var body: some View {
        VStack {
            if let profilePictureURL = userData["profilePictureURL"] as? String, let url = URL(string: profilePictureURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 150, height: 150)
                }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 150, height: 150)
            }
            Button("Change Profile Picture") {
                // Implement image picker
            }
        }
        .padding(.bottom, 20)
    }
}

struct InputFieldView: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(label, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding(.vertical, 5)
    }
}

struct SectionToggleView: View {
    @Binding var showSection: Bool
    var title: String
    
    var body: some View {
        Button(action: {
            withAnimation {
                showSection.toggle()
            }
        }) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: showSection ? "chevron.up" : "chevron.down")
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
    }
}

struct ExperienceListView: View {
    @Binding var experience: [ExperienceEntry]
    
    var body: some View {
        ForEach(experience.indices, id: \.self) { index in
            // Display each experience entry
        }
    }
}

struct EducationListView: View {
    @Binding var education: [EducationEntry]
    
    var body: some View {
        ForEach(education.indices, id: \.self) { index in
            // Display each education entry
        }
    }
}

struct LoanListView: View {
    @Binding var loans: [LoanEntry]
    
    var body: some View {
        ForEach(loans.indices, id: \.self) { index in
            // Display each loan entry
        }
    }
}

struct ProjectListView: View {
    @Binding var projects: [ProjectEntry]
    
    var body: some View {
        ForEach(projects.indices, id: \.self) { index in
            // Display each project entry
        }
    }
}

struct UniversityListView: View {
    @Binding var universities: [EducationEntry]
    
    var body: some View {
        ForEach(universities.indices, id: \.self) { index in
            // Display each university preference
        }
    }
}

struct DonorLoanListView: View {
    @Binding var loans: [LoanEntry]
    
    var body: some View {
        ForEach(loans.indices, id: \.self) { index in
            // Display each donor loan preference
        }
    }
}

struct InterestListView: View {
    @Binding var interests: [String]
    
    var body: some View {
        ForEach(interests, id: \.self) { interest in
            // Display each interest
        }
    }
}
