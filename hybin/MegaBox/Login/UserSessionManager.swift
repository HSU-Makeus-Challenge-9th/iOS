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
    
    var inputUserID: String = ""
    var inputUserPassword: String = ""
    var inputUserName: String = "Default"
    var inputUserMembership: UserModel.MembershipLevel = UserModel.MembershipLevel.welcome
    var inputUserPoints: Int = 0
    
    var currentUser: UserModel? {
        guard isLoggedIn else {
            return nil
        }
        
        return UserModel(
            userId: inputUserID,
            password: inputUserPassword,
            userName: inputUserName,
            membership: inputUserMembership,
            membershipPoints: inputUserPoints
        )
    }
    
    
    var isLoggedIn:Bool = false
    
    func login(id: String, password:String) -> Bool {
        inputUserID = id
        inputUserPassword = password
        isLoggedIn = true
        
        return true
    }
    
    func updateUserName (editName:String) {
        inputUserName = editName
    }
}
