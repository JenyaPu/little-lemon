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
        
            HeroSection()

            TextField("Search menu", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { _ in
                    updatePredicate()
                }
            
            // Menu Breakdown Tags
            HStack {
                MenuTag(title: "Starters")
                MenuTag(title: "Mains")
                MenuTag(title: "Desserts")
                MenuTag(title: "Drinks")
            }
            .padding(.vertical)

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
            if dishes.isEmpty {  // Only load data if there are no dishes
                getMenuData()
            }
        }
    }

    func getMenuData() {
        let persistence = PersistenceController.shared

        // Step 1: Clear the database before inserting new data
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Dish.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            // Execute the batch delete request
            try persistence.container.viewContext.execute(deleteRequest)

            // Save the context to persist the deletion
            try persistence.container.viewContext.save()
        } catch {
            print("Error deleting previous data: \(error.localizedDescription)")
        }

        // Step 2: Fetch data from the API
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
                    
                    // Step 3: Insert new data
                    for menuItem in decodedData.menu {
                        let newDish = Dish(context: context)
                        newDish.id = UUID()  // Ensure unique ID
                        newDish.title = menuItem.title
                        newDish.image = menuItem.image
                        newDish.price = menuItem.price
                    }
                    
                    // Step 4: Save the context after inserting new data
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
    
    struct MenuTag: View {
        let title: String

        var body: some View {
            Text(title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.black)
                .font(.headline)
        }
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
