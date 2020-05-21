//
//  NewsDetailsInteractor.swift
//  SmartClickAITest
//

import UIKit

protocol NewsDetailsBusinessLogic {
    
}

protocol NewsDetailsDataStore {
    
}

class NewsDetailsInteractor: NewsDetailsBusinessLogic, NewsDetailsDataStore
{
    var presenter: NewsDetailsPresentationLogic?
    var worker: NewsDetailsWorker?
    //var name: String = ""
    
}
