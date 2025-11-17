import SwiftUI
import Combine

struct MovieSearchView: View {
    @ObservedObject var vm: BookingViewModel

    @State private var searchText: String = ""
    @State private var filteredMovies: [AppMovie] = []
    private let searchTextSubject = PassthroughSubject<String, Never>()

    private let columnsCount: Int = 3
    private let gridHSpacing: CGFloat = 18
    private let gridVSpacing: CGFloat = 24
    private let contentHPadding: CGFloat = 20

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let itemWidth = (geo.size.width
                                 - contentHPadding * 2
                                 - gridHSpacing * CGFloat(columnsCount - 1)) / CGFloat(columnsCount)

                ScrollView {
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.fixed(itemWidth), spacing: gridHSpacing, alignment: .top),
                            count: columnsCount
                        ),
                        alignment: .center,
                        spacing: gridVSpacing
                    ) {
                        ForEach(filteredMovies, id: \.id) { movie in
                            VStack(spacing: 8) {
                                Image(movie.posterHome)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: itemWidth, height: itemWidth * 1.35)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                Text(movie.titleKo)
                                    .font(.pretendCaption)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                    .frame(maxWidth: itemWidth)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                vm.selectedMovie = movie
                                vm.showSearchSheet = false
                            }
                        }
                    }
                    .padding(.horizontal, contentHPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 120)
                    .background(Color(uiColor: .systemBackground))
                }
                .background(Color(uiColor: .systemBackground))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("영화 선택")
                        .font(.pretendSemiBold(17, relativeTo: .headline))
                        .foregroundStyle(.primary)
                }
            }
            .toolbarBackground(Color(uiColor: .systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .background(Color(uiColor: .systemBackground).ignoresSafeArea())

            .onChange(of: searchText, initial: false) { _, newValue in
                searchTextSubject.send(newValue)
            }
            .onReceive(
                searchTextSubject
                    .removeDuplicates()
                    .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            ) { query in
                filteredMovies = vm.movies.filter {
                    query.isEmpty ? true :
                    $0.titleKo.localizedCaseInsensitiveContains(query) ||
                    $0.titleEn.localizedCaseInsensitiveContains(query)
                }
            }
            .onAppear { filteredMovies = vm.movies }

            // 하단 검색 툴바
            .safeAreaInset(edge: .bottom) {
                SearchToolbar(text: $searchText, placeholder: "영화명을 입력해주세요")
                    .background(Color(uiColor: .systemBackground))
            }
        }
    }
}

private struct SearchToolbar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.gray)

                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.pretendBody)
                    .foregroundStyle(.primary)

                Button { /* voice */ } label: {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
            )

            Button { text = "" } label: {
                ZStack {
                    Circle()
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.gray)
                }
                .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 36)
        .frame(maxWidth: .infinity, minHeight: 66, alignment: .topLeading)
    }
}
