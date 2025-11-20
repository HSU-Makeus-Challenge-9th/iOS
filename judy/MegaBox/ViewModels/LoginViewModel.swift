import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    // 입력
    @Published var id: String = ""
    @Published var pwd: String = ""

    // 상태
    @Published var displayName: String = ""
    @Published var isLoggedIn: Bool = false

    var isLoginEnabled: Bool { !id.isEmpty && !pwd.isEmpty }

    init() {
        if let uid = KeyChainService.read(KCKey.username) {
            id = String(decoding: uid, as: UTF8.self)
        }
        if let pw = KeyChainService.read(KCKey.password) {
            pwd = String(decoding: pw, as: UTF8.self)
        }
        if let dn = KeyChainService.read(KCKey.displayName),
           let name = String(data: dn, encoding: .utf8), !name.isEmpty {
            displayName = name
        }
    }

    // 일반 로그인
    func login() {
        guard isLoginEnabled else { return }
        KeyChainService.save(Data(id.utf8),  for: KCKey.username)
        KeyChainService.save(Data(pwd.utf8), for: KCKey.password)

        if displayName.isEmpty { displayName = id }
        KeyChainService.save(Data(displayName.utf8), for: KCKey.displayName)

        isLoggedIn = true
    }

    func logout() {
        [KCKey.username, KCKey.password, KCKey.displayName,
         KCKey.kakaoAccess, KCKey.kakaoRefresh].forEach { KeyChainService.delete($0) }
        id = ""; pwd = ""; displayName = ""; isLoggedIn = false
    }

    // 화면 등장 시 한 번: 표시명만 보정
    func syncFromKeychainIfNeeded() {
        guard displayName.isEmpty else { return }
        if let dn = KeyChainService.read(KCKey.displayName),
           let name = String(data: dn, encoding: .utf8), !name.isEmpty {
            displayName = name
        } else if let uid = KeyChainService.read(KCKey.username) {
            displayName = String(decoding: uid, as: UTF8.self)
        }
    }
}
