//
//  ProfileDetailView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation
import SwiftUI

struct ProfileDetailView: View {
    var body: some View {
        VStack(alignment:.center){
            navigationBarTitle
            
//            userInformation
            Text("name")
            Text("id")
        }.padding(.horizontal,20)
        
    }
    
    private var navigationBarTitle: some View {
        HStack{
            Text("<<")
                .font(.largeTitle)
                .foregroundColor(.primary)
            Spacer()
            Text("profile")
            Spacer()
        }.frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ProfileDetailView()
}
