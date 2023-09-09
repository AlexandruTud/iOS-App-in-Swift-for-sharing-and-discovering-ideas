import SwiftUI
import Firebase
import FirebaseFirestore

struct HomeCategoryView: View {
    @State private var isLoading = false
    @State private var comments: [Comment] = []
    @State private var username = ""
    @State private var commentViewModels: [CommentViewModel] = []
    @State private var isReplySent = false
    @State private var selectedCommentID: String?

    
    private let db = Firestore.firestore()
    var body: some View {
           
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    if isLoading {
                        ProgressView("Loading...") // Show a loading indicator
                            .foregroundColor(.white)
                        EmptyView()
                    } else {
                        VStack {
                            List {
                                ForEach(comments.indices, id: \.self) { index in
                                    let comment = comments[index]
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(comment.username.isEmpty ? "Loading..." : comment.username)
                                                .font(.system(size: 12))
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                            
                                            
                                            
                                            
                                            //Spacer()
                                            
                                            Text(self.formattedTimestamp(comment.timestamp))
                                                .font(.caption)
                                                .foregroundColor(Color.gray)
                                        }
                                        
                                        HStack {
                                            Text(comment.text)
                                                .foregroundColor(Color.white)
                                            Spacer()
                                            
                                            Button(action: {
                                                if let currentUser = Auth.auth().currentUser {
                                                    let currentUserID = currentUser.uid
                                                    if comments[index].isLiked {
                                                        
                                                        let likeQuery = db.collection("likes")
                                                            .whereField("userID", isEqualTo: currentUserID)
                                                            .whereField("commentID", isEqualTo: comments[index].id)
                                                        
                                                        likeQuery.getDocuments { snapshot, error in
                                                            if let error = error {
                                                                print("Error fetching like: \(error)")
                                                                return
                                                            }
                                                            
                                                            guard let documents = snapshot?.documents else {
                                                                return
                                                            }
                                                            
                                                            for document in documents {
                                                                let likeID = document.documentID
                                                                db.collection("likes").document(likeID).delete { error in
                                                                    
                                                                    if let error = error {
                                                                        print("Error deleting like: \(error)")
                                                                        return
                                                                    }
                                                                    
                                                                    db.collection("ideas").document(comments[index].id).updateData(["likes": comments[index].likes - 1]) { error in
                                                                        if let error = error {
                                                                            print("Error updating likes count: \(error)")
                                                                            return
                                                                        }
                                                                        comments[index].likes -= 1
                                                                        comments[index].isLiked = false
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        
                                                        let like = Like(userID: currentUserID, commentID: comments[index].id)
                                                        let likeData: [String: Any] = [
                                                            "userID": like.userID,
                                                            "commentID": like.commentID
                                                        ]
                                                        let likeRef = db.collection("likes").document()
                                                        likeRef.setData(likeData) { error in
                                                            if let error = error {
                                                                print("Error adding like: \(error)")
                                                                return
                                                            }
                                                            db.collection("ideas").document(comments[index].id).updateData(["likes": comments[index].likes + 1]) { error in
                                                                if let error = error {
                                                                    print("Error updating likes count: \(error)")
                                                                    return
                                                                }
                                                                comments[index].likes += 1
                                                                comments[index].isLiked = true
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    // Utilizatorul nu este autentificat, puteți să-l redirecționați la ecranul de autentificare sau să faceți altceva în funcție de necesitățile aplicației dvs.
                                                }
                                            }) {
                                                Image(systemName: comments[index].isLiked ? "flame.fill" : "flame")
                                                    .foregroundColor(comments[index].isLiked ? .red : .white)
                                                
                                            }
                                            .buttonStyle(LikeButtonStyle())
                                        }
                                        .padding(.vertical, 0)
                                        HStack {
                                            Text("\(comments[index].likes) likes")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                            Button(action: {
                                                comments[index].showReplyField.toggle()
                                            }) {
                                                Text("Reply")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.gray)
                                            }
                                            .buttonStyle(LikeButtonStyle())
                                            
                                            Text("View Replies")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .background(
                                                                    NavigationLink("", destination: ReplyListView(commentID: comment.id))
                                                                        .opacity(0)
                                                                )
                                            .buttonStyle(LikeButtonStyle())
                                            

                                            
                                            
                                        }
                                        
                                        if comments[index].showReplyField {
                                            VStack(spacing: 8) {
                                                ZStack(alignment: .bottomTrailing) {
                                                    TextEditor(text: $comments[index].replyText)
                                                        .frame(height: 100)
                                                        .background(Color.black)
                                                        .cornerRadius(10)
                                                        .foregroundColor(.white)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color.red, lineWidth: 1)
                                                        )
                                                        .padding(.horizontal, 10)
                                                        .padding(.top, 5)
                                                    
                                                    Button(action: {
                                                        if !comments[index].replyText.isEmpty {
                                                            // Add your logic here for sending the reply comment to Firebase
                                                            sendReply(commentID: comments[index].id, replyText: comments[index].replyText)
                                                            comments[index].replyText = "" // Reset the text field after sending
                                                            comments[index].showReplyField = false
                                                        }
                                                    }) {
                                                        Image(systemName: "paperplane.fill")
                                                            .foregroundColor(.white)
                                                            .padding(8)
                                                            .background(Color.red)
                                                            .cornerRadius(20)
                                                            .offset(x: -10, y: 0) // Move the button to the left by 5 pixels
                                                    }
                                                    .padding(8)
                                                }
                                            }
                                            
                                        }
                                      

                                        
                                    }
                                    .listRowBackground(Color.black)
                                }
                            }
                            .listStyle(PlainListStyle())
                            .padding(.vertical, 10)
                        }
                        .navigationBarTitle("Home")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
            
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                fetchComments()
            }

        }
    
   // PENTRU RESETARE LIKE-URI
/* func resetLikesForComment(comment: Comment) {
        let commentRef = db.collection("ideas").document(comment.id)
        
        commentRef.updateData(["likes": 0]) { error in
            if let error = error {
                print("Error resetting likes: \(error)")
            } else {
                print("Likes reset to 0 for comment with ID: \(comment.id)")
            }
        }
    } */
    private func sendReply(commentID: String, replyText: String) {
        // Verificați dacă utilizatorul este autentificat
        guard let currentUser = Auth.auth().currentUser else {
            // Dacă utilizatorul nu este autentificat, puteți gestiona această situație aici sau afișa o alertă pentru a-l informa să se autentifice.
            return
        }

        let currentUserID = currentUser.uid

        // Creați un dicționar pentru datele comentariului de răspuns
        let replyData: [String: Any] = [
            "user_email": currentUser.email ?? "", // Puteți utiliza adresa de email a utilizatorului sau alte informații despre utilizator
            
            "comment": replyText,
            "timestamp": FieldValue.serverTimestamp(), // Utilizați serverTimestamp() pentru a stabili marcajul de timp în Firebase
            "likes": 0, // Inițializați numărul de like-uri cu 0
            "replyToCommentID": commentID // Utilizați commentID pentru a urmări comentariul la care se răspunde
        ]

        // Adăugați comentariul de răspuns în colecția Firebase
        db.collection("comments").addDocument(data: replyData) { error in
            if let error = error {
                print("Error sending reply: \(error)")
                // Aici puteți gestiona cazul în care nu s-a putut trimite comentariul de răspuns
            } else {
                // Comentariul de răspuns a fost trimis cu succes
                // Aici puteți actualiza interfața sau face alte acțiuni după trimiterea cu succes
                print("Reply sent successfully!")
            }
        }
    }

    
    private func getUsernameForEmail(_ email: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let usernamesCollection = db.collection("usernames")
        let query = usernamesCollection.whereField("email", isEqualTo: email)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching username: \(error)")
                completion("Username")
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                completion("Username")
                return
            }
            
            if let fetchedUsername = document["username"] as? String {
                completion(fetchedUsername)
            } else {
                completion("Username")
            }
        }
    }
    
    
    
    private func fetchComments() {
        isLoading = true
        let currentUser = Auth.auth().currentUser

        if let currentUser = currentUser {
            let currentUserID = currentUser.uid

            db.collection("ideas")
                .whereField("category", isEqualTo: "Home")
                .getDocuments { [self] snapshot, error in
                    if let error = error {
                        print("Error fetching comments: \(error)")
                        isLoading = false
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        isLoading = false
                        return
                    }

                    var fetchedComments: [Comment] = []
                    var commentViewModels: [CommentViewModel] = []

                    for document in documents {
                        let data = document.data()
                        let userEmail = data["user_email"] as? String ?? ""
                        var comment = Comment(
                                              id: document.documentID,
                                              username: "", // Initialize with an empty string
                                              text: data["comment"] as? String ?? "",
                                              timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                                              likes: data["likes"] as? Int ?? 0,
                                              isLiked: false,
                                              replyToCommentID: data["replyToCommentID"] as? String,
                                              showReplyField: false,
                                              replyText: ""
                                          )



                        fetchedComments.append(comment)

                        getUsernameForEmail(userEmail) { fetchedUsername in
                            if let index = fetchedComments.firstIndex(where: { $0.id == comment.id }) {
                                fetchedComments[index].username = fetchedUsername
                                // Actualizăm username-ul în lista de comentarii
                                comments = fetchedComments
                            }
                        }

                        // Adăugăm codul pentru preluarea like-urilor aici
                        db.collection("likes")
                            .whereField("commentID", isEqualTo: comment.id)
                            .whereField("userID", isEqualTo: currentUserID)
                            .getDocuments { snapshot, error in
                                if let error = error {
                                    print("Error fetching likes: \(error)")
                                    return
                                }

                                if let documents = snapshot?.documents, !documents.isEmpty {
                                    // Acest comentariu a fost marcat ca fiind apreciat de utilizatorul curent
                                    if let index = fetchedComments.firstIndex(where: { $0.id == comment.id }) {
                                        fetchedComments[index].isLiked = true
                                    }
                                }

                                // Actualizăm numărul total de like-uri pentru acest comentariu
                                comment.likes = snapshot?.documents.count ?? 0
                                // Actualizăm lista de comentarii pentru a reflecta modificarea
                                comments = fetchedComments
                                isLoading = false
                            }
                        
                        if let replyToCommentID = comment.replyToCommentID {
                            if let parentCommentIndex = fetchedComments.firstIndex(where: { $0.id == replyToCommentID }) {
                                let commentViewModel = CommentViewModel(
                                    id: comment.id,
                                    username: comment.username,
                                    comment: comment,
                                    replies: [] // Inițializați acest câmp cu un array gol
                                    
                                )
                                
                                if commentViewModels.indices.contains(parentCommentIndex) {
                                    commentViewModels[parentCommentIndex].replies.append(commentViewModel)
                                } else {
                                    commentViewModels.append(CommentViewModel(
                                        id: replyToCommentID,
                                        username: "", // Adăugați username-ul comentariului principal aici
                                        comment: fetchedComments[parentCommentIndex],
                                        replies: [commentViewModel]
                                    ))
                                }
                            }
                        }
                    }
                    // În cele din urmă, actualizați commentViewModels, care conține acum comentariile și răspunsurile lor
                    commentViewModels.forEach { commentViewModel in
                        if let index = fetchedComments.firstIndex(where: { $0.id == commentViewModel.id }) {
                            fetchedComments[index] = commentViewModel.comment
                        }
                    }
                    fetchedComments.sort { $0.likes > $1.likes }
                    comments = fetchedComments
                    isLoading = false
                }
            
        } else {
            // No user is currently authenticated
            // Handle this situation accordingly
            isLoading = false
        }
    }

    
    // Helper function to format the timestamp to the local time zone
    func formattedTimestamp(_ timestamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: timestamp)
    }

}



#Preview {
    HomeCategoryView()
}


