import Moya

extension MoyaProvider {
    func request(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { cont in
            self.request(target) { result in
                switch result {
                case .success(let res):  cont.resume(returning: res)
                case .failure(let err):  cont.resume(throwing: err)
                }
            }
        }
    }
}
