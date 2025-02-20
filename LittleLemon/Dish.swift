import Foundation
import CoreData

@objc(Dish)
public class Dish: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var price: String?
}
