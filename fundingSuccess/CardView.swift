//
//  CardView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/30/24.
//

import SwiftUI

struct CardView: View, Identifiable {
    let id = UUID()
    let user: User // Pass the full User object

    @State private var loadedImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 15)
            
            if let loadedImage = loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                // Placeholder for loading image
            }
        }
        .onAppear {
            loadImageAsync(from: user.profilePictureURL)
        }
        .overlay(alignment: .bottom) {
            VStack {
                Text(user.name)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                
                // Button to print user info
                Button(action: {
                    printUserInfo()
                }) {
                    Text("Show Info")
                        .font(.system(.subheadline, design: .rounded))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.top, 10)
            }
            .padding([.bottom], 20)
        }
    }
    
    func loadImageAsync(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    // Function to print all user details
    func printUserInfo() {
        print("User Info: \(user)")
    }
}

#Preview {
    CardView(user: User(name: "Jan Steinhauer", email: "jan@gmail.com", profilePictureURL: "https://example.com/jan.png", currentStreak: Optional(3), education: nil, educationData: nil, experience: nil, experienceData: nil, interests: nil, isDonor: nil, lastLoginDate: nil, loanData: nil, loans: nil, successfulAccomplishmentCategories: nil, matches: nil, mobile: nil, personalData: nil, projectData: nil, projects: nil, rightSwipes: nil, score: nil, sign_up_step_completed: nil))
}
