//  Created by Bastien Falcou on 9/5/22.

import UIKit

extension UIViewController {
    func inject(controller: UIViewController) {
        addChild(controller)
        view.addSubview(controller.view)

        controller.view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                controller.view.topAnchor.constraint(equalTo: view.topAnchor),
                controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
                view.rightAnchor.constraint(equalTo: controller.view.rightAnchor)
            ]
        NSLayoutConstraint.activate(constraints)

        controller.didMove(toParent: self)
    }
}
