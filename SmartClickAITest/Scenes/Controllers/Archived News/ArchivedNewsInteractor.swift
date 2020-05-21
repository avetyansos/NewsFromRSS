//
//  ArchivedNewsInteractor.swift
//  SmartClickAITest
//

import UIKit

protocol ArchivedNewsBusinessLogic {
    
}

protocol ArchivedNewsDataStore {
    
}

class ArchivedNewsInteractor: ArchivedNewsBusinessLogic, ArchivedNewsDataStore
{
    var presenter: ArchivedNewsPresentationLogic?
    var worker: ArchivedNewsWorker?
    //var name: String = ""
    
}
