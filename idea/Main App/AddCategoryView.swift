import SwiftUI
import Firebase
import FirebaseFirestore

// ADD CATEGORY VIEW
// ADD CATEGORY VIEW
// ADD CATEGORY VIEW

struct AddCategoryView: View {
    
    @State private var comment: String = ""
    @State private var isShowingPopup = false
    @State var value = ""
    var dropDownList = ["IT", "Food" , "Travel" , "Music", "Fitness", "Nature" , "Fashion" , "Art", "Sports", "Books", "Movies", "Health", "Gaming", "Home", "Animals"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                VStack(spacing: 20) {
                    
                    TextField("Type your suggestion", text: $comment)                
                        .padding(.horizontal, 10)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black)
                                .border(Color.red, width: 1)
                        )
                        .padding(.horizontal,40)
                    
                    Button(action: {
                        saveSuggestion()
                        isShowingPopup.toggle()
                        comment = ""
                    }) {
                        Text("Suggest Your Category")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(50)
                    }
                    .disabled(comment.isEmpty)
                    .opacity(comment.isEmpty ? 0.5 : 1.0)
                    .popover(isPresented: $isShowingPopup, arrowEdge: .top) {
                        PopupView2(isPresented: $isShowingPopup)
                    }
                    
                    NavigationLink(destination: SuggestionsView()) {
                        Text("View your suggestions")
                    }
                    
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func saveSuggestion() {
            guard let user = Auth.auth().currentUser else {
                return
            }

            let db = Firestore.firestore()
        let suggestionData: [String: Any] = [
            "suggestion": comment,
            "user_id": user.uid,
            "user_email": user.email ?? "",
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection("suggestions").addDocument(data: suggestionData) { error in
                if let error = error {
                    print("Error adding suggestion: \(error)")
                } else {
                    print("Suggestion added successfully")
                }
        }
    }
    
    // POPUP THANK YOU
    struct PopupView2: View {
        @Binding var isPresented: Bool
        
        var body: some View {
            ZStack {
                Color.black
                    .opacity(1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Thank You for Your Suggestion!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color.purple)
                    
                    Text("Your suggestions are valuable to us. We appreciate your input in improving our service.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 50)
                            .background(Color.purple)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                .background(Color.black)
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    AddCategoryView()
}
