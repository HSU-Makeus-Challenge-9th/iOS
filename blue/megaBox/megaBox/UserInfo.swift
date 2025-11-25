//
//  UserInfo.swift
//  megaBox
//
//  Created by 은재 on 9/26/25.
//

import SwiftUI
import UIKit

struct UserInfo: View {
    @AppStorage("login_id") private var loginId: String = ""
    @AppStorage("member_name") private var memberName: String = ""
    @AppStorage("is_logged_in") private var isLoggedIn: Bool = false
    
    @State private var profileImage: UIImage?
    @State private var isShowingImagePicker = false
    
    private let primary = Color.purple

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 20) {
                    header
                    clubMembershipButton
                    statusInfo
                    bookingRow
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            profileView
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(displayName() + "님")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.black)
                    Text("WELCOME")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("mint"))
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
                HStack(spacing: 4) {
                    Text("멤버십 포인트")
                        .font(.system(size: 14))
                        .foregroundStyle(Color("gray04"))
                    Text("500P")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            Spacer()
            NavigationLink {
                UserInfoManage()
            } label: {
                Text("회원정보")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color("gray07"))
                    )
            }
        }
    }
    
    private var profileView: some View {
        Group {
            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.black)
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(Circle())
        .onLongPressGesture(minimumDuration: 1.0) {
            isShowingImagePicker = true
        }
    }

    private var clubMembershipButton: some View {
        Button { } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 171/255, green: 139/255, blue: 255/255),
                                Color(red: 142/255, green: 174/255, blue: 243/255),
                                Color(red:  93/255, green: 204/255, blue: 236/255)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                HStack(spacing: 3) {
                    Text("클럽 멤버십")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    Image("chevron-up")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 16, height: 16)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 46)
        }
        .padding(.bottom, 12)
    }

    private var statusInfo: some View {
        HStack(spacing: 0) {
            statusCell(title: "쿠폰", value: "2")
            Divider().frame(height: 44)
            statusCell(title: "스토어 교환권", value: "0")
            Divider().frame(height: 44)
            statusCell(title: "모바일 티켓", value: "0")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color("gray02"))
        )
        .padding(.bottom, 12)
    }

    private func statusCell(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(Color("gray02"))
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
    }

    private var bookingRow: some View {
        HStack(spacing: 20) {
            bookingItem(image: "icon_movie", title: "영화별예매")
            bookingItem(image: "icon_theater", title: "극장별예매")
            bookingItem(image: "icon_special", title: "특별관예매")
            bookingItem(image: "icon_order", title: "모바일오더")
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 6)
    }

    private func bookingItem(image: String, title: String) -> some View {
        VStack(spacing: 8) {
            Image(image)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
    }

    private func displayName() -> String {
        let base = memberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? loginId : memberName
        if base.count <= 2 { return base }
        let first = String(base.prefix(1))
        let last = String(base.suffix(1))
        return first + "＊" + last
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    UserInfo()
}
