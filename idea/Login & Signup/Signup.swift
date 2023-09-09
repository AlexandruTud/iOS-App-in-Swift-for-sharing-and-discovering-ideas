import SwiftUI
import Firebase

// SIGNUP PAGE
// SIGNUP PAGE
// SIGNUP PAGE

struct Signup: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var email: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var errorMessage: String? = nil //
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                Color.black
                VStack {
                    
                    Spacer()
                    Text("Welcome")
                        .font(.title)
                        .bold()
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "envelope.circle")
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
                    
                    /*VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                                .padding(.leading, 30)
                            
                            Text("Username")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        TextField("Enter your username", text: $username)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black)
                                    .border(Color.red, width: 1)
                            )
                            .padding(.bottom, 10)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                    } */
                    
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
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "lock.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                                .padding(.leading, 30)
                            
                            Text("Confirm Password")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        SecureField("Confirm your password", text: $confirmPassword)
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
                    
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                        Text("Already have an account?")
                            .foregroundColor(.red)
                            .padding(5)
                            .padding(.top, -20)
                            .padding(.leading, 110)
                    }
                    .navigationBarBackButtonHidden(true)
                    
                    Button(action: {
                        register()
                    }) {
                        Text("Signup")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 130, height: 50)
                            .background(Color.red)
                            .cornerRadius(50)
                            .padding(.top, 30)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
                    Spacer()
                    
                }
                .padding()
            }
            .ignoresSafeArea()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Signup"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }

    }
    
    func register() {
            if password == confirmPassword {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        result?.user.sendEmailVerification(completion: { error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                alertMessage = "Registration successful. Please verify your email."
                                email = ""
                                password = ""
                                confirmPassword = ""
                                errorMessage = ""
                                showingAlert = true
                            }
                        })
                    }
                }
            } else {
                errorMessage = "Passwords do not match."
            }
            
            // Afișați alerta numai dacă este setat `alertMessage`
            if !alertMessage.isEmpty {
                showingAlert = true
            }
        }
}


#Preview {
    Signup()
}
