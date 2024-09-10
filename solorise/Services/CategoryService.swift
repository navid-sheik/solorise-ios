//
//  CategoryService.swift
//  solorise
//
//  Created by Navid Sheikh on 08/09/2024.
//

import Foundation
import UIKit

class CategoryService {
    static let shared = CategoryService()
    
    private var networkManager: NetworkManager
    private(set) var categories: [Category] = []
    
    var onCategoriesFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchCategories() {
        networkManager.getAllCategory(expecting: ApiResponse<[Category]>.self) { [weak self] result in
            switch result {
            case .success(let response):
                guard let categories = response.data else { return }
                self?.categories = categories
                self?.onCategoriesFetched?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    // Helper method to access a category by index
    func getCategory(at index: Int) -> Category {
        return categories[index]
    }
    
    // Helper method to get the number of categories
    func getCategoryCount() -> Int {
        return categories.count
    }
}

