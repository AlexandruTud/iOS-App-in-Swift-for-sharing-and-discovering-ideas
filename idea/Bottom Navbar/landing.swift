import SwiftUI

// NAVBAR VIEW
// NAVBAR VIEW
// NAVBAR VIEW 

struct landing: View {

    var body: some View {
        NavigationView {
            ZStack {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    AddCategoryView()
                        .tabItem {
                            Label("Add category", systemImage: "folder.badge.plus")
                        }
                    
                    AddView()
                        .tabItem {
                            Label("Add idea", systemImage: "plus")
                        }
                    
                    CategoriesView()
                        .tabItem {
                            Label("Categories", systemImage: "magnifyingglass")
                        }
                    
                    UsersView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
                .accentColor(.red)
            }
        }
    }
}


#Preview {
    landing()
}
