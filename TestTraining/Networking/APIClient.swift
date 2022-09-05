//  Created by Bastien Falcou on 8/27/22.

import Foundation

protocol APIClient {
    var baseURL: URL { get }
    func perform<T: Decodable>(request: RequestType,
                               path: String,
                               properties: [String: Any]?,
                               completion: @escaping (Result<T,Error>) -> Void)
}
