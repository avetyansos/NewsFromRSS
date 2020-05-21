//
//  ArchivedNewsPresenter.swift
//  SmartClickAITest
//

import UIKit

protocol ArchivedNewsPresentationLogic {
    func presentNews(response: ArchivedNews.UseCase.Response)
}

class ArchivedNewsPresenter: ArchivedNewsPresentationLogic
{
    weak var viewController: ArchivedNewsDisplayLogic?
    
    func presentNews(response: ArchivedNews.UseCase.Response) {
        var viewModel = ArchivedNews.UseCase.ViewModel()
        viewModel.news = response.news
        viewController?.displayNews(viewModel: viewModel)
    }
}
