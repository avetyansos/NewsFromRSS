//
//  ArchivedNewsInteractor.swift
//  SmartClickAITest
//

import UIKit

protocol ArchivedNewsBusinessLogic {
    func fetchArchivedNews()
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
}
