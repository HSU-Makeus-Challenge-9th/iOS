//
//  Untitled.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/19/25.
//
import SwiftUI

struct TheaterBar: View {
    var location: String = "강남"
    var backgroundColor: Color = Color("purple04")
    
    var body: some View {
        HStack{
            Image("map_pin_fill")
                .frame(width: 27, height: 27)
                .padding(.leading, 16)
            Text(location)
                .font(.semiBold13)
                .foregroundStyle(Color("white"))
                .padding(.leading, 10)
            Spacer()
            Button(action: {
                
            }){
                Text("극장 변경")
                    .font(.semiBold13)
                    .foregroundStyle(Color("white"))
            }
            .frame(width: 65, height: 36)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white, lineWidth: 1)
            )
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .background(Color(backgroundColor))
    }
}
