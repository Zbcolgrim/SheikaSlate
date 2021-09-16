//
//  File.swift
//  slate
//
//  Created by Zachary Buffington on 9/16/21.
//

import Foundation
import UIKit
protocol ItemManagerDelegate {
    func didFetchItems(_ items: [Item])
    func didFetchImage(_ image: UIImage)
    func didFail(_ error: Error?)
}

class ItemManager {
    var delegate: ItemManagerDelegate?
    func fetchItems(for category: String) {
        guard var url = URL(string: "https://botw-compendium.herokuapp.com/api/v2/category/") else {
            delegate?.didFail(nil)
            return
        }
        url.appendPathComponent(category.lowercased())
        print(url)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
        
            if let error = error {
                self.delegate?.didFail(error)
                return
            }
        
            guard let data = data else {
                self.delegate?.didFail(nil)
                return
            }
            do {
              let decoder = JSONDecoder()
                let response = try decoder.decode(CompendiumResponse.self, from: data)
                self.delegate?.didFetchItems(response.data)
                
            } catch {
                self.delegate?.didFail(error)
                return
                
            }
            
    
        }.resume()
        
    }
    func fetchImage(for item: Item) {
        let url = item.image
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                self.delegate?.didFail(error)
                return
            }
            guard let data = data,
                  let image = UIImage(data: data) else {
                self.delegate?.didFail(nil)
                return
            }
            self.delegate?.didFetchImage(image)
        }.resume()
    }
}
