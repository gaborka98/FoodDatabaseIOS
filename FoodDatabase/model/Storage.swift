import Foundation

struct Storage : Page Codable {
    let content: [StorageFood]
}

struct StorageFood: Codable {
	let totalCount: Int
	let count: Int
	let food: Food
}

protocol Page: Codable {
    let totalElements: Int
    let totalPages: Int
    let last: Bool
    let first: Bool
    let empty: Bool
    let size: Int
    let numberOfElements: Int
    let number: Int
    let pageable: Pageable
    let sort: Sort
}

struct Sort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

struct Pageable: Codable {
    let sort: Sort
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}