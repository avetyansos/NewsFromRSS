//
//  ArchivedNewsModels.swift
//  SmartClickAITest
//

import UIKit

enum ArchivedNews
{
    
    enum UseCase
    {
        struct Request
        {
            var news:News!
        }
        struct Response
        {
            var news = [News]()
        }
        struct ViewModel
        {
            var news = [News]()
        }
    }
}
