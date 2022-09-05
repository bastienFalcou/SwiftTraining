//  Created by Bastien Falcou on 9/5/22.

import SwiftUI

struct PeopleList: View {
    @ObservedObject var model: ViewModel

    var body: some View {
        let people = model.people ?? []
        List(people, id: \.self) { person in
            PersonRow(person: person)
        }.errorAlert(error: $model.error)
    }
}
