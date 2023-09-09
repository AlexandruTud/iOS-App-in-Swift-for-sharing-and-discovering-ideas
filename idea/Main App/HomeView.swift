import SwiftUI

// HOME VIEW
// HOME VIEW
// HOME VIEW

struct HomeView: View {
    @State private var isShowingPopup = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Ideal")
                                .font(Font.custom("Renitah", size: 60).weight(.bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.red)
                                .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 2)
                                .padding(.bottom, -40)
                    
                    Text("Unleash your creativity and find inspiration in every corner.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .foregroundColor(Color.white)
                    
                    Button(action: {
                        isShowingPopup.toggle()
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.pink)
                            .cornerRadius(20)
                            .shadow(color: Color.blue.opacity(0.1), radius: 2, x: 0, y: 3)
                    }
                    .popover(isPresented: $isShowingPopup, arrowEdge: .top) {
                        PopupGet(isPresented: $isShowingPopup)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 30)
                    
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            // Square 1
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 180)
                                .foregroundColor(Color.red)
                                .shadow(color: .white.opacity(0.2), radius: 10)
                                .overlay(
                                    VStack {
                                        Text("Discover Ideas")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "lightbulb.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("With our product, you can discover a wide range of ideas.")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                        .padding()
                                )
                                .onTapGesture {
                                    // Handle the action for Square 1
                                }
                            
                            // Square 2
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 180)
                                .foregroundColor(Color.pink)
                                .shadow(color: .white.opacity(0.2), radius: 10)
                                .overlay(
                                    VStack {
                                        Text("Share your idea")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "megaphone.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("You can share your unique ideas with a global community.")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                        .padding()
                                )
                                .onTapGesture {
                                    // Handle the action for Square 2
                                }
                        }
                        .padding(.top, 20)
                        
                        HStack(spacing: 15) {
                            // Square 3
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 180)
                                .foregroundColor(Color.pink)
                                .shadow(color: .white.opacity(0.2), radius: 10)
                                .overlay(
                                    VStack {
                                        Text("Category Based")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "square.grid.2x2.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("Find or share ideas based on specific categories.")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                        .padding()
                                )
                                .onTapGesture {
                                    // Handle the action for Square 3
                                }
                            
                            // Square 4
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 180)
                                .foregroundColor(Color.red)
                                .shadow(color: .white.opacity(0.2), radius: 10)
                                .overlay(
                                    VStack {
                                        Text("Feedback")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "message.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("Offer feedback to help others improve their ideas.")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                        .padding()
                                )
                                .onTapGesture {
                                    // Handle the action for Square 4
                                }
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}



struct PopupGet: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(1)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Welcome to Our Idea Management App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    .foregroundColor(.purple)
                    
                Text("Effortlessly Organize and Explore Creative Concepts")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 15) {
                    GettingStartedItem(number: "1", title: "Add Ideas", description: "Tap the light bulb button to input your idea. Choose a category and provide a description.")
                    
                    GettingStartedItem(number: "2", title: "Suggest Category", description: "Tap the folder button to input your suggestion.")
                    
                    GettingStartedItem(number: "3", title: "Explore Categories", description: "Use the grid button to access categories. Pick a category to see related ideas.")
                    
                    GettingStartedItem(number: "4", title: "Edit Profile", description: "Tap on your profile icon and select 'Edit Profile' to change your username.")
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    isPresented.toggle()
                }) {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(20)
                }
                .padding(.top, 40)
            }
            .padding()
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct GettingStartedItem: View {
    var number: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.purple)
                Text(description)
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    HomeView()
}
