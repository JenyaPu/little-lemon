import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var searchText = "" // Step 1: State variable for search text

    // FetchRequest for Dish entities
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))],
        predicate: NSPredicate(value: true), // Initially, we want all dishes
        animation: .default
    ) private var dishes: FetchedResults<Dish>
    
    var body: some View {
        VStack {
            Text("Little Lemon Restaurant")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("Chicago")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Text("Enjoy fresh and delicious meals at the heart of the city.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            Text("Menu")
                .font(.largeTitle)

            TextField("Search menu", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { _ in
                    updatePredicate()
                }

            List {
                ForEach(dishes.filter { dish in
                    searchText.isEmpty || (dish.title?.localizedStandardContains(searchText) ?? false)
                }, id: \.self) { dish in
                    HStack {
                        Text("\(dish.title ?? "Unknown") - \(dish.price ?? "")")
                        Spacer()
                        AsyncImage(url: URL(string: dish.image ?? ""))
                            .scaledToFit()
                            .frame(width: 120, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }

    func getMenuData() {
        let persistence = PersistenceController.shared

        // Clear the database before inserting new data
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Dish.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistence.container.viewContext.execute(deleteRequest)
        } catch {
            print("Error deleting previous data: \(error.localizedDescription)")
        }

        // Fetch data from the API
        guard let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(MenuList.self, from: data)
                
                DispatchQueue.main.async {
                    let context = persistence.container.viewContext
                    
                    for menuItem in decodedData.menu {
                        let newDish = Dish(context: context)
                        newDish.id = UUID()  // ✅ Ensure unique ID
                        newDish.title = menuItem.title
                        newDish.image = menuItem.image
                        newDish.price = menuItem.price
                    }
                    
                    // Save data after inserting
                    do {
                        try context.save()
                    } catch {
                        print("Error saving menu data: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("JSON Parsing error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    // Function to build predicates
    private func updatePredicate() {
        // This function can be used to manage predicate changes if necessary
        // Currently, we're filtering directly in the ForEach
    }
}

#Preview {
    Menu().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
