//
//  ActiveNewsPresenter.swift
//  SmartClickAITest
//

import UIKit

protocol ActiveNewsPresentationLogic {
    func presentNews(response: ActiveNews.UseCase.Response)
    
}

class ActiveNewsPresenter: ActiveNewsPresentationLogic
{
    weak var viewController: ActiveNewsDisplayLogic?
    
    func presentNews(response: ActiveNews.UseCase.Response) {
        var viewModel = ActiveNews.UseCase.ViewModel()
        viewModel.news = response.news
        viewController?.displayNews(viewModel: viewModel)
    }
    
}
