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

struct EditPersonView_Preview: PreviewProvider {
    static var previews: some View {
        EditPersonView(person: .init(name: "Stéphaneasdasda", language: "Swift"))
    }
}
