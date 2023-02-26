//  Created by Bastien Falcou on 8/27/22.

import Foundation

struct Person: Identifiable, Hashable, Decodable {
    // Question: Is there better way to handle the 'id' required by 'Identifiable'?
    // How could we make sure we don't have this warning?
    let id = UUID()
    let name: String
    let language: String?
}

final class People: Decodable, ObservableObject {
    let people: [Person]
}
