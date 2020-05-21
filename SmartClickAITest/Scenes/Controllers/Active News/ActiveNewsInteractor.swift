//
//  ActiveNewsInteractor.swift
//  SmartClickAITest
//

import UIKit

protocol ActiveNewsBusinessLogic {
    func getNews()
}

protocol ActiveNewsDataStore {
    
}

class ActiveNewsInteractor: ActiveNewsBusinessLogic, ActiveNewsDataStore
{
    var presenter: ActiveNewsPresentationLogic?
    var worker: ActiveNewsWorker?
    //var name: String = ""
    
    func getNews() {
        worker = ActiveNewsWorker()
        var respose = ActiveNews.UseCase.Response()
        worker?.getNewsFormRSSFeed({ (news) in
            respose.news = news
            self.presenter?.presentNews(response: respose)
        }, { (error) in
            print(error.localizedDescription)
        })
    }
}
