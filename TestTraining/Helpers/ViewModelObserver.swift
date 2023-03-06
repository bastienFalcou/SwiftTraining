//  Created by Bastien Falcou on 3/6/23.

import Foundation

public protocol ViewModelObserver: AnyObject { }

public extension ViewModelObserver {
    var objectIdentifier: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
