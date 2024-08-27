import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showForgotPassword: Bool = false
    @State private var showSignup: Bool = false
    @State private var showHome: Bool = false
    @State private var showMainPage: Bool = false
    @State private var errorMessage: String = ""
    @State private var rememberMe: Bool = false

    let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Logo
                    FundingSuccessLogoSVGView()
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // Title and Subtitle
                    Text("Welcome back")
                        .font(.largeTitle)
                        .foregroundColor(darkBlue)
                    
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 24)
                    
                    // Form
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            // Remember Me Toggle with Label
                            HStack {
                                Text("Remember me")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Toggle("", isOn: $rememberMe)
                                    .labelsHidden()
                            }
                            
                            // Forgot Password Button
                            Button(action: {
                                showForgotPassword.toggle()
                            }) {
                                Text("Forgot password?")
                                    .foregroundColor(darkBlue)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        // Sign In Button
                        Button(action: onLogin) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(darkBlue)
                                .cornerRadius(5)
                        }
                        
                        // Error Message
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Sign Up
                    Button(action: {
                        showSignup.toggle()
                    }) {
                        Text("Don’t have an account? Sign Up")
                            .foregroundColor(darkBlue)
                    }
                    .padding(.bottom, 20)
                }
                
                // Navigation to Main Page after successful login
                .navigationDestination(isPresented: $showMainPage) {
                                    MainPageView()
                                }
                .navigationDestination(isPresented: $showSignup){
                    SignUpview()
                }
            }
//            .navigate(to: ForgotPasswordView(), when: $showForgotPassword)
//            .navigate(to: SignupView(), when: $showSignup)
//            .navigate(to: HomeView(), when: $showHome)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func onLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            guard let user = authResult?.user else { return }
            fetchUserData(for: user.uid)
        }
    }
    
    private func fetchUserData(for uid: String) {
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let completedStep = data?["sign_up_step_completed"] as? Int ?? 0
                let donor = data?["isDonor"] as? Bool ?? false
                
                if donor {
                    if completedStep < 4 {
                        showSignup.toggle()
                    } else {
                        showMainPage = true
                    }
                } else {
                    if completedStep < 6 {
                        showSignup.toggle()
                    } else {
                        showMainPage = true
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func signInWithGoogle() {
        // Implement Google Sign-In functionality here
    }
}

struct FundingSuccessLogoSVGNoAnimationView: View {
    var body: some View {
        // Your SVG View implementation
        Text("Logo")
    }
}

struct ForgotPasswordView: View {
    var body: some View {
        Text("Forgot Password View")
    }
}

struct SignupView: View {
    var body: some View {
        Text("Signup View")
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
