//
//  DeckView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/30/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct DeckView: View {
    
    var userProfilePictureURL: String?
    var isDonor: Int
    
    @State private var gone = Set<Int>()
    @State private var users: [User] = []
    @State private var scholarshipData: [Scholarship] = []
    @State private var selectedUser: User?
    @State private var selectedScholarship: Scholarship?
    @State private var overlayShown = false
    @State private var swipeDirection: String? = nil
    @State private var currentMx: CGFloat = 0
    @State private var currentProjectImage: [Int: Int] = [:]
    
    @GestureState private var dragState: DragState = .inactive
    @State private var removalTransition = AnyTransition.trailingBottom
    private let dragThreshold: CGFloat = 80.0

    var body: some View {
        ZStack {
            ForEach(0..<dataLength, id: \.self) { i in
                if !gone.contains(i) {
                    DeckItemView(index: i, isDonor: isDonor, userData: users, scholarshipData: scholarshipData, swipeDirection: $swipeDirection, onSwipe: handleSwipe, onClick: handleClick)
                        .zIndex(isTopCard(index: i) ? 1 : 0)
                        .offset(
                            x: isTopCard(index: i) ? dragState.translation.width : 0,
                            y: isTopCard(index: i) ? dragState.translation.height : 0
                        )
                        .scaleEffect(
                            dragState.isDragging && isTopCard(index: i) ? 0.95 : 1.0
                        )
                        .rotationEffect(
                            Angle(degrees: isTopCard(index: i) ? Double(dragState.translation.width / 10) : 0)
                        )
                        .animation(.interpolatingSpring(stiffness: 180, damping: 100), value: dragState.translation)
                        .transition(removalTransition)
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating($dragState, body: { value, state, _ in
                                switch value {
                                case .first(true):
                                    state = .pressing
                                case .second(true, let drag):
                                    state = .dragging(translation: drag?.translation ?? .zero)
                                default:
                                    break
                                }
                            })
                            .onChanged { value in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }
                                if drag.translation.width < -dragThreshold {
                                    removalTransition = .leadingBottom
                                }
                                if drag.translation.width > dragThreshold {
                                    removalTransition = .trailingBottom
                                }
                            }
                            .onEnded { value in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }
                                if drag.translation.width < -dragThreshold || drag.translation.width > dragThreshold {
                                    self.moveCard(index: i)
                                }
                            }
                        )
                }
            }
            if overlayShown {
                OverlayView(selectedUser: selectedUser, selectedScholarship: selectedScholarship, closeOverlay: closeOverlay)
            }
        }
        .onAppear(perform: fetchData)
    }
    
    private var dataLength: Int {
        return isDonor == 1 ? users.count : scholarshipData.count
    }
    
    func fetchData() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }
        
        let db = Firestore.firestore()
        
        if isDonor == 1 {
            db.collection("users").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching users: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No users found.")
                    return
                }
                
                self.users = documents.compactMap { doc -> User? in
                    try? doc.data(as: User.self)
                }
            }
        } else {
            db.collection("scholarships").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching scholarships: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No scholarships found.")
                    return
                }
                
                self.scholarshipData = documents.compactMap { doc -> Scholarship? in
                    try? doc.data(as: Scholarship.self)
                }
            }
        }
    }
    
    func handleSwipe(index: Int, direction: String) {
        swipeDirection = direction
        gone.insert(index)
    }
    
    func handleClick(index: Int) {
        if isDonor == 1 {
            selectedUser = users[index]
        } else {
            selectedScholarship = scholarshipData[index]
        }
        overlayShown = true
    }
    
    func closeOverlay() {
        overlayShown = false
        selectedUser = nil
        selectedScholarship = nil
    }
    
    private func isTopCard(index: Int) -> Bool {
        return index == users.indices.last || index == scholarshipData.indices.last
    }

    private func moveCard(index: Int) {
        gone.insert(index)
    }
}

struct DeckItemView: View {
    var index: Int
    var isDonor: Int
    var userData: [User]
    var scholarshipData: [Scholarship]

    @Binding var swipeDirection: String?
    var onSwipe: (Int, String) -> Void
    var onClick: (Int) -> Void
    
    @State private var loadedImage: UIImage? = nil

    var body: some View {
        guard (isDonor == 1 && userData.indices.contains(index)) ||
              (isDonor != 1 && scholarshipData.indices.contains(index)) else {
            return AnyView(Text("Data not available"))
        }
        
        let data = userData[index]

        return AnyView(
            ZStack {
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    Image("BeaverLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .onAppear {
                            loadImageAsync(from: data.profilePictureURL)
                        }
                }
                
                if swipeDirection == "left" {
                    RedXIcon()
                }
                if swipeDirection == "right" {
                    GreenCheckmark()
                }
            }
            .onTapGesture {
                onClick(index)
            }
        )
    }

    func loadImageAsync(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            }
        }.resume()
    }
}

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .dragging:
            return true
        case .pressing, .inactive:
            return false
        }
    }
    
    var isPressing: Bool {
        switch self {
        case .pressing, .dragging:
            return true
        case .inactive:
            return false
        }
    }
}


struct OverlayView: View {
    var selectedUser: User?
    var selectedScholarship: Scholarship?
    var closeOverlay: () -> Void
    
    var body: some View {
        VStack {
            CloseButton(action: closeOverlay)
            
            if let user = selectedUser {
                UserDetailsView(user: user)
            }
            
            if let scholarship = selectedScholarship {
                ScholarshipDetailsView(scholarship: scholarship)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.9))
        .animation(.easeInOut)
    }
}

struct UserDetailsView: View {
    var user: User
    
    var body: some View {
        VStack {
            Text(user.name)
                .font(.title)
                .foregroundColor(.white)
            
            // Additional user details
        }
    }
}

struct ScholarshipDetailsView: View {
    var scholarship: Scholarship
    
    var body: some View {
        VStack {
            Text(scholarship.name)
                .font(.title)
                .foregroundColor(.white)
            
            // Additional scholarship details
        }
    }
}

struct CloseButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
                .font(.largeTitle)
        }
        .padding()
        .background(Color.clear)
    }
}

struct RedXIcon: View {
    var body: some View {
        Image(systemName: "xmark")
            .font(.largeTitle)
            .foregroundColor(.red)
            .transition(.scale)
    }
}

struct GreenCheckmark: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.largeTitle)
            .foregroundColor(.green)
            .transition(.scale)
    }
}

struct Scholarship: Identifiable, Codable {
    var id: String
    var name: String
    var amount: Int
    var deadline: Date
    var imageURL: String
    // Add other necessary fields
}

func loadImage(from url: String) -> UIImage {
    guard let imageURL = URL(string: url),
          let imageData = try? Data(contentsOf: imageURL),
          let image = UIImage(data: imageData) else {
        return UIImage(named: "default") ?? UIImage()
    }
    return image
}

extension AnyTransition {
    static var trailingBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .identity,
            removal: AnyTransition.move(edge: .trailing).combined(with: .move(edge: .bottom))
        )
    }

    static var leadingBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .identity,
            removal: AnyTransition.move(edge: .leading).combined(with: .move(edge: .bottom))
        )
    }
}
