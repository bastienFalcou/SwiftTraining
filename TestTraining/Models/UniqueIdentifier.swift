//  Created by Bastien Falcou on 9/5/22.

import Foundation

class UniqueIdentifier: Identifiable {
    let id = UUID()

    static func generate() -> UniqueIdentifier {
        return UniqueIdentifier()
    }
}
