import SwiftUI
import Firebase
import FirebaseFirestore

struct ReplyListView: View {
    let commentID: String
    @State private var replies: [Comment] = []
    private let db = Firestore.firestore()
       @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                
                List {
                    ForEach(replies.sorted(by: { $0.timestamp > $1.timestamp })) { reply in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(reply.text.isEmpty ? "Loading..." : reply.text)
                                .foregroundColor(Color.white)
                            
                            Text(self.formattedTimestamp(reply.timestamp))
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            
                            // Restul interacțiunilor, cum ar fi butoane pentru like-uri, etc., pot fi adăugate aici
                        }
                        .listRowBackground(Color.black)
                    }
                }
                .onAppear {
                    fetchReplies()
                }
                .listStyle(PlainListStyle())
                .padding(.vertical, 10)
            }
            .navigationBarTitle("Replys")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    

    private func fetchReplies() {
        db.collection("comments")
            .whereField("replyToCommentID", isEqualTo: commentID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching replies: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    return
                }

                var fetchedReplies: [Comment] = []

                for document in documents {
                    let data = document.data()
                    let reply = Comment(
                        id: document.documentID,
                        username: data["username"] as? String ?? "",
                        text: data["comment"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        likes: data["likes"] as? Int ?? 0,
                        isLiked: false,
                        replyToCommentID: data["replyToCommentID"] as? String,
                        showReplyField: false,
                        replyText: ""
                    )

                    fetchedReplies.append(reply)
                }

                self.replies = fetchedReplies
            }
    }


    // Funcția de formatare a timestamp-ului
    func formattedTimestamp(_ timestamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: timestamp)
    }
}


