//
//  LoginViewModel.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 9/26/25.
//

import Foundation
import SwiftUI
import Combine
import Alamofire


struct KakaoTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}

struct KakaoUser: Decodable {
    let id: Int
    let kakaoNickname: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case properties
    }
    
    enum PropertiesKeys: String, CodingKey {
        case nickname
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let properties = try container.nestedContainer(keyedBy: PropertiesKeys.self, forKey: .properties)
        kakaoNickname = try properties.decode(String.self, forKey: .nickname)
    }
}



class LoginViewModel: ObservableObject {
    @AppStorage("userName") private var storedUserName: String = ""
    @Published var userName: String = "" {
        didSet {
            storedUserName = userName
        }
    }
    @Published var id: String = ""
    @Published var pwd: String = ""
    @Published var isLoggedIn: Bool = false
    
    private let accountId = "id"
    private let accountPwd = "1234"
    private let serviceName = "megabox"
    
    init() {
        autoLogin()
    }
    
    //일반 로그인
    func login() {
        guard id == "zero", pwd == "1234" else {
            print("로그인 실패")
            return
        }
        do {
            try KeychainService.shared.save(account: accountId, service: serviceName, password: id)
            try KeychainService.shared.save(account: accountPwd, service: serviceName, password: pwd)
            userName = id
            isLoggedIn = true
            print("로그인 성공, 키체인 저장 완료")
        } catch {
            print("키체인 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func autoLogin() {
        if let savedId = KeychainService.shared.load(account: accountId,service: serviceName),
           let savedPwd = KeychainService.shared.load(account: accountPwd,service: serviceName){
            id = savedId
            pwd = savedPwd
            userName = savedId
            isLoggedIn = true
            print("키체인 자동 로그인 성공 - \(savedId)")
        }else{
            print("키체인에 저장된 로그인 정보 없음")
        }
    }
    
    func logout() {
        KeychainService.shared.delete(account: accountId,service: serviceName)
        KeychainService.shared.delete(account: accountPwd,service: serviceName)
        id = ""
        pwd = ""
        userName = ""
        isLoggedIn = false
        print("로그아웃 완료")
    }
    
    func kakaoLogin(authCode: String, completion: @escaping (Bool) -> Void) {
        let tokenURL = "https://kauth.kakao.com/oauth/token"
        let parameters: [String: Any] = [
            "grant_type": "authorization_code",
            "client_id": "2530e437b7c13ed1ff210e7bd8627554",
            "redirect_uri": "kakao2530e437b7c13ed1ff210e7bd8627554://oauth",
            "code": authCode
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        AF.request(tokenURL, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: KakaoTokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    print("토큰 발급 성공-\(tokenResponse.accessToken)")
                    let userHeaders: HTTPHeaders = [
                        "Authorization": "Bearer \(tokenResponse.accessToken)"
                    ]
                    AF.request("https://kapi.kakao.com/v2/user/me", method: .get, headers: userHeaders)
                        .validate()
                        .responseDecodable(of: KakaoUser.self) { userResponse in
                            switch userResponse.result {
                            case .success(let user):
                                print("카카오 로그인 성공: \(user.kakaoNickname)")
                                self.userName = user.kakaoNickname
                                self.isLoggedIn = true
                                do {
                                    try KeychainService.shared.save(account: "kakaoToken", service: self.serviceName, password: tokenResponse.accessToken)
                                } catch {
                                    print("카카오 토큰 저장 실패: \(error)")
                                }
                                completion(true)
                            case .failure(let error):
                                print("카카오 로그인 실패: \(error)")
                                completion(false)
                            }
                        }
                case .failure(let error):
                    print("토큰 요청 실패: \(error)")
                    completion(false)
                }
            }
    }
}
