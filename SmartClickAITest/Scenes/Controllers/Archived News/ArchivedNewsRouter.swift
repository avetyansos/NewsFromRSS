//
//  ArchivedNewsRouter.swift
//  SmartClickAITest
//

import UIKit

@objc protocol ArchivedNewsRoutingLogic {
    
}

protocol ArchivedNewsDataPassing {
    var dataStore: ArchivedNewsDataStore? { get }
}

class ArchivedNewsRouter: NSObject, ArchivedNewsRoutingLogic, ArchivedNewsDataPassing
{
    weak var viewController: ArchivedNewsViewController?
    var dataStore: ArchivedNewsDataStore?
    
}
