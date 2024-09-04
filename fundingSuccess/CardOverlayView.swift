import SwiftUI

struct CardOverlayView: View {
    let user: User
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the view

    // State variables to toggle sections
    @State private var showEducation = false
    @State private var showExperience = false
    @State private var showInterests = false
    @State private var showProjects = true
    @State private var showLoans = true
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Centered Profile picture and name
                    HStack {
                        if let profilePictureURL = user.profilePictureURL {
                            AsyncImage(url: URL(string: profilePictureURL)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            } placeholder: {
                                Circle()
                                    .foregroundColor(.gray)
                                    .frame(width: 100, height: 100)
                            }
                        }
                           

                        // User's Name
                        Text(user.name)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 10) // Padding above the name
                    }
                    .frame(maxWidth: .infinity) // Center horizontally
                    .padding(.top, 60)
                    .padding(.bottom, 20) // Padding below the picture and name
                    
                    // Education Section with toggle
                    VStack(alignment: .leading, spacing: 10) {
                        ToggleSectionHeader(title: "Education", isExpanded: $showEducation)
                        if showEducation, let education = user.education?.first {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("University:")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(education.university ?? "N/A")
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("Major:")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(education.major ?? "N/A")
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("GPA:")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(education.gpa ?? "N/A")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    
                    // Experience Section with toggle
                    VStack(alignment: .leading, spacing: 10) {
                        ToggleSectionHeader(title: "Experience", isExpanded: $showExperience)
                        if showExperience, let experience = user.experience?.first {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Company:")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(experience.company ?? "N/A")
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("Job Title:")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(experience.jobTitle ?? "N/A")
                                        .foregroundColor(.white)
                                }
                                if let linkedin = experience.linkedin {
                                    HStack {
                                        Text("LinkedIn:")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        Link("View LinkedIn", destination: URL(string: linkedin)!)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    
                    // Interests Section with toggle
                    VStack(alignment: .leading, spacing: 10) {
                        ToggleSectionHeader(title: "Interests", isExpanded: $showInterests)
                        if showInterests, let interests = user.interests {
                            Text(interests.joined(separator: ", "))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }
                    }
                    
                    // Projects Section with toggle (shown by default)
                    VStack(alignment: .leading, spacing: 10) {
                        ToggleSectionHeader(title: "Projects", isExpanded: $showProjects)
                        if showProjects, let projects = user.projects?.first {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Project Name: \(projects.name ?? "N/A")")
                                    .foregroundColor(.white)
                                Text("Description: \(projects.description ?? "N/A")")
                                    .foregroundColor(.white)
                                
                                if let projectPictures = projects.pictures?.first, let imageURL = projectPictures.url {
                                    AsyncImage(url: URL(string: imageURL)) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                            .padding(.top, 10)
                                    } placeholder: {
                                        Rectangle()
                                            .foregroundColor(.gray)
                                            .frame(height: 200)
                                            .cornerRadius(10)
                                            .padding(.top, 10)
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    
                    // Loans Section with toggle (shown by default)
                    VStack(alignment: .leading, spacing: 10) {
                        ToggleSectionHeader(title: "Loans", isExpanded: $showLoans)
                        if showLoans, let loans = user.loans?.first {
                            if let amount = loans.studentTotalLoanAmount {
                                Text("Total Loan Amount: $\(amount)")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                           
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
            }
            .background(fsblue) // Custom FS Blue background color
            
            // Close button at the top right
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .edgesIgnoringSafeArea(.all) // Ensures the background and content cover the full screen
    }
}

struct ToggleSectionHeader: View {
    let title: String
    @Binding var isExpanded: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 5)
    }
}
