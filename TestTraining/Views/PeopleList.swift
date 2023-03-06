//  Created by Bastien Falcou on 9/5/22.

import SwiftUI

struct PeopleList: View {
    private let apiClient = TestAPIClient(baseURL: URL(string: "https://gist.githubusercontent.com/russellbstephens/")!)

    @Binding var peopleToDisplay: [Person]?     // Question: Do I really need this in the View?

    var body: some View {
        WithViewModel(ViewModel(apiClient: apiClient)) { viewModel in
            List(viewModel.state.people ?? [], id: \.self) { person in
                PersonRow(person: person)
            }.task {
                await viewModel.makeAPICallAsyncAwait()
            }
        }.bind(\.people, to: peopleToDisplay)
    }
}
