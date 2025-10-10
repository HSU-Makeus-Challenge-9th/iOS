import Foundation
import Combine

final class MovieSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var results: [Movie] = []

    private let source: [Movie]
    private var bag = Set<AnyCancellable>()

    init(allMovies: [Movie]) {
        self.source = allMovies
        setupPipeline()
    }

    private func setupPipeline() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] text -> [Movie] in
                guard let self = self else { return [] }
                let key = text.trimmingCharacters(in: .whitespacesAndNewlines)
                if key.isEmpty { return self.source }
                return self.source.filter {
                    $0.titleKo.localizedCaseInsensitiveContains(key) ||
                    $0.titleEn.localizedCaseInsensitiveContains(key)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$results)
    }
}
