//
//  AppInternalWorker.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/21/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import Foundation

protocol NewsCoordinator {
    func archiveNews(_ news: News,_ success: @escaping () -> Void, _ failure: @escaping (_ error: String) -> Void )
    func fetchArchivedNews() -> [News]
    func removeNewsFromList(_ news: News) -> [News]
}

enum DefaultsKeys: String {
    case news = "News"
}


class APPInternalWorker : NewsCoordinator {
    
    func archiveNews(_ news: News,_ success: @escaping () -> Void, _ failure: @escaping (_ error: String) -> Void ) {
        var newsArray = self.fetchArchivedNews()
        var addingNews = news
        self.saveImageToLocal(addingNews.fullimage, { (path) in
            guard path != "" else {return}
            addingNews.localImageURL = path
            newsArray.append(addingNews)
            if self.storeNews(newsArray) {
                success()
            } else {
                failure("Cannot Archive this news")
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func removeNewsFromList(_ news: News) -> [News] {
        let newsList = self.fetchArchivedNews()
        let filteredNews = newsList.filter({$0.description != news.description})
        if filteredNews.count > 0 {
            self.removeNewsList()
            do {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let url = documents.appendingPathComponent(news.localImageURL!)
                try FileManager.default.removeItem(at: url)
                if self.storeNews(filteredNews) {
                    return filteredNews
                }
            } catch {
                return newsList
            }
        } else if filteredNews.count == 0 {
            
            self.removeNewsList()
            do {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let url = documents.appendingPathComponent(news.localImageURL!)
                try FileManager.default.removeItem(at: url)
                if self.storeNews(filteredNews) {
                    return filteredNews
                }
            } catch {
                return []
            }
            return []
        }else {
            return newsList
        }
        return []
    }
    
    private func removeNewsList() {
        UserDefaults.standard.removeObject(forKey: DefaultsKeys.news.rawValue)
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
    
    private func storeNews(_ newsArray : [News]) -> Bool {
        do {
            let encoded = try JSONEncoder().encode(newsArray)
            UserDefaults.standard.set(encoded, forKey: DefaultsKeys.news.rawValue)
            return true
        }
        catch {
            return false
        }
    }
    
    
    private func saveImageToLocal(_ imageURL: String, _ success: @escaping (_ location: String) -> Void, _ failure: @escaping (_ error : Error) -> Void ) {
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
                    failure(error)
                }
            }) { (error) in
                failure(error)
            }
        }
    }
}
