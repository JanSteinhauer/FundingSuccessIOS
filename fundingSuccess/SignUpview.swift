import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct SignUpview: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var mobile: String = ""
    @State private var agreeToTerms: Bool = false
    @State private var profilePicture: UIImage? = nil
    @State private var loading: Bool = false
    @State private var currentUser: User? = nil
    @State private var showSignUpInformation: Bool = false
    @State private var showingImagePicker = false

    let db = Firestore.firestore()
    let storage = Storage.storage()

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Title
                Text("Welcome \(name.isEmpty ? "Student" : name)")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(darkBlue)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Profile Picture
                ProfilePictureInputView(profilePicture: $profilePicture, showingImagePicker: $showingImagePicker)
                    .padding()
                
                // Form
                VStack(spacing: 15) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Mobile", text: $mobile)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                        .padding(.horizontal)
                    
                    Toggle(isOn: $agreeToTerms) {
                        Text("I agree to the Terms of Service")
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Button(action: handleUserData) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(darkBlue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .disabled(!agreeToTerms)
                    
                    if loading {
                        ProgressView()
                            .padding(.top)
                    }
                    
                
                    
                    Button(action: goToSignIn) {
                        Text("Have an account? Sign In")
                            .foregroundColor(darkBlue)
                    }
                    .padding(.top)
                    .navigationDestination(isPresented: $showSignUpInformation) {
                        LoginView()
                    }

                }
                .padding(.bottom)
                
                Spacer()
            }
            .disabled(loading)
            .opacity(loading ? 0.5 : 1)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.profilePicture = image
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all)) // Set background color and make it cover the entire screen
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: setupUser)
        .navigationBarBackButtonHidden(true) 
    }
    
    private func setupUser() {
        if let user = Auth.auth().currentUser {
            currentUser = user
            email = user.email ?? ""
        } else {
            print("No user is currently signed in")
        }
    }
    
    private func handleUserData() {
        loading = true
        
        guard isValidEmail(email) else {
            showError("Please enter a valid email address.")
            return
        }
        
        guard isValidPassword(password) else {
            showError("Password must be at least 8 characters long and contain at least one uppercase letter.")
            return
        }
        
        guard isValidMobile(mobile) else {
            showError("Please enter a valid mobile number.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showError("Error creating user: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else { return }
            
            Task {
                do {
                    let isDonor = try await checkIfDonor(email)
                    let profilePictureURL = try await uploadProfilePicture(userId: user.uid)
                    
                    try await addUserInformation(userId: user.uid, data: [
                        "name": name,
                        "email": email,
                        "mobile": mobile,
                        "profilePictureURL": profilePictureURL ?? "",
                        "isDonor": isDonor ? 1 : 0,
                        "sign_up_step_completed": 0
                    ])
                    
                    showSignUpInformation = true
                } catch {
                    showError("Error updating user data: \(error.localizedDescription)")
                }
                
                loading = false
            }
        }
    }
    
    private func goToSignIn() {
        showSignUpInformation = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[^@]+@[^@]+\\.[^@]+$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func isValidMobile(_ mobile: String) -> Bool {
        let mobileRegex = "^[0-9+]*$"
        return NSPredicate(format: "SELF MATCHES %@", mobileRegex).evaluate(with: mobile)
    }
    
    private func checkIfDonor(_ email: String) async throws -> Bool {
        let donorDoc = try await db.collection("donorsEmail").document("donors").getDocument()
        if donorDoc.exists, let donorData = donorDoc.data() {
            return donorData.values.contains { $0 as? String == email }
        }
        return false
    }
    
    private func uploadProfilePicture(userId: String) async throws -> String? {
        guard let profilePicture = profilePicture, let imageData = profilePicture.jpegData(compressionQuality: 0.8) else { return nil }
        
        let storageRef = storage.reference().child("profilePictures/\(userId).jpg")
        _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
    
    private func addUserInformation(userId: String, data: [String: Any]) async throws {
        try await db.collection("users").document(userId).setData(data)
    }
    
    private func showError(_ message: String) {
        // Implement your own error handling or UI for errors.
        print("Error: \(message)")
        loading = false
    }
}

struct ProfilePictureInputView: View {
    @Binding var profilePicture: UIImage?
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        ZStack {
            if let profilePicture = profilePicture {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .shadow(radius: 5)
            }
            
            Button(action: {
                showingImagePicker = true
            }) {
                Image(systemName: "pencil.circle.fill")
                    .foregroundColor(.gray)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding(5)
            }
            .offset(x: 40, y: 40)
        }
        
    }
    
}

struct SignInView: View {
    var body: some View {
        Text("Sign In View")
    }
}

#Preview {
    NavigationStack {
        SignUpview()
    }
}
