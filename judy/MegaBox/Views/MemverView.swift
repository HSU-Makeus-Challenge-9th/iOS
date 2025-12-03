import SwiftUI
import PhotosUI

// MARK: - 이름 마스킹

extension String {
    var maskedForName: String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        let chars = Array(trimmed)

        switch chars.count {
        case 0:
            return self
        case 1:
            return trimmed
        case 2:
            return String(chars[0]) + "*"
        default:
            let first = chars.first!
            let last = chars.last!
            let middle = String(repeating: "*", count: chars.count - 2)
            return "\(first)\(middle)\(last)"
        }
    }
}

// MARK: - UIKit 앨범(PHPicker) 래핑

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController,
                                context: Context) { }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController,
                    didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                guard let uiImage = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.parent.image = uiImage
                }
            }
        }
    }
}

// MARK: - 메인 마이페이지

struct MemberView: View {
    @EnvironmentObject var vm: LoginViewModel

    @State private var profileImage: UIImage?
    @State private var isShowingPhotoPicker = false
    @State private var isShowingMemberInfo = false

    @AppStorage("member.point") private var membershipPoint: Int = 500
    @AppStorage("member.coupon") private var couponCount: Int = 2
    @AppStorage("member.storeCoupon") private var storeCouponCount: Int = 0
    @AppStorage("member.mobileTicket") private var mobileTicketCount: Int = 0

    // Keychain에서 아이디 / 이름 읽기
    private var storedId: String {
        KeyChainService.read(KCKey.username)
            .flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
    private var storedName: String {
        KeyChainService.read(KCKey.displayName)
            .flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }

    // 이름 원본
    private var rawName: String {
        if !vm.displayName.isEmpty {
            return vm.displayName
        } else if !storedName.isEmpty {
            return storedName
        } else if !storedId.isEmpty {
            return storedId
        } else {
            return "회원"
        }
    }

    // 가운데 * 처리된 이름
    private var maskedDisplayName: String {
        rawName.maskedForName
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    MemberProfileHeaderView(
                        displayName: maskedDisplayName,
                        profileImage: $profileImage,
                        membershipPoint: membershipPoint,
                        onTapMemberInfo: { isShowingMemberInfo = true },
                        onLongPressProfile: { isShowingPhotoPicker = true }
                    )

                    ClubMembershipButton()

                    MemberStatusCardView(
                        couponCount: couponCount,
                        storeCouponCount: storeCouponCount,
                        mobileTicketCount: mobileTicketCount
                    )

                    ReservationMenuView()

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isShowingMemberInfo) {
                MemberInfoManageView()
                    .environmentObject(vm)
            }
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(image: $profileImage)
            }
        }
    }
}

// MARK: - 프로필 헤더

struct MemberProfileHeaderView: View {
    let displayName: String
    @Binding var profileImage: UIImage?
    let membershipPoint: Int
    let onTapMemberInfo: () -> Void
    let onLongPressProfile: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Group {
                if let uiImage = profileImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            .onLongPressGesture(minimumDuration: 1.0) {
                onLongPressProfile()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("\(displayName)님")
                        .font(.system(size: 20, weight: .semibold))

                    Text("WELCOME")
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 999)
                                .fill(Color("mint01"))
                        )
                        .foregroundColor(.white)
                }

                HStack(spacing: 4) {
                    Text("멤버십 포인트")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    Text("\(membershipPoint)P")
                        .font(.system(size: 13, weight: .semibold))
                }
            }

            Spacer()

            Button(action: onTapMemberInfo) {
                Text("회원정보")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 999)
                            .fill(Color("grey07"))
                    )
            }
            .tint(.primary)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: - 쿠폰 / 교환권 / 모바일 티켓 카드

struct MemberStatusCardView: View {
    let couponCount: Int
    let storeCouponCount: Int
    let mobileTicketCount: Int

    var body: some View {
        HStack(spacing: 0) {
            MemberStatusItemView(titleText: "쿠폰",
                                 valueText: "\(couponCount)")
            MemberStatusDividerView()
            MemberStatusItemView(titleText: "스토어 교환권",
                                 valueText: "\(storeCouponCount)")
            MemberStatusDividerView()
            MemberStatusItemView(titleText: "모바일 티켓",
                                 valueText: "\(mobileTicketCount)")
        }
        .padding(.vertical, 18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(Color("grey02"), lineWidth: 1)
        )
    }
}


struct MemberStatusItemView: View {
    let titleText: String
    let valueText: String

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(titleText)
                .font(.system(size: 13))
                .foregroundColor(Color("grey02"))
            Text(valueText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

struct MemberStatusDividerView: View {
    var body: some View {
        Rectangle()
            .fill(Color("grey02"))
            .frame(width: 1, height: 40)
    }
}
