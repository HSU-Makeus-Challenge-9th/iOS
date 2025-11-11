import Observation
import SwiftUICore
import SwiftUI
import Foundation

@Observable
final class LoginModel {
    var id: String = ""
    var pwd: String = ""
}

@Observable
final class LoginViewModel {
    var model: LoginModel = LoginModel()

    private let accountId = "login_id"
    private let accountPwd = "login_pwd"

    func credentialsExist() -> Bool {
        (try? KeychainService.read(account: accountId)) != nil &&
        (try? KeychainService.read(account: accountPwd)) != nil
    }

    func saveCredentials(id: String, pwd: String) throws {
        try KeychainService.save(Data(id.utf8), account: accountId)
        try KeychainService.save(Data(pwd.utf8), account: accountPwd)
    }

    func loadCredentials() -> (id: String, pwd: String)? {
        guard
            let idData = try? KeychainService.read(account: accountId),
            let pwdData = try? KeychainService.read(account: accountPwd),
            let id = String(data: idData, encoding: .utf8),
            let pwd = String(data: pwdData, encoding: .utf8)
        else { return nil }
        return (id, pwd)
    }

    func validate(id: String, pwd: String) -> Bool {
        guard let saved = loadCredentials() else { return false }
        return saved.id == id && saved.pwd == pwd
    }

    func logout() {
        KeychainService.delete(account: accountId)
        KeychainService.delete(account: accountPwd)
    }
}

