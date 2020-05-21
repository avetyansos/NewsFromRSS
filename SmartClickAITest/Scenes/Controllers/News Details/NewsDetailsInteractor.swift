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
        var response = NewsDetails.UseCase.Response()
        APPInternalWorker().archiveNews(news, {
            response.popupMessage = "Your News Suucessfuly Archived"
            DispatchQueue.main.async {
                self.presenter?.prsentSuccessPopUp(response: response)
            }
        }) { (error) in
            response.popupMessage = error
            DispatchQueue.main.async {
                self.presenter?.prsentPopUp(response: response)
            }
        }
    }
}
