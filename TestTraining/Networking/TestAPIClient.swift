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
        func returnOnMainThread(error: Error) {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        defaultSession.dataTask(with: baseURL.appendingPathComponent(path)) { data, response, error in
            DispatchQueue.global(qos: .background).async {
                if let error = error {
                    returnOnMainThread(error: error)
                    return
                }
                guard let data = data else {
                    returnOnMainThread(error: NetworkingError.noData)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    returnOnMainThread(error: error)
                }
            }
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
