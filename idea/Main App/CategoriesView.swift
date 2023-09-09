import SwiftUI

// CATEGORY VIEW
// CATEGORY VIEW
// CATEGORY VIEW

struct CategoriesView: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color.black
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: ITCategoryView()) {
                                    CategoryButtonCat(imageName: "desktopcomputer", categoryName: "IT", color: .white, description: "Find here any ideas for your IT project.")
                                }
                                .frame(width: 160, height: 180)
                                
                                NavigationLink(destination: FoodCategoryView()) {
                                CategoryButtonCat(imageName: "fork.knife", categoryName: "Food", color: .white, description: "Find any ideas for cooking.")
                               }
                                .frame(width: 160, height: 180)
                            }
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: TravelCategoryView()) {
                                CategoryButtonCat(imageName: "airplane", categoryName: "Travel", color: .white, description: "Explore here vacation ideas.")
                                }
                                .frame(width: 160, height: 180)

                                NavigationLink(destination: MusicCategoryView()) {
                                CategoryButtonCat(imageName: "music.note", categoryName: "Music", color: .white, description: "Find your inspiration here.")
                                }
                                .frame(width: 160, height: 180)
                            }
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: FitnessCategoryView()) {
                                CategoryButtonCat(imageName: "figure.walk", categoryName: "Fitness", color: .white, description: "Discover here new fitness techniques.")
                                }
                                .frame(width: 160, height: 180)

                                NavigationLink(destination: NatureCategoryView()) {
                                CategoryButtonCat(imageName: "leaf.fill", categoryName: "Nature", color: .white, description: "Explore the beauty of nature.")
                                }
                                .frame(width: 160, height: 180)
                            }
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: FashionCategoryView()) {
                                CategoryButtonCat(imageName: "bag.fill", categoryName: "Fashion", color: .white, description: " Stay up-to-date with fashion trends.")
                                }
                                .frame(width: 160, height: 180)

                                NavigationLink(destination: ArtCategoryView()) {
                                CategoryButtonCat(imageName: "paintpalette.fill", categoryName: "Art", color: .white, description: "Get creative with art projects.")
                                }
                                .frame(width: 160, height: 180)
                            }
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: SportsCategoryView()) {
                                    CategoryButtonCat(imageName: "sportscourt.fill", categoryName: "Sports", color: .white, description: "Stay active with sports ideas.")
                                }
                                .frame(width: 160, height: 180)

                                NavigationLink(destination: BooksCategoryView()) {
                                    CategoryButtonCat(imageName: "book.fill", categoryName: "Books", color: .white, description: "Dive into the world of books.")
                                }
                                .frame(width: 160, height: 180)
                            }
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: MoviesCategoryView()) {
                                    CategoryButtonCat(imageName: "film.fill", categoryName: "Movies", color: .white, description: "Discover new movie recommendations.")
                                }
                                .frame(width: 160, height: 180)

                                NavigationLink(destination: HealthCategoryView()) {
                                    CategoryButtonCat(imageName: "heart.fill", categoryName: "Health", color: .white, description: "Prioritize your health and well-being.")
                                }
                                .frame(width: 160, height: 180)
                            }
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: GamingCategoryView()) {
                                    CategoryButtonCat(imageName: "gamecontroller.fill", categoryName: "Gaming", color: .white, description: "Level up your gaming experience.")
                                }
                                .frame(width: 160, height: 180)

                                NavigationLink(destination: AdventureCategoryView()) {
                                    CategoryButtonCat(imageName: "binoculars.fill", categoryName: "Adventure", color: .white, description: "Embark on new adventures.")
                                }
                                .frame(width: 160, height: 180)
                            }
                            
                            HStack(spacing: 15) {
                                NavigationLink(destination: AnimalsCategoryView()) {
                                    CategoryButtonCat(imageName: "hare.fill", categoryName: "Animals", color: .white, description: "Explore the animal kingdom.")
                                }
                                .frame(width: 160, height: 180)

                                NavigationLink(destination: HomeCategoryView()) {
                                    CategoryButtonCat(imageName: "house.fill", categoryName: "Home", color: .white,description: "Find home improvement ideas.")
                                }
                                .frame(width: 160, height: 180)
                            }

                            // Adăugați aici celelalte perechi de butoane 
                        }
                        .padding(.vertical, 130)
                    }
                    .navigationTitle("Categories")
                    .navigationBarTitleDisplayMode(.inline)
                    .foregroundColor(Color.white)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
    }
}


// BUTONS CATEGORY VIEW
struct CategoryButtonCat: View {
    let imageName: String
    let categoryName: String
    let color: Color
    let description: String
    
    var body: some View {
        VStack {            
            Text(categoryName)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(description)
                .font(.footnote)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pink)
        .cornerRadius(20)
        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    CategoriesView()
}
