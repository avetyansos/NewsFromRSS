//
//  AppInternalWorker.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/21/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import Foundation

protocol NewsCoordinator {
    func archiveNews(_ news: News)
    func fetchArchivedNews() -> [News]
}

enum DefaultsKeys: String {
    case news = "News"
}


class APPInternalWorker : NewsCoordinator {
    
    func archiveNews(_ news: News) {
        var newsArray = self.fetchArchivedNews()
        var addingNews = news
        self.saveImageToLocal(news.fullimage, { (path) in
            guard path != "" else {return}
            addingNews.localImageURL = path
            newsArray.append(addingNews)
            self.storeNews(newsArray)
        }) {
            print("error")
        }
    }
    
    func fetchArchivedNews() -> [News] {
        guard let news = self.getArchivedNews() else { return []}
        return news
    }
    
    private func getArchivedNews() -> [News]? {
        if let archivedNews = UserDefaults.standard.data(forKey: DefaultsKeys.news.rawValue),
            let news = try? JSONDecoder().decode([News].self, from: archivedNews) {
            return news
        }
        return nil
    }
    
    private func storeNews(_ newsArray : [News]) {
        if let encoded = try? JSONEncoder().encode(newsArray) {
            UserDefaults.standard.set(encoded, forKey: DefaultsKeys.news.rawValue)
        }
    }
    
    
    private func saveImageToLocal(_ imageURL: String, _ success: @escaping (_ location: String) -> Void, _ failure: @escaping () -> Void ) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var locationPath = ""
        if let url = URL(string: imageURL) {
            APIClient().downloadImage(url, { (location, response) in
                do {
                    locationPath = response?.suggestedFilename ?? url.lastPathComponent
                    try FileManager.default.moveItem(at: location, to: documents.appendingPathComponent(locationPath))
                    success(locationPath)
                } catch {
                    print(error)
                    failure()
                }
            }) {
                failure()
            }
        }
    }
}
