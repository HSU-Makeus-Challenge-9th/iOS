//
//  LoginModel.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation


struct UserModel {
    var userId: String
    var password: String
    var userName: String
    var membership: MembershipLevel //enum 처리
    var membershipPoints : Int
    
    
    //MARK: MembershipEnum
    enum MembershipLevel : String, CaseIterable , CustomStringConvertible {
        case wellcome = "WELLCOME"
        case bronze = "BRONZE"
        case silver = "SILVER"
        case gold = "GOLD"
        case vip = "VIP"
        
        
        var description: String {
            return self.rawValue
        }
    }
}

