//
//  LoginModel.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation


struct User {
    var id: String
    var password: String
    var name: String
    var membership: MembershipLevel //enum 처리
    var membershipPoints : Int
    
    
    //MARK: MembershipEnum
    enum MembershipLevel : String, CaseIterable , CustomStringConvertible {
        case welcome = "WELCOME"
        case bronze = "BRONZE"
        case silver = "SILVER"
        case gold = "GOLD"
        case vip = "VIP"
        
        
        var description: String {
            return self.rawValue
        }
    }
}

