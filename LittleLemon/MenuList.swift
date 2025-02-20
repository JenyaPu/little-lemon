import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}

import Foundation

struct MenuItem: Decodable {
    let title: String
    let image: String
    let price: String
    let description: String?
}
