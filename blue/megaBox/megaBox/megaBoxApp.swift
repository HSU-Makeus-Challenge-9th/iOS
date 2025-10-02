//
//  megaBoxApp.swift
//  megaBox
//
//  Created by 은재 on 9/20/25.
//
import SwiftUI

@main
struct megaBoxApp: App {
    @AppStorage("is_logged_in") private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabView()
            } else {
                LoginView();
            }
        }
    }
}
