//
//  ArchivedNewsRouter.swift
//  SmartClickAITest
//

import UIKit

protocol ArchivedNewsRoutingLogic {
    func routToNewsDetails(_ news: News)
}

protocol ArchivedNewsDataPassing {
    var dataStore: ArchivedNewsDataStore? { get }
}

class ArchivedNewsRouter: NSObject, ArchivedNewsRoutingLogic, ArchivedNewsDataPassing
{
    weak var viewController: ArchivedNewsViewController?
    var dataStore: ArchivedNewsDataStore?
    
    func routToNewsDetails(_ news: News) {
        let destination = NewsDetailsViewController.instantiateFromStoryboard()
        destination.news = news
        destination.isArchive = true
        viewController?.navigationController?.show(destination, sender: self)
    }
}
