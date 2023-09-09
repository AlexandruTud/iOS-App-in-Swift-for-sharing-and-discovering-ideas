import SwiftUI
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

// PROFILE VIEW
// PROFILE VIEW
// PROFILE VIEW

struct UserProfile: Codable {
    var email: String
    var bioText: String

    func asDictionary() -> [String: Any] {
        return [
            "email": email,
            "bioText": bioText
        ]
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Upload the selected image to Firebase Storage
                uploadImageToFirebase(image: image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func uploadImageToFirebase(image: UIImage) {
            guard let user = Auth.auth().currentUser else {
                return
            }

            // Folosiți UID-ul utilizatorului pentru a crea o cale unică
            let userUID = user.uid
            let filename = "\(userUID)/\(UUID().uuidString).jpg"

            // Referință la Firebase Storage cu calea unică
            let storageRef = Storage.storage().reference().child("profileImages").child(filename)

            // Convert the UIImage to Data
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                // Upload the image data to Firebase Storage
                storageRef.putData(imageData, metadata: nil) { (_, error) in
                    if let error = error {
                        print("Error uploading image to Firebase Storage: \(error.localizedDescription)")
                    } else {
                        // Image uploaded successfully, you can now store the download URL
                        storageRef.downloadURL { (url, error) in
                            if let downloadURL = url {
                                // Save the download URL to Firestore or wherever you want
                                // You can use this URL to display the image later
                                print("Image URL: \(downloadURL.absoluteString)")
                            } else if let error = error {
                                print("Error getting download URL: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
}


struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    var backgroundColor: UIColor
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = backgroundColor
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.layer.cornerRadius = 10
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        
        init(_ parent: TextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

struct UsersView: View {
    @State private var isEditingBio = false
    @State private var bioText: String = ""
    @State private var isLoggedin: Bool = false
    @State private var email: String = ""
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var username: String = "Username"
    @State private var isEditingUsername = false
    @State private var userImages: [UIImage] = []
    

    private let maxWords = 200
    private let maxLines = 10
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.pink)
                        .background(Circle().fill(Color.white))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 6)
                        .onTapGesture {
                            // Deschide ecranul de selecție a imaginilor când se atinge imaginea
                            isImagePickerPresented.toggle()
                        }
                } else {
                    // Display the last uploaded image by the current user
                    if let lastUserImage = userImages.last {
                        Image(uiImage: lastUserImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.pink)
                            .background(Circle().fill(Color.white))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 6)
                            .onTapGesture {
                                // Open the image picker when tapping the image
                                isImagePickerPresented.toggle()
                            }
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.pink)
                            .background(Circle().fill(Color.white))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 6)
                            .onTapGesture {
                                // Deschide ecranul de selecție a imaginilor când se atinge imaginea
                                isImagePickerPresented.toggle()
                            }
                    }
                    
                    let user = Auth.auth().currentUser
                    
                    Group {
                        if isEditingUsername {
                            TextField("Username", text: $username)
                                .font(.system(size: 18))
                                .padding(5)
                                .padding(.horizontal, 30)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                                .onChange(of: username) { newValue in
                                    if newValue.count > 30 {
                                        username = String(newValue.prefix(30))
                                    }
                                }
                        } else {
                            Text(String(username.prefix(30)))
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(5)
                                .padding(.horizontal, 30)
                                .foregroundColor(.white)
                                .padding(.bottom, -15)
                            
                        }
                    }
                    
                    if let email = user?.email {
                        Text("\(email)")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .padding(5)
                            .padding(.horizontal, 30)
                            .foregroundColor(.white)
                            .padding(.bottom, -20)
                    } else {
                        // The user does not have an email address
                    }
                    
                    Group {
                        if isEditingBio {
                            TextViewWrapper(text: $bioText, backgroundColor: .black)
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .frame(height: 100)
                                .padding(5)
                                .onChange(of: bioText) { newValue in
                                    // Split text into words and lines
                                    let words = newValue.split(separator: " ")
                                    let lines = newValue.split(separator: "\n")
                                    
                                    // Trim the text to a maximum of 200 words
                                    let trimmedWords = words.prefix(maxWords)
                                    let trimmedText = trimmedWords.joined(separator: " ")
                                    
                                    // Trim the text to a maximum of 10 lines
                                    let trimmedLines = lines.prefix(maxLines)
                                    bioText = trimmedLines.joined(separator: "\n") + (trimmedLines.count < lines.count ? "\n" : "")
                                    
                                    if newValue.count > 100 {
                                        bioText = String(newValue.prefix(100))
                                    }
                                }
                        } else {
                            Text(bioText)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(5)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Button(action: {
                                if isEditingBio || isEditingUsername {
                                    if !username.isEmpty {
                                        saveBioText()
                                        saveUsername()
                                        isEditingBio.toggle()
                                        isEditingUsername.toggle()
                                    }
                                } else {
                                    isEditingBio.toggle()
                                    isEditingUsername.toggle()
                                }
                            }) {
                                if isEditingBio || isEditingUsername {
                                    Text("Save")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .frame(width: 130)
                                        .background(Color.pink)
                                        .cornerRadius(25)
                                        .opacity(username.isEmpty ? 0.5 : 1.0)
                                } else {
                                    Text("Edit Profile")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .frame(width: 130)
                                        .background(Color.pink)
                                        .cornerRadius(25)
                                }
                            }
                            
                            Button(action: {
                                isImagePickerPresented.toggle()
                            }) {
                                Text("Select image")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .frame(width: 130)
                                    .background(Color.pink)
                                    .cornerRadius(25)
                            }
                            
                            
                            
                            
                        }
                        
                        Button(action: {
                            logout()
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .frame(width: 190)
                                .background(Color.red)
                                .cornerRadius(25)
                        }
                    }
                }
            }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
            .padding(.top, 40)
            .navigationBarTitle("Profile", displayMode: .inline)
        }
        // În funcția onAppear(), înlocuiți recuperarea numelui de utilizator din UserDefaults cu citirea din Firebase
        .onAppear {
            fetchBioText() // Fetch and set the user's bio when the view appears
            fetchUserImages()
            // Citirea numelui de utilizator din Firebase
            guard let user = Auth.auth().currentUser else {
                return
            }
            
            let db = Firestore.firestore()
            let usernamesCollection = db.collection("usernames")
            
            usernamesCollection.document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    if let data = document.data(),
                       let fetchedUsername = data["username"] as? String {
                        username = fetchedUsername
                    }
                }
            }
        }

    }
    
    func fetchUserImages() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let userUID = user.uid
        let storageRef = Storage.storage().reference().child("profileImages/\(userUID)")

        // Listați fișierele în directorul specific utilizatorului
        storageRef.listAll { [self] (result, error) in
            if let error = error {
                print("Error listing files: \(error.localizedDescription)")
                return
            }

            var images: [UIImage] = []

            if let items = result?.items {
                let dispatchGroup = DispatchGroup()

                for item in items {
                    dispatchGroup.enter()
                    item.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                        defer {
                            dispatchGroup.leave()
                        }

                        if let error = error {
                            print("Error downloading image: \(error.localizedDescription)")
                            return
                        }

                        if let data = data, let image = UIImage(data: data) {
                            images.append(image)
                        }
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    // Actualizați array-ul userImages cu imaginile descărcate
                    self.userImages = images
                }
            }
        }
    }


    func logout() {
            do {
                try Auth.auth().signOut()
                isLoggedin = false
            } catch {
                print("Eroare la deconectare: \(error.localizedDescription)")
            }
        }
    
    func saveBioText() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let userProfile = UserProfile(email: user.email ?? "", bioText: bioText)

        // Referință către colecția "userBio" din Firestore
        let db = Firestore.firestore()
        let userBioCollection = db.collection("userBio")

        // Salvare document în colecția "userBio" cu ID-ul bazat pe adresa de email a utilizatorului
        userBioCollection.document(user.email ?? "").setData(userProfile.asDictionary()) { error in
            if let error = error {
                print("Eroare la salvarea bio-ului: \(error.localizedDescription)")
            } else {
                print("Bio salvat cu succes în Firebase!")
            }
        }

    }
    
    func fetchBioText() {
            guard let user = Auth.auth().currentUser else {
                return
            }

            let db = Firestore.firestore()
            let userBioCollection = db.collection("userBio")

            userBioCollection.document(user.email ?? "").getDocument { document, error in
                if let document = document, document.exists {
                    if let data = document.data(),
                       let bio = data["bioText"] as? String {
                        bioText = bio
                    }
                }
            }
        }
    func saveUsername() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        // Obțineți email-ul utilizatorului
        guard let email = user.email else {
            return
        }

        // Referință către colecția "usernames" din Firestore (sau alt nume dorit)
        let db = Firestore.firestore()
        let usernamesCollection = db.collection("usernames")

        // Salvare document în colecția "usernames" cu ID-ul bazat pe UID-ul utilizatorului
        usernamesCollection.document(user.uid).setData(["username": username, "email": email]) { error in
            if let error = error {
                print("Eroare la salvarea numelui de utilizator: \(error.localizedDescription)")
            } else {
                print("Nume de utilizator și email salvate cu succes în Firebase!")
                
                // Puteți afișa aceste date aici sau în altă parte a codului în funcție de nevoile dvs.
            }
        }
    }


}

#Preview {
    UsersView()
}
