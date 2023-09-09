import SwiftUI
import Firebase
import FirebaseFirestore

// ADD IDEA VIEW
// ADD IDEA VIEW
// ADD IDEA VIEW

struct AddView: View {
    @State private var comment: String = ""
    @State private var selectedCategory: String = ""
    var placeholder = "Select a category"
    var dropDownList = ["IT", "Food", "Travel", "Music", "Fitness", "Nature", "Fashion", "Art", "Sports", "Books", "Movies", "Health", "Gaming","Adventure", "Animals", "Home"]
    @State private var isShowingPopup = false
    @State private var isCommentTooLong = false


    var body: some View {
        ZStack {
            Color.black
            VStack(spacing: 20) {

                TextField("Type your idea", text: $comment)
                    .padding(.horizontal, 10)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black)
                            .border(Color.red, width: 1)
                    )
                    .padding(.horizontal, 40)
                    .onChange(of: comment) { newValue in
                        isCommentTooLong = newValue.count > 1000
                    }


                Menu {
                    ForEach(dropDownList, id: \.self) { category in
                        Button(category) {
                            self.selectedCategory = category
                        }
                    }
                } label: {
                    VStack(spacing: 5) {
                        HStack {
                            Text(selectedCategory.isEmpty ? placeholder : selectedCategory)
                                .foregroundColor(selectedCategory.isEmpty ? .gray : .white)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.orange)
                                .font(Font.system(size: 20, weight: .bold))

                        }
                        .padding(.horizontal, 40)
                        Rectangle()
                            .fill(Color.red)
                            .frame(height: 1)
                            .padding(.horizontal, 40)
                    }
                }
                .padding(.bottom, 20)

                if isCommentTooLong {
                    Text("Comment is too long (max 1000 characters)")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.bottom, 5)
                }
                
                Button(action: {
                    if isCommentTooLong {
                        // Poți face aici o acțiune suplimentară în caz de eroare
                    } else {
                        saveIdea()
                        isShowingPopup.toggle()
                        comment = ""
                        selectedCategory = ""
                    }
                }) {
                    Text("Add Your Idea")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(50)
                }
                .disabled(comment.isEmpty || selectedCategory.isEmpty || isCommentTooLong)
                .opacity((comment.isEmpty || selectedCategory.isEmpty || isCommentTooLong) ? 0.5 : 1.0)
                .popover(isPresented: $isShowingPopup, arrowEdge: .top) {
                    PopupView(isPresented: $isShowingPopup)
                }
            }
        }
        .ignoresSafeArea()
    }

    
    
    func saveIdea() {
        guard let user = Auth.auth().currentUser else {
            // User is not authenticated, handle accordingly
            return
        }

        let db = Firestore.firestore()
        let ideaData: [String: Any] = [
            "comment": comment,
            "category": selectedCategory,
            "user_id": user.uid,
            "user_email": user.email ?? "",
            "timestamp": FieldValue.serverTimestamp() // This adds a timestamp
        ]

        db.collection("ideas").addDocument(data: ideaData) { error in
            if let error = error {
                print("Error adding idea: \(error)")
            } else {
                print("Idea added successfully")
            }
        }
    }
}


struct PopupView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Thank You for Sharing Your Idea!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color.purple)
                
                Text("Your ideas matter to us. We appreciate your contribution.")
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



#Preview {
    AddView()
}
