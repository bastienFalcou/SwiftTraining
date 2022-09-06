//  Created by Bastien Falcou on 9/5/22.

import SwiftUI

struct PersonRow: View {
    let person: Person

    init(person: Person) {
        self.person = person
        print(person)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            Text("Name: ").fontWeight(.bold) + Text(person.name)
            Text("Favorite Language: ").fontWeight(.bold) + Text(person.language ?? "None")
        }
    }
}
