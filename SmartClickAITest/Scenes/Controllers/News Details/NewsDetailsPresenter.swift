//
//  NewsDetailsPresenter.swift
//  SmartClickAITest
//

import UIKit

protocol NewsDetailsPresentationLogic {
    func prsentPopUp(response:NewsDetails.UseCase.Response)
    func prsentSuccessPopUp(response:NewsDetails.UseCase.Response)
}

class NewsDetailsPresenter: NewsDetailsPresentationLogic
{
    weak var viewController: NewsDetailsDisplayLogic?
    
    func prsentPopUp(response:NewsDetails.UseCase.Response) {
        var viewModel = NewsDetails.UseCase.ViewModel()
        viewModel.popupMessage = response.popupMessage
        viewController?.displayPupUp(viewModel: viewModel)
    }
    
    func prsentSuccessPopUp(response:NewsDetails.UseCase.Response) {
        var viewModel = NewsDetails.UseCase.ViewModel()
        viewModel.popupMessage = response.popupMessage
        viewController?.displaySuccessPopUp(viewModel: viewModel)
    }
}
