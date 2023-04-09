//  Created by Bastien Falcou on 8/27/22.

import UIKit
import SwiftUI
import Combine

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let peopleList = PeopleList()
        let controller = UIHostingController(rootView: peopleList)
        inject(controller: controller)
    }
}
