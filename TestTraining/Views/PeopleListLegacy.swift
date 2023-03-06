//  Created by Bastien Falcou on 9/5/22.

import SwiftUI

struct PeopleListLegacy: View {
    @ObservedObject var model: LegacyViewModel

    var body: some View {
        let people = model.people ?? []
        List(people, id: \.self) { person in
            PersonRow(person: person)
        }.task {
            await model.makeAPICallAsyncAwait()
        }
    }
}
