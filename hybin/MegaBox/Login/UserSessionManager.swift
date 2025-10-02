//
//  UserSessionManager.swift
//  MegaBox
//
//  Created by 전효빈 on 9/28/25.
//

import Foundation
import SwiftUI

@Observable
class UserSessionManager {
    
    //Observable은 안에서 선언되는 변수들을 저장, AppStorage도 저장 따라서 동일 변수 이름을 갖는 오류발생... @ObservationIgonred를 붙여서 @AppStorage에 저장하는 변수가 문제 안생기게..
    @ObservationIgnored @AppStorage("ID") private var storedUserID: String = ""
    @ObservationIgnored @AppStorage("PWD") private var storedUserPassword: String = ""
    @ObservationIgnored @AppStorage("Name") private var storedUserName: String = ""
    @ObservationIgnored @AppStorage("Membership") private var storedMembership: String = ""
    @ObservationIgnored @AppStorage("Points") private var storedPoints: Int = 0
    
    var currentUser : UserModel? {
        guard !storedUserID.isEmpty else { return nil } //@Appstorage에 저장된 값이 빈 문자열일 경우 nil 반환 (즉 로그인이 실행이 안된경우)
        
        //UserMembershipLevel은 Enum타입이기에 nil 가능성을 대비
        let level = UserModel.MembershipLevel(rawValue: storedMembership) ?? .wellcome
        
        return UserModel(
            userId: storedUserID,
            password: storedUserPassword,
            userName: storedUserName,
            membership: level,
            membershipPoints: storedPoints
        )
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    //로그인 뷰에서 id,pwd 입력받는 함수
    func login(id: String, password: String) -> Bool {
        guard !id.isEmpty && !password.isEmpty else { return false }
        
        storedUserID = id
        storedUserPassword = password
        storedUserName = "로그인"
        storedMembership = "wellcome"
        storedPoints = 500
        //기본 값 제공
        return true
    }
    //ProfileDetailView에서 이름 바꾸는 함수
    func updateUserName(editName: String) {
        storedUserName = editName
    }
}
