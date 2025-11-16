//
//  UserSessionManager.swift
//  MegaBox
//
//  Created by 전효빈 on 9/28/25.
//

import Foundation
import SwiftUI

@Observable
@MainActor
class UserSessionManager {
    
    var currentUser: User?
    var isLoggedIn: Bool = false
    
    private let userIDKey = "userID"
    private let userPasswordKey = "userPassword"
    private let userNameKey = "userName"
    
    private let mockUsers: [User] = [ // 더미데이터
        User(id: "test", password: "1234", name: "테스트유저", membership: .vip, membershipPoints: 5000),
        User(id: "mega", password: "box", name: "메가박스", membership: .gold, membershipPoints: 1000),
        User(id: "user", password: "user", name: "홍길동", membership: .welcome, membershipPoints: 0),
        
        User(id: "kakaologin", password: "kakaopassword", name: "카카오유저", membership: .welcome, membershipPoints: 0)
    ]
    
    func checkAutoLogin() async -> Bool {
        print("키체인에서 자동 로그인 정보 확인 중...")
        do {
            guard let idData = try KeychainService.read(account: userIDKey),
                  let passwordData = try KeychainService.read(account: userPasswordKey),
                  let id = String(data: idData, encoding: .utf8),
                  let password = String(data: passwordData, encoding: .utf8)
            else {
                print("저장된 키체인 정보 없음. 자동 로그인 실패")
                self.isLoggedIn = false
                return false
            }
            print("저장된 ID(\(id))로 자동 로그인 시도....")
            return await login(id: id, password: password)
        } catch let error {
            print("키체인 읽기 실패" + error.localizedDescription)
            self.isLoggedIn = false
            return false
        }
    }
    
    @discardableResult func login(id: String, password: String) async -> Bool {
        guard let user = mockUsers.first(where: { $0.id == id && $0.password == password}) else{
            print("로그인 실패: ID 또는 PW 불일치")
            self.isLoggedIn = false
            return false
        }
        print("로그인 성공: \(user.name)님")
        self.currentUser = user
        self.isLoggedIn = true
        
        do{
            try KeychainService.save(Data(user.id.utf8), account: userIDKey)
            try KeychainService.save(Data(user.password.utf8), account: userPasswordKey)
            try KeychainService.save(Data(user.name.utf8), account: userNameKey)
            print("키체인에 사용자 정보 저장 완료")
        } catch let error{
            print("키체인 저장 실패: \(error)")
        }
        
        return true
    }
    
    func logout() {
        print("로그아웃 중..")
        self.currentUser = nil
        self.isLoggedIn = false
        
        try? KeychainService.delete(account: userIDKey)
        try? KeychainService.delete(account: userPasswordKey)
        try? KeychainService.delete(account: userNameKey)
        print("키체인에서 사용자 정보 삭제 완료")
    }
    
    func updateUserName(newName: String) {
        self.currentUser?.name = newName
        
        do{
            try KeychainService.save(Data(newName.utf8), account: userNameKey)
            print("키체인에 새 이름 저장 완료")
        }catch let error{
            print("키체인 이름 저장 실패\(error)")
        }
    }
}
