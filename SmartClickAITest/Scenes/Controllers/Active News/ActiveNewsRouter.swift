//
//  ActiveNewsRouter.swift
//  SmartClickAITest
//

import UIKit

@objc protocol ActiveNewsRoutingLogic {
    
}

protocol ActiveNewsDataPassing {
    var dataStore: ActiveNewsDataStore? { get }
}

class ActiveNewsRouter: NSObject, ActiveNewsRoutingLogic, ActiveNewsDataPassing
{
    weak var viewController: ActiveNewsViewController?
    var dataStore: ActiveNewsDataStore?
    
}
