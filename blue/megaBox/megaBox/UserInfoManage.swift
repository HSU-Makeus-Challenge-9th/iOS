//
//  UserInfoManage.swift
//  megaBox
//
//  Created by 은재 on 9/26/25.
//

import SwiftUI

struct UserInfoManage: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("login_id") private var loginId: String = ""      // LoginView에서 저장한 아이디
    @AppStorage("member_name") private var memberName: String = ""

    @State private var tempName: String = ""

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button { dismiss() } label: {
                    Image("Leading")
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 33, height: 33)
                }
                Spacer()
                Text("회원정보 관리")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)
                Spacer()
                Color.clear.frame(width: 42.5, height: 19)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            VStack(alignment: .leading, spacing: 12) {
                Text("기본정보")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 16)

                VStack(spacing: 0) {
                    // 아이디: AppStorage 값 표시만, 수정 불가
                    HStack {
                        Text(loginId)
                            .font(.system(size: 15))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 26)

                    Divider().padding(.horizontal, 16)   // 양끝 살짝 띄운 라인

                    // 이름: 편집 가능 + 변경 버튼
                    HStack(spacing: 12) {
                        TextField("이름", text: $tempName)
                            .font(.system(size: 15))
                            .foregroundStyle(.black)

                        Button("변경") {
                            let newName = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !newName.isEmpty { memberName = newName }
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.6), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 44)

                    Divider().padding(.horizontal, 16)   // 양끝 살짝 띄운 라인
                }
                .background(.white)
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { tempName = memberName }
    }
}


#Preview {
    UserInfoManage()
}
