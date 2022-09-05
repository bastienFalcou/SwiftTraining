//  Created by Bastien Falcou on 8/27/22.

import Foundation

struct Person: Identifiable, Decodable {
    var id: ObjectIdentifier

    let name: String
    let language: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        id = ObjectIdentifier(UniqueIdentifier.generate())
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, language
    }
}

final class People: Decodable, ObservableObject {
    let people: [Person]
}
