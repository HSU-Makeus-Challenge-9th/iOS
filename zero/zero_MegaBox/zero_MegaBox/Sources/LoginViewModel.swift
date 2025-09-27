//
//  LoginViewModel.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 9/26/25.
//

import Foundation
import SwiftUI

@Observable
class LoginViewModel {
    var id: String = ""
        var pwd: String = ""
    
    let loginModel: [LoginModel] = [
        .init(id: "zero", pwd: "1234")
    ]
}
