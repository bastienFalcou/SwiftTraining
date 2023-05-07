//  Created by Bastien Falcou on 5/7/23.

import Foundation

final class CachingService {
    private let storage = UserDefaults.standard
    
    init() {
        
    }
    
    func retrive(for url: URL, properties: [String : Any]?) -> Data? {
        storage.data(forKey: url.absoluteString)
    }
    
    func cache(_ data: Data?, for url: URL, properties: [String: Any]?) {
        storage.set(data, forKey: url.absoluteString)
        // TODO: figure out how to generate unique key including request
    }
}
