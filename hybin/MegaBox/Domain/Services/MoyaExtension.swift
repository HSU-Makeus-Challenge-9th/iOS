//
//  MoyaExtension.swift
//  MegaBox
//
//  Created by 전효빈 on 11/16/25.
//

import Foundation
import Moya

extension MoyaProvider {
    func asyncRequest<T: Decodable>(_ target: Target, responseType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try response.map(T.self)
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        // 디코딩 실패
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    // 네트워크 실패
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
