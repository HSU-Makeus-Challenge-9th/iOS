//
//  MovieSearchSheetView.swift
//  MegaBox
//
//  Created by 전효빈 on 10/9/25.
//

import Foundation
import SwiftUI
import Combine

struct MovieSearchSheetView: View {
    
    @Binding var allMovies: [MovieModel]
    var onMovieSelected: (MovieModel) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm: MovieReserveViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var filteredMovies: [MovieModel] {
        if vm.debouncedText.isEmpty {
            return allMovies
        } else {
            return allMovies.filter { $0.title.localizedCaseInsensitiveContains(vm.debouncedText) }
        }
    }
    
    
    var body: some View {
        VStack(spacing: 36) {
            // 상단 제목
            Text("영화 선택")
                .font(.title2.weight(.bold))
                .padding(.vertical, 15)
            
            
            
                LazyVGrid(columns: columns, spacing: 36) {
                    ForEach(filteredMovies) { movie in
                        MoviePosterCell(movie: movie) { selected in
                            onMovieSelected(selected)
                            dismiss()
                        }
                    }
                }
            Spacer()
            
        }
        .safeAreaInset(edge: .bottom) {
            searchBar
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
                
                // 검색 입력 필드
                TextField("Search", text: $vm.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(maxWidth: .infinity)
                
                // 마이크 아이콘
                Image(systemName: "mic.fill")
                    .foregroundStyle(.gray)
                
                // 닫기/취소 버튼
                Button {
                    vm.searchText = ""
                    // dismiss() 로직은 필요에 따라 추가
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }
}

// MARK: - 영화 포스터 셀 컴포넌트 (개별 셀)
struct MoviePosterCell: View {
    let movie: MovieModel
    var action: (MovieModel) -> Void
    
    var body: some View {
        Button {
            action(movie)
        } label: {
            VStack(spacing: 8) {
                // 포스터 이미지
                Rectangle()
                    .overlay {
                        movie.posterImage
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    }
                    .frame(width: 95, height: 135)
                    

                // 영화 제목
                Text(movie.title)
                    .font(.pretend(type: .semiBold, size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
            }
        }
    }
}



