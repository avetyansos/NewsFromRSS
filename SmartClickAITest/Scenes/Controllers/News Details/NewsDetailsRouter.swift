//
//  NewsDetailsRouter.swift
//  SmartClickAITest
//

import UIKit

protocol NewsDetailsRoutingLogic {
    
}

protocol NewsDetailsDataPassing {
    var dataStore: NewsDetailsDataStore? { get }
}

class NewsDetailsRouter: NSObject, NewsDetailsRoutingLogic, NewsDetailsDataPassing
{
    weak var viewController: NewsDetailsViewController?
    var dataStore: NewsDetailsDataStore?
    
}
