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
                            .foregroundColor(fsblue)
                        if showExperience {
                            EditableExperienceListView(experience: $experience)
                        }
                        
                        SectionToggleView(showSection: $showEducation, title: "Education")
                            .foregroundColor(fsblue)
                        if showEducation {
                            EditableEducationListView(education: $education)
                        }
                        
                        SectionToggleView(showSection: $showLoans, title: "Loans")
                            .foregroundColor(fsblue)
                        if showLoans {
                            EditableLoanListView(loans: $loans)
                        }
                        
                        SectionToggleView(showSection: $showProjects, title: "Projects")
                            .foregroundColor(fsblue)
                        if showProjects {
                            EditableProjectsListView(projects: $projects)
                        }
                    }
                    
                    if userData["isDonor"] as? Int == 1 {
                        SectionToggleView(showSection: $showUniversities, title: "University Preferences")
                            .foregroundColor(fsblue)
                        if showUniversities {
                            EditableUniversityPreferencesListView(universities: $education)
                        }
                        
                        SectionToggleView(showSection: $showDonorsLoan, title: "Loan Preferences")
                            .foregroundColor(fsblue)
//                        if showDonorsLoan {
//                            EditableDonorLoanListView(loans: $loans)
//                        }
                    }
                    
                    SectionToggleView(showSection: $showInterests, title: "Interests")
                        .foregroundColor(fsblue)
                    if showInterests {
                        EditableInterestsListView(interests: $interests)
                    }
                }
                
                Button(action: {
                    handleUpdateProfile()
                }) {
                    Text("Update Profile")
                        .bold()
                        .padding()
                        .background(fsblue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .scrollIndicators(.never) // Hide the scrollbars
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
                experience = mapToExperienceEntries(userData["experience"] as? [[String: Any]] ?? [])
                education = mapToEducationEntries(userData["education"] as? [[String: Any]] ?? [])
                interests = userData["interests"] as? [String] ?? []
                loans = mapToLoanEntries(userData["loans"] as? [[String: Any]] ?? [])
                projects = mapToProjectEntries(userData["projects"] as? [[String: Any]] ?? [])
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
            "experience": experience.map { $0.toDictionary() },
            "education": education.map { $0.toDictionary() },
            "interests": interests,
            "loans": loans.map { $0.toDictionary() },
            "projects": projects.map { $0.toDictionary() }
        ], merge: true) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully")
            }
        }
    }
    
    // Mapping functions to convert Firestore data into the appropriate Swift structures
    func mapToExperienceEntries(_ data: [[String: Any]]) -> [ExperienceEntry] {
        return data.map { dict in
            ExperienceEntry(
                jobTitle: dict["jobTitle"] as? String ?? "",
                company: dict["company"] as? String ?? "",
                location: dict["location"] as? String ?? "",
                startDate: dict["startDate"] as? String ?? "",
                endDate: dict["endDate"] as? String ?? "",
                linkedin: dict["linkedin"] as? String ?? ""
            )
        }
    }
    
    func mapToEducationEntries(_ data: [[String: Any]]) -> [EducationEntry] {
        return data.map { dict in
            EducationEntry(
                university: dict["university"] as? String ?? "",
                major: dict["major"] as? String ?? "",
                gpa: dict["gpa"] as? String ?? "",
                startDate: dict["startDate"] as? String ?? "",
                endDate: dict["endDate"] as? String ?? ""
            )
        }
    }
    
    func mapToLoanEntries(_ data: [[String: Any]]) -> [LoanEntry] {
        return data.map { dict in
            LoanEntry(
                successfulAccomplishmentCategories: dict["successfulAccomplishmentCategories"] as? [String] ?? [],
                studentLoanDueDate: dict["studentLoanDueDate"] as? String ?? "",
                studentTotalLoanAmount: dict["studentTotalLoanAmount"] as? String ?? ""
            )
        }
    }
    
    func mapToProjectEntries(_ data: [[String: Any]]) -> [ProjectEntry] {
        return data.map { dict in
            // Extracting pictures as an array of dictionaries and mapping the "url" field
            let pictures = (dict["pictures"] as? [[String: Any]])?.compactMap { $0["url"] as? String } ?? []
            
            return ProjectEntry(
                name: dict["name"] as? String ?? "",
                description: dict["description"] as? String ?? "",
                contribution: dict["contribution"] as? String ?? "",
                success: dict["success"] as? String ?? "",
                benefit: dict["benefit"] as? String ?? "",
                pictures: pictures // Now correctly mapped to URLs
            )
        }
    }


}

// Extension to convert the data back to dictionaries for Firestore
extension ExperienceEntry {
    func toDictionary() -> [String: Any] {
        return [
            "jobTitle": jobTitle,
            "company": company,
            "location": location,
            "startDate": startDate,
            "endDate": endDate,
            "linkedin": linkedin
        ]
    }
}

extension EducationEntry {
    func toDictionary() -> [String: Any] {
        return [
            "university": university,
            "major": major,
            "gpa": gpa,
            "startDate": startDate,
            "endDate": endDate
        ]
    }
}

extension LoanEntry {
    func toDictionary() -> [String: Any] {
        return [
            "successfulAccomplishmentCategories": successfulAccomplishmentCategories,
            "studentLoanDueDate": studentLoanDueDate,
            "studentTotalLoanAmount": studentTotalLoanAmount
        ]
    }
}

extension ProjectEntry {
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "description": description,
            "contribution": contribution,
            "success": success,
            "benefit": benefit,
            "pictures": pictures.map { ["url": $0] } // Convert the pictures back to dictionary format
        ]
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
                }.foregroundColor(fsblue)
            }
            .padding(.bottom, 20)
        }
    }


