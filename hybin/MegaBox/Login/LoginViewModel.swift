//
//  LoginViewModel.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation
import SwiftUI

@Observable
class LoginViewModel {
    
    var userIDInput: String = ""
    var passwordInput: String = ""
    var userName: String = "전효빈"
    var membership: String = "WELLCOME"
    var membershipPoints: Int = 500
    
    
//    func attemptLogin(userSessionManager: UserSessionManager) {
//        let receivedUser = UserModel(
//            userId : userIDInput,
//            password : passwordInput,
//            userName : "전효빈",
//            membership : "VIP",
//            membershipPoints : 1000
//        )
//        
//        userSessionManager.login(user: receivedUser)
//    }
}
//로그인 담당, 타당한 접근인지 확인, 해당하는 토큰을 로그인 담당 로직에 전달
