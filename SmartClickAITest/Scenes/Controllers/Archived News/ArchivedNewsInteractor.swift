//
//  ArchivedNewsInteractor.swift
//  SmartClickAITest
//

import UIKit

protocol ArchivedNewsBusinessLogic {
    func fetchArchivedNews()
    func removeNews(request: ArchivedNews.UseCase.Request)
}

protocol ArchivedNewsDataStore {
    
}

class ArchivedNewsInteractor: ArchivedNewsBusinessLogic, ArchivedNewsDataStore
{
    var presenter: ArchivedNewsPresentationLogic?
    var worker: ArchivedNewsWorker?
    //var name: String = ""
    
    func fetchArchivedNews() {
        var response = ArchivedNews.UseCase.Response()
        response.news = APPInternalWorker().fetchArchivedNews()
        presenter?.presentNews(response: response)
    }
    
    func removeNews(request: ArchivedNews.UseCase.Request) {
        var response = ArchivedNews.UseCase.Response()
        response.news = APPInternalWorker().removeNewsFromList(request.news)
        presenter?.presentNews(response: response)
        
    }
}
