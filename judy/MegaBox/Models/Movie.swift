import Foundation

struct Movie: Identifiable, Equatable, Hashable {
    let id: UUID
    let titleKo: String
    let titleEn: String
    let posterHome: String
    let posterDetail: String
    let audience: String
    
    init(
        id: UUID = .init(),
        titleKo: String,
        titleEn: String,
        posterHome: String,
        posterDetail: String,
        audience: String
    ) {
        self.id = id
        self.titleKo = titleKo
        self.titleEn = titleEn
        self.posterHome = posterHome
        self.posterDetail = posterDetail
        self.audience = audience
    }
}
