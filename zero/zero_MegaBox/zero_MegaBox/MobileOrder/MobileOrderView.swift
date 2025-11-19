//
//  MovileOrderView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/19/25.
//

    import SwiftUI

struct MobileOrderView: View {
    var body: some View {
        VStack{
            HStack{
                Image("meboxLogo")
                    .frame(width: 149, height: 30)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 17)
                Spacer()
            }
            TheaterBar(location:"홍대", backgroundColor: Color("blue03"))
            ScrollView(.vertical, showsIndicators: false) {
                HStack{
                    Button(action: {}) {
                        OrderButtonCard(buttonDescription: "이제 줄서지 말고\n모바일로 주문하고 픽업!")
                    }
                    VStack{
                        Button(action: {}){
                            OrderButtonCard(buttonText: "스토어 교환권",buttonWidth: 126,buttonHeight: 130)
                        }
                        .padding(.bottom,10)
                        Button(action: {}){
                            OrderButtonCard(buttonText: "선물하기",buttonWidth: 126,buttonHeight: 130)
                        }
                    }
                }
                .padding(.top, 37)
                Button(action: {}) {
                    HStack{
                        VStack(alignment: .leading) {
                            Text("어디서든 팝콘 만나기")
                                .font(.bold24)
                                .foregroundColor(Color("black"))
                                .padding(.leading,12)
                                .padding(.top, 15)
                            Text("팝콘 콜라 스낵 모든 메뉴 배달 가능!")
                                .font(.regular12)
                                .foregroundColor(Color("gray03"))
                                .multilineTextAlignment(.leading)
                                .padding(.leading,12)
                                .padding(.top, 5)
                        }
                        Spacer()
                        Image("motorcycle")
                            .padding(.trailing,10)
                            .padding(.bottom, 10)
                    }
                }
                .frame(width: 376, height: 104)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("gray03"), lineWidth: 1)
                )
                VStack{
                    HStack{
                        Text("추천 메뉴")
                            .font(.bold22)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                            .padding(.top, 35)
                        Spacer()
                    }
                    HStack{
                        Text("영화 볼 때 뭐먹지 고민될 땐 추천 메뉴!")
                            .font(.regular12)
                            .foregroundColor(Color("gray03"))
                            .padding(.top,10)
                            .padding(.leading, 20)
                        Spacer()
                    }
                }
                .padding(.bottom, 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(MenuItemModel.allCases.map { $0.returnMenu() }) { menu in
                                    MenuCard(menu: menu)
                        }
                    }
                    .padding(.horizontal)
                }
                VStack{
                    HStack{
                        Text("베스트 메뉴")
                            .font(.bold22)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                            .padding(.top, 35)
                        Spacer()
                    }
                    HStack{
                        Text("영화 볼때 뭐먹지 고민될 때 베스트 메뉴!")
                            .font(.regular12)
                            .foregroundColor(Color("gray03"))
                            .padding(.top,10)
                            .padding(.leading, 20)
                        Spacer()
                    }
                }
                .padding(.bottom, 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(MenuItemModel.allCases.map { $0.returnMenu() }) { menu in
                                    MenuCard(menu: menu)
                        }
                    }
                    .padding(.horizontal)
                }
                
                
            }
            
        }
    }
}

#Preview {
    MobileOrderView()
}
