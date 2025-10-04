//
//  MovieDetailView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/4/25.
//

import Foundation
import SwiftUI

struct MovieDetailView: View {
    @Environment(\.dismiss) private var dismiss
//    @Binding var path: NavigationPath
    let movie: Movie

    @State private var selectedTab: Int = 0
    
    
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    dismiss()
    //                if !path.isEmpty {
    //                        path.removeLast()
    //                    } else {
    //                        dismiss()
    //                    }
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color("black"))
                }
                Spacer()
                Text(movie.title)
                    .font(.medium16)
                    .foregroundStyle(Color("black"))
                Spacer()
            }
            Image(movie.image)
            VStack{
                Text(movie.title)
                    .font(.bold24)
                    .foregroundStyle(Color("black"))
                Text("영화 영어 이름")
                    .font(.semiBold14)
                    .foregroundStyle(Color("gray03"))
                Text("영화 세부 내용")
                    .font(.semiBold14)
                    .foregroundStyle(Color("gray03"))
            }
            HStack {
                Button {
                    selectedTab = 0
                } label: {
                    VStack {
                        Text("상세 정보")
                            .font(.system(size: 20, weight: selectedTab == 0 ? .bold : .regular))
                            .foregroundColor(selectedTab == 0 ? Color("black") : Color("gray02"))
                        Rectangle()
                            .fill(selectedTab == 0 ? Color("black") : Color.clear)
                            .frame(height: 2)
                    }
                }
                
                Button {
                    selectedTab = 1
                } label: {
                    VStack {
                        Text("실관람평")
                            .font(.system(size: 20, weight: selectedTab == 1 ? .bold : .regular))
                            .foregroundColor(selectedTab == 1 ? .black : Color("gray02"))
                        Rectangle()
                            .fill(selectedTab == 1 ? Color.black : Color.clear)
                            .frame(height: 2)
                    }
                }
                
            }
            .padding(.top, 35)
            Group {
                if selectedTab == 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 12) {
                            Image("f1")
                                .resizable()
                                .frame(width: 100, height: 120)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("12세 이상 관람가")
                                    .font(.semiBold13)
                                Text("2025.06.25 개봉")
                                    .font(.semiBold13)
                            }
                            Spacer()
                        }
                    }
                } else {
                    VStack {
                            Text("아직 등록된 실관람평이 없습니다.")
                                .font(.system(size: 14))
                                .foregroundColor(Color("gray03"))
                                .frame(maxWidth: .infinity, minHeight: 120)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("purple02"), lineWidth: 1)
                                )
                        }
                    }
                }
            .padding(20)
            Spacer()
        }
    }
}

#Preview {
    MovieDetailView()
}
