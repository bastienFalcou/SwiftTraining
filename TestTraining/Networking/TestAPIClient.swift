//  Created by Bastien Falcou on 8/27/22.

import Foundation

final class TestAPIClient: APIClient {
    private let defaultSession = URLSession(configuration: .default)
    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func perform<T>(request: RequestType,
                    path: String,
                    properties: [String : Any]?,
                    completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        defaultSession.dataTask(with: baseURL.appendingPathComponent(path)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }
            completion(
                Result {
                    try JSONDecoder().decode(T.self, from: data)
                }
            )
        }.resume()
    }

    func perform<T>(request: RequestType,
                    path: String,
                    properties: [String : Any]?) async throws -> T where T: Decodable {
        let url = baseURL.appendingPathComponent(path)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
