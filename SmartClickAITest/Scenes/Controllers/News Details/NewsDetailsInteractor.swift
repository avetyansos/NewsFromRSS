//
//  NewsDetailsInteractor.swift
//  SmartClickAITest
//

import UIKit

protocol NewsDetailsBusinessLogic {
    func archiveNews(_ news: News)
}

protocol NewsDetailsDataStore {
    
}

class NewsDetailsInteractor: NewsDetailsBusinessLogic, NewsDetailsDataStore
{
    var presenter: NewsDetailsPresentationLogic?
    var worker: NewsDetailsWorker?
    //var name: String = ""
    
    func archiveNews(_ news: News) {
        APPInternalWorker().archiveNews(news)
    }
}
