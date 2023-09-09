import SwiftUI
import Firebase
import FirebaseFirestore

class SuggestionsViewModel: ObservableObject {
    @Published var suggestions: [(suggestion: String, timestamp: Timestamp)] = []

    func fetchUserSuggestions() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let db = Firestore.firestore()

        db.collection("suggestions")
            .whereField("user_id", isEqualTo: user.uid)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching suggestions: \(error)")
                    return
                }

                var suggestionsData: [(suggestion: String, timestamp: Timestamp)] = []

                for document in querySnapshot?.documents ?? [] {
                    if
                        let suggestion = document["suggestion"] as? String,
                        let timestamp = document["timestamp"] as? Timestamp
                    {
                        suggestionsData.append((suggestion: suggestion, timestamp: timestamp))
                    }
                }
                
                // Sort the suggestions by timestamp in descending order (newest first)
                                suggestionsData.sort { $0.timestamp.compare($1.timestamp) == .orderedDescending }

                self.suggestions = suggestionsData
            }
    }
}

struct SuggestionsView: View {
    @ObservedObject var viewModel = SuggestionsViewModel()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                List(viewModel.suggestions, id: \.suggestion) { suggestion in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(suggestion.suggestion)
                            .foregroundColor(.white)
                        Text("\(formatTimestamp(suggestion.timestamp))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(PlainListStyle())
                .padding(.vertical, 10)
            }
            .navigationBarTitle("Your Suggestions")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                viewModel.fetchUserSuggestions()
            }
        }
        
        
    }

    func formatTimestamp(_ timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        return dateFormatter.string(from: timestamp.dateValue())
    }
}



#Preview {
    SuggestionsView()
}
