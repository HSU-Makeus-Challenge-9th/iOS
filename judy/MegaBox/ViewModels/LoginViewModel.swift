import Foundation
import Observation

@Observable
final class LoginViewModel {
    var model: LoginModel

    init(model: LoginModel = .init()) {
        self.model = model
    }

    var id: String {
        get { model.id }
        set { model.id = newValue }
    }

    var pwd: String {
        get { model.pwd }
        set { model.pwd = newValue }
    }

    var isLoginEnabled: Bool {
        !model.id.isEmpty && !model.pwd.isEmpty
    }
}
