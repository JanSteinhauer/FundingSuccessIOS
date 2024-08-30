//
//  Tinder.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/30/24.
//


import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Tinder: View {
    @GestureState private var dragState: DragState = .inactive
    @State private var lastIndex = 1
    @State private var removalTransition = AnyTransition.trailingBottom
    @State private var users: [User] = []

    private let dragThreshold: CGFloat = 80.0

    var body: some View {
        VStack {
            ZStack {
                ForEach(cardViews) { view in
                    view
                        .zIndex(isTopCard(cardView: view) ? 1 : 0)
                        .overlay {
                            actionImage(for: view)
                        }
                        .offset(
                            x: isTopCard(cardView: view) ? dragState.translation.width : 0,
                            y: isTopCard(cardView: view) ? dragState.translation.height : 0
                        )
                        .scaleEffect(
                            dragState.isDragging && isTopCard(cardView: view) ? 0.95 : 1.0
                        )
                        .rotationEffect(
                            Angle(degrees: isTopCard(cardView: view) ? Double(dragState.translation.width / 10) : 0)
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

                                if drag.translation.width < -dragThreshold ||
                                    drag.translation.width > dragThreshold
                                {
                                    self.moveCard()
                                }
                            }
                        )
                }
            }

            Spacer(minLength: 20)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default, value: dragState.isDragging)
        }
        .padding()
        .onAppear {
            fetchData()
        }
    }

    @State private var cardViews: [CardView] = []

    private func actionImage(for view: CardView) -> some View {
        ZStack {
            Image(systemName: "x.circle")
                .foregroundStyle(Color.white)
                .font(.system(size: 100))
                .opacity(
                    dragState.translation.width < -dragThreshold && isTopCard(cardView: view) ? 1.0 : 0
                )

            Image(systemName: "heart.circle")
                .foregroundStyle(Color.white)
                .font(.system(size: 100))
                .opacity(
                    dragState.translation.width > dragThreshold && isTopCard(cardView: view) ? 1.0 : 0
                )
        }
    }
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }

        return index == 0
    }

    private func moveCard() {
        cardViews.removeFirst()

        lastIndex += 1
        let user = users[lastIndex % users.count]

        let newCardView = CardView(image: user.profilePictureURL!, title: user.name)

        cardViews.append(newCardView)
    }
    
    func fetchData() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }
        
        let db = Firestore.firestore()

        db.collection("users")
            .whereField("sign_up_step_completed", isGreaterThanOrEqualTo: 6)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching users: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No users found.")
                    return
                }
                
                let fetchedUsers = documents.compactMap { doc -> User? in
                    try? doc.data(as: User.self)
                }
                
                DispatchQueue.main.async {
                    self.users.append(contentsOf: fetchedUsers)
                    self.updateCardViews()
                }
            }
    }

    private func updateCardViews() {
        cardViews = users.prefix(2).map { user in
            CardView(image: user.profilePictureURL!, title: user.name)
        }
    }
}

struct Students {
    var userName: String
    var image: String
}

var students = [
    User(name: "Jan", email: "tests123", profilePictureURL:"BeaverLogo"),
    User(name: "Jan1", email: "tests123", profilePictureURL:"FundingSuccessLogo"),
    User(name: "Jan2", email: "tests123", profilePictureURL:"BeaverLogo"),
    User(name: "Jan3", email: "tests123", profilePictureURL:"BeaverLogo"),
]

#Preview {
    Tinder()
}
