import SwiftUI
import Firebase
import FirebaseAuth

// LOGIN PAGE
// LOGIN PAGE
// LOGIN PAGE

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedin: Bool = false
    @State private var userIsLoggedIn = false
    @State private var showError = false
    @State private var errorMessage: String? = nil
    @State private var isEmailVerified = false
    @State private var isLoggingIn: Bool = false
    
    var body: some View {
        if userIsLoggedIn && isEmailVerified {
            landing()
                } else if isLoggingIn {
                    ProgressView("Logging in...")
                } else {
                    content
                }
        
    }
    
    var content: some View{
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black
                VStack {
                    Spacer()
                    Text("Welcome back")
                        .font(.title)
                        .bold()
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                                .padding(.leading, 30)
                            
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black)
                                    .border(Color.red, width: 1)
                            )
                            .padding(.bottom, 10)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "lock.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                                .padding(.leading, 30)
                            
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        SecureField("Enter your password", text: $password)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black)
                                    .border(Color.red, width: 1)
                            )
                            .padding(.bottom, 20)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                    }

                    NavigationLink(destination: Signup().navigationBarBackButtonHidden(true)) {
                        Text("You don't have an account yet?")
                            .foregroundColor(.red)
                            .padding(.top, -20)
                            .padding(.leading, 70)
                            .padding(5)
                    }
                    .navigationBarBackButtonHidden(true)
                    
                    Button(action: {
                        isLoggingIn = true
                        login()
                        
                        
                    }) {
                        Text("Login")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 130, height: 50)
                            .background(Color.red)
                            .cornerRadius(50)
                            .padding(.top, 30)
                    }
                    .disabled(email.isEmpty || password.isEmpty) // Disable the button if fields are empty
                           .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1) // Reduce opacity if fields are empty
                           .onTapGesture {
                               // Dismiss the keyboard
                               UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                           }
    
                    // Display the error message in a red text field
                                        if let errorMessage = errorMessage {
                                            Text(errorMessage)
                                                .foregroundColor(.gray)
                                                .padding(.top, 10)
                                               // Adjust horizontal padding
                                        }
  
                    Spacer()
                    
                }
                .padding()

                ColoredCurve()
                    .fullScreenCover(isPresented: $isLoggedin, content: {
                        landing()
                    })
                
            }
            .onAppear() {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if let user = user {
                        userIsLoggedIn = true
                        isEmailVerified = user.isEmailVerified
                    } else {
                        userIsLoggedIn = false
                        isEmailVerified = false
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func login() {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                isLoggingIn = false
                if let error = error {
                    errorMessage = "Invalid email or password. Please check your credentials and try again."
                    showError = true // Show the error alert
                    print("Error logging in: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    if user.isEmailVerified {
                        
                        userIsLoggedIn = true
                    } else {
                        errorMessage = "Please verify your email address to log in."
                        showError = true
                    }
                }
                
            }
    }

    
}

struct ColoredCurve: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                path.addQuadCurve(to: CGPoint(x: 0, y: 0), control: CGPoint(x: geometry.size.width / 2, y: -100))
            }
            .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .top, endPoint: .bottom))
            .frame(height: geometry.size.height * 0.2) // Ajustați înălțimea curbei
            .offset(y: geometry.size.height * 0.9) // Ajustați offset-ul pentru a poziționa în jos
        }
    }
}


#Preview {
    ContentView()
}
