//  Created by Bastien Falcou on 8/27/22.

import UIKit
import SwiftUI
import Combine

final class ViewController: UIViewController {
    private var viewModel = ViewModel(apiClient: TestAPIClient(baseURL: URL(string: "https://gist.githubusercontent.com/russellbstephens/")!))
    private var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        let peopleList = PeopleList(model: viewModel)   // Question: Is it ok to inject the ViewModel in the View?
        let controller = UIHostingController(rootView: peopleList)
        inject(controller: controller)
    }
}
