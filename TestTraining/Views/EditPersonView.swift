//  Created by Bastien Falcou on 4/9/23.

import SwiftUI

struct EditPersonView: View {
    let person: Person

    init(person: Person) {
        self.person = person
    }

    var body: some View {
        NavigationView {
            WithViewModel(EditPersonViewModel(person: person)) { viewModel in
                // TODO: Display error if validation failed
                if let error = viewModel.state.error {
                    VStack {
                        Text("An error occured:")
                        Text("\(error.localizedDescription)")
                        Spacer()
                            .frame(height: 16.0)
                        Button("Try Again?") {
                            viewModel.reset()
                        }
                    }
                } else {
                    VStack {
                        HStack {
                            Text("Name")
                                .bold()
                            Spacer()
                            TextField("Name", text: viewModel.binding(\.name))
                        }
                        HStack {
                            Text("Language")
                                .bold()
                            Spacer()
                            TextField("Language", text: viewModel.binding(\.language))
                        }
                        Spacer()
                    }
                        .navigationTitle("Edit \(viewModel.name)")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    viewModel.send(.cancel)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Submit") {
                                    viewModel.send(.submit(viewModel.person))
                                }
                            }
                        }
                }
            }
        }
    }
}

private extension HorizontalAlignment {
    struct TextFieldAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }

    static let textFieldAlignmentGuide = HorizontalAlignment(
        TextFieldAlignment.self
    )
}
