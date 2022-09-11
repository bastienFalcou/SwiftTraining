//  Created by Bastien Falcou on 8/27/22.

import Foundation

struct Person: Identifiable, Hashable, Decodable {
    let id = UUID()
    let name: String
    let language: String?
}

final class People: Decodable, ObservableObject {
    let people: [Person]
}
