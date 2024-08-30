//
//  MainPagevView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/27/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct MainPageView: View {
    @State private var selectedComponent: String = "swipe"
    @State private var userData: [String: Any] = [:]
    
    var body: some View {
        VStack {
            HeaderViewMainPage(selectedComponent: $selectedComponent, userData: $userData)
            
            ContentViewMainpage(selectedComponent: selectedComponent, userData: userData)
            
            NavBar(selectedComponent: $selectedComponent, isDonor: userData["isDonor"] as? Int ?? 0)
                .padding(.top, 20)
        }
        .onAppear {
            fetchUserData()
            if let user = Auth.auth().currentUser {
                updateUserStreak(uid: user.uid)
            }
        }
        .navigationBarBackButtonHidden(true) 
    }
    
    func fetchUserData() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(currentUserUid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                userData = document.data() ?? [:]
            } else {
                print("No such document!")
            }
        }
    }
    
    func updateUserStreak(uid: String) {
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data() ?? [:]
                let lastLoginDate = (userData["lastLoginDate"] as? Timestamp)?.dateValue()
                let currentDate = Date()
                let oneDay: TimeInterval = 24 * 60 * 60
                
                if let lastLoginDate = lastLoginDate {
                    let diffDays = Int(currentDate.timeIntervalSince(lastLoginDate) / oneDay)
                    if diffDays == 1 {
                        userRef.updateData([
                            "currentStreak": (userData["currentStreak"] as? Int ?? 0) + 1,
                            "lastLoginDate": Timestamp(date: currentDate)
                        ])
                    } else if diffDays > 1 {
                        userRef.updateData([
                            "currentStreak": 0,
                            "lastLoginDate": Timestamp(date: currentDate)
                        ])
                    }
                } else {
                    userRef.updateData([
                        "currentStreak": 1,
                        "lastLoginDate": Timestamp(date: currentDate)
                    ])
                }
            } else {
                print("No such document!")
            }
        }
    }
}

struct HeaderViewMainPage: View {
    @Binding var selectedComponent: String
    @Binding var userData: [String: Any]
    
    @State private var isTapped = false
    
    var body: some View {
        HStack {
            BeaverLogoBlinkAnimationView()
            
            Spacer()
            
            HStack {
                StreakButtonView(streak: userData["currentStreak"] as? Int ?? 0)
                
                if let profilePictureURL = userData["profilePictureURL"] as? String, let url = URL(string: profilePictureURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .scaleEffect(isTapped ? 1.1 : 1.0) // Scale on tap
                            .animation(.easeInOut(duration: 0.2), value: isTapped) // Add animation
                            .onTapGesture {
                                withAnimation {
                                    isTapped = true
                                    selectedComponent = "profile"
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isTapped = false
                                    }
                                }
                            }
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
        .padding()
    }
}


struct StreakButtonView: View {
    var streak: Int
    
    @State private var isTapped = false
    
    var body: some View {
        Text("🔥 \(streak)")
            .padding(10)
            .background(isTapped ? Color.orange : Color.red) // Change color on tap
            .foregroundColor(.white)
            .cornerRadius(20)
            .scaleEffect(isTapped ? 1.1 : 1.0) // Scale up on tap
            .animation(.easeInOut(duration: 0.2), value: isTapped) // Add animation
            .onTapGesture {
                withAnimation {
                    isTapped = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        isTapped = false
                    }
                }
            }
    }
}


struct ContentViewMainpage: View {
    var selectedComponent: String
    var userData: [String: Any]
    
    var body: some View {
        VStack {
            switch selectedComponent {
            case "profile":
                ProfileView(userData: userData)
                    .transition(.slide) // Slide transition
                    .animation(.easeInOut, value: selectedComponent) // Add animation
            case "chat":
                ChatView()
                    .transition(.opacity) // Fade transition
                    .animation(.easeInOut, value: selectedComponent) // Add animation
            case "success":
                SuccessesView(userData: userData)
                    .transition(.scale) // Scale transition
                    .animation(.spring(), value: selectedComponent) // Add animation
            case "addScholarship":
                ScholarshipFormView()
                    .transition(.opacity.combined(with: .move(edge: .bottom))) // Combined transition
                    .animation(.easeInOut, value: selectedComponent) // Add animation
            case "swipe":
//                DeckView(userProfilePictureURL: userData["profilePictureURL"] as? String, isDonor: userData["isDonor"] as? Int ?? 0)
//                    .transition(.scale(scale: 0.5, anchor: .center)) // Scale transition with anchor
//                    .animation(.spring(), value: selectedComponent) // Add animation
                Tinder()
            default:
                Text("Loading...")
                    .transition(.opacity) // Fade transition
                    .animation(.easeInOut, value: selectedComponent) // Add animation
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
    }
}

struct NavBar: View {
    @Binding var selectedComponent: String
    var isDonor: Int
    
    var body: some View {
        HStack {
            NavBarItem(icon: "house.fill", title: "Home") {
                selectedComponent = "swipe"
            }
            NavBarItem(icon: "message.fill", title: "Chat") {
                selectedComponent = "chat"
            }
            if isDonor == 1 {
                NavBarItem(icon: "plus.circle.fill", title: "Scholarship") {
                    selectedComponent = "addScholarship"
                }
            } else {
                NavBarItem(icon: "briefcase.fill", title: "Successes") {
                    selectedComponent = "success"
                }
            }
        }
        .padding()
        .background(darkBlue)
        .foregroundColor(.white)
    }
}

struct NavBarItem: View {
    var icon: String
    var title: String
    var action: () -> Void
    
    @State private var isTapped = false
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .scaleEffect(isTapped ? 1.2 : 1.0) // Scale up on tap
                .animation(.easeInOut(duration: 0.2), value: isTapped) // Add animation
            Text(title)
                .font(.caption)
                .scaleEffect(isTapped ? 1.2 : 1.0) // Scale up on tap
                .animation(.easeInOut(duration: 0.2), value: isTapped) // Add animation
        }
        .onTapGesture {
            withAnimation {
                isTapped = true
            }
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    isTapped = false
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}


struct BeaverLogoBlinkAnimationView: View {
    var body: some View {
        Image("BeaverLogo") // Replace with your actual logo
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
}

struct ProfileView: View {
    var userData: [String: Any]
    
    var body: some View {
        Text("Profile View")
    }
}

struct ChatView: View {
    var body: some View {
        Text("Chat View")
    }
}

struct SuccessesView: View {
    var userData: [String: Any]
    
    var body: some View {
        Text("Successes View")
    }
}

struct ScholarshipFormView: View {
    var body: some View {
        Text("Scholarship Form")
    }
}



struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}


