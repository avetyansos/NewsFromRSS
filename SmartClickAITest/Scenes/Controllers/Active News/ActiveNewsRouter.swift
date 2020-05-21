//
//  ActiveNewsRouter.swift
//  SmartClickAITest
//

import UIKit

protocol ActiveNewsRoutingLogic {
    func routToNewsDetails(news:News)
}

protocol ActiveNewsDataPassing {
    var dataStore: ActiveNewsDataStore? { get }
}

class ActiveNewsRouter: NSObject, ActiveNewsRoutingLogic, ActiveNewsDataPassing
{
    weak var viewController: ActiveNewsViewController?
    var dataStore: ActiveNewsDataStore?
    
    
    func routToNewsDetails(news:News) {
        let destination = NewsDetailsViewController.instantiateFromStoryboard()
        destination.news = news
        viewController?.show(destination, sender: self)
    }
}
