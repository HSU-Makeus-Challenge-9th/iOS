import Foundation
import SwiftUI

struct MovieSearchSheetView: View {
    
    @Bindable var vm: MovieReserveViewModel
    var onMovieSelected: (MovieModel) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var filteredMovies: [MovieModel] {
        if vm.debouncedText.isEmpty {
            return vm.movies // 'allMovies'가 아닌 vm.movies
        } else {
            return vm.movies.filter { $0.title.localizedCaseInsensitiveContains(vm.debouncedText) }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 36) {
                    LazyVGrid(columns: columns, spacing: 36) {
                        ForEach(filteredMovies) { movie in
                            MoviePosterCell(movie: movie) { selected in
                                onMovieSelected(selected)
                                dismiss()
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("영화 선택") // 5. ⭐️ 상단 제목
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // 닫기 버튼
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) { // 6. ⭐️ 하단 검색창
                searchBar
            }
        }
    }
    
    // MARK: - 하단 검색 바 컴포넌트
    private var searchBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
            
            HStack(spacing: 15) {
                
                // 검색 아이콘
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                // 7. ⭐️ VM의 searchText와 정상적으로 바인딩
                TextField("Search", text: $vm.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(maxWidth: .infinity)
                
                // 마이크 아이콘 (동작 X)
                Image(systemName: "mic.fill")
                    .foregroundStyle(.gray)
                
                // 텍스트 클리어 버튼
                Button {
                    vm.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.bar) // 시스템 기본 배경색
        }
    }
}

// MARK: - 영화 포스터 셀 컴포넌트 (개별 셀)
private struct MoviePosterCell: View {
    let movie: MovieModel
    var action: (MovieModel) -> Void
    
    var body: some View {
        Button {
            action(movie)
        } label: {
            VStack(spacing: 8) {
                // 포스터 이미지
                movie.posterImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 95, height: 135)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
                
                // 영화 제목
                Text(movie.title)
                    .font(.pretend(type: .semiBold, size: 14)) // 폰트가 있다면
                    // .font(.system(size: 14, weight: .semibold)) // 폰트가 없다면
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .lineLimit(2) // 제목이 길 경우 두 줄로 제한
                    .frame(height: 35, alignment: .top) // 제목 높이 고정
            }
        }
    }
}


#Preview {
}

