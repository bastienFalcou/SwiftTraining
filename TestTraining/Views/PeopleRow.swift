//  Created by Bastien Falcou on 9/5/22.

import SwiftUI

struct PersonRow: View {
    let person: Person

    var body: some View {
        Text("Name: \(person.name)")
        Text("Favorite Language: \(person.language ?? "None")")
    }
}
