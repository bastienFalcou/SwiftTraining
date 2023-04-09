//  Created by Bastien Falcou on 9/5/22.

import SwiftUI

struct PeopleList: View {
    private let apiClient = TestAPIClient(baseURL: URL(string: "https://gist.githubusercontent.com/russellbstephens/")!)

    @State private var selectedPerson: Person?
    @State private var receivedErrorInfo: (error: Error, task: Task<Void, Error>)? {
        didSet {
            if oldValue == nil {
                oldValue?.task.cancel()
            }
        }
    }

    var body: some View {
        WithViewModel(ViewModel(apiClient: apiClient)) { viewModel in
            mainView(viewModel: viewModel)
                .onReceive(viewModel.$state.map(\.error)) { error in
                    if let error {
                        withAnimation {
                            receivedErrorInfo = (
                                error,
                                Task {
                                    try await Task.sleep(nanoseconds: 1000000)
                                    withAnimation {
                                        receivedErrorInfo = nil
                                    }
                                }
                            )
                        }
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
                .task {
                    await viewModel.refresh()
                }
            }
        }

    @ViewBuilder private func mainView(viewModel: ViewModel) -> some View {
        switch (viewModel.state.people, viewModel.state.error) {
        case (nil, nil):
            loading
        case (let people?, nil) where !people.isEmpty:
            peopleList(people, viewModel: viewModel)
        case (let people?, _?) where !people.isEmpty:
            ZStack {
                peopleList(people, viewModel: viewModel)
                if let receivedErrorInfo {
                    VStack {
                        VStack(alignment: .center) {
                            Text("An error occured:")
                            Text("\(receivedErrorInfo.error.localizedDescription)")
                        }
                        .frame(maxWidth: .infinity, minHeight: 48.0)
                        .padding()
                        .background(Color.red)
                        .multilineTextAlignment(.center)
                        .lineLimit(10)
                        Spacer()
                    }
                    .onTapGesture {
                        self.receivedErrorInfo = nil
                    }
                }
            }
        case (_, nil):
            empty
        case (_, let error?):
            self.error(error, viewModel: viewModel)
        }
    }

    @ViewBuilder
    private func peopleList(_ people: [Person], viewModel: ViewModel) -> some View {
        List(people, id: \.self, selection: $selectedPerson) { person in
            HStack {
                VStack(alignment: .leading) {
                    Text("Name: **\(person.name)**")
                    Text("Language: \(person.language ?? "N/A")")
                }
            }
            .sheet(item: $selectedPerson) { person in
                EditPersonView(person: person)
                // TODO: Listen to state changes here and dismiss view / update list
            }
        }
    }

    @ViewBuilder
    private var empty: some View {
        Text("No people available.")
    }

    @ViewBuilder
    private var loading: some View {
        VStack {
            Text("Loading...")
            ProgressView()
        }
    }

    @ViewBuilder
    private func error(_ error: Error, viewModel: ViewModel) -> some View {
        VStack {
            Text("An error occured:")
            Text("\(error.localizedDescription)")
            Spacer()
                .frame(height: 16.0)
            Button("Try Again?") {
                Task {
                    await viewModel.refresh()
                }
            }
        }
    }
}
