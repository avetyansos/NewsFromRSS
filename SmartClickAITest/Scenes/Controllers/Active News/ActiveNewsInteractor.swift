//
//  ActiveNewsInteractor.swift
//  SmartClickAITest
//

import UIKit

protocol ActiveNewsBusinessLogic {
    
}

protocol ActiveNewsDataStore {
    
}

class ActiveNewsInteractor: ActiveNewsBusinessLogic, ActiveNewsDataStore
{
    var presenter: ActiveNewsPresentationLogic?
    var worker: ActiveNewsWorker?
    //var name: String = ""
    
}
