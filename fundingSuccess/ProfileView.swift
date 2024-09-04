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




struct EditableExperienceListView: View {
    @Binding var experience: [ExperienceEntry]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(experience.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Job Title", text: Binding(
                        get: { experience[index].jobTitle },
                        set: { experience[index].jobTitle = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Company", text: Binding(
                        get: { experience[index].company },
                        set: { experience[index].company = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Location", text: Binding(
                        get: { experience[index].location },
                        set: { experience[index].location = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        experience.remove(at: index)
                    }) {
                        Text("Remove Experience")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            Button(action: {
                experience.append(ExperienceEntry()) // Add a new empty experience entry
            }) {
                Text("Add Experience")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fsblue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}

struct EditableEducationListView: View {
    @Binding var education: [EducationEntry]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(education.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("University", text: Binding(
                        get: { education[index].university },
                        set: { education[index].university = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Major", text: Binding(
                        get: { education[index].major },
                        set: { education[index].major = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("GPA", text: Binding(
                        get: { education[index].gpa },
                        set: { education[index].gpa = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        education.remove(at: index)
                    }) {
                        Text("Remove Education")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            Button(action: {
                education.append(EducationEntry()) // Add a new empty education entry
            }) {
                Text("Add Education")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fsblue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}

struct EditableUniversityPreferencesListView: View {
    @Binding var universities: [EducationEntry]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(universities.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("University", text: Binding(
                        get: { universities[index].university },
                        set: { universities[index].university = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Major", text: Binding(
                        get: { universities[index].major },
                        set: { universities[index].major = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        universities.remove(at: index)
                    }) {
                        Text("Remove University")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            Button(action: {
                universities.append(EducationEntry()) // Add a new empty university entry
            }) {
                Text("Add University")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fsblue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}

struct EditableLoanListView: View {
    @Binding var loans: [LoanEntry]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(loans.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Loan Amount", text: Binding(
                        get: { loans[index].studentTotalLoanAmount },
                        set: { loans[index].studentTotalLoanAmount = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Due Date", text: Binding(
                        get: { loans[index].studentLoanDueDate },
                        set: { loans[index].studentLoanDueDate = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        loans.remove(at: index)
                    }) {
                        Text("Remove Loan")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            Button(action: {
                loans.append(LoanEntry()) // Add a new empty loan entry
            }) {
                Text("Add Loan")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fsblue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}


struct EditableInterestsListView: View {
    @Binding var interests: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(interests.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Interest", text: Binding(
                        get: { interests[index] },
                        set: { interests[index] = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        interests.remove(at: index)
                    }) {
                        Text("Remove Interest")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            Button(action: {
                interests.append("") // Add a new empty interest entry
            }) {
                Text("Add Interest")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fsblue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}

struct EditableProjectsListView: View {
    @Binding var projects: [ProjectEntry]
    
    var body: some View {
        VStack(spacing: 20) {
        
            ForEach(projects.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Project Name", text: Binding(
                        get: { projects[index].name },
                        set: { projects[index].name = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Description", text: Binding(
                        get: { projects[index].description },
                        set: { projects[index].description = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Contribution", text: Binding(
                        get: { projects[index].contribution },
                        set: { projects[index].contribution = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Display images for this project
                    Text("Project Images")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(projects[index].pictures, id: \.self) { imageUrl in
                                if let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(5)
                                    } placeholder: {
                                        ProgressView() // Placeholder while image is loading
                                    }
                                } else {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.red)
                                        .padding(5)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        projects.remove(at: index)
                    }) {
                        Text("Remove Project")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            Button(action: {
                projects.append(ProjectEntry()) // Add a new empty project entry
            }) {
                Text("Add Project")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fsblue)
                    .cornerRadius(8)
            }
            .padding(.top)
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
                }.foregroundColor(fsblue)
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
