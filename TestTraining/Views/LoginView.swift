//  Created by Bastien Falcou on 9/5/22.

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            WithViewModel(LoginViewModel()) { viewModel in
                VStack {
                    Label("Sign In", image: "")
                    HStack {
                        Text("Login:")
                            .padding(.leading, 16)
                        TextField("Text Here", text: viewModel.binding(\.login))
                    }
                    HStack {
                        Text("Password:")
                            .padding(.leading, 16)
                        TextField("Text Here", text: viewModel.binding(\.password))
                    }
                    NavigationLink("Submit") {
                        PeopleList()
                    }
                    Spacer()
                }
            }
        }
    }
}
