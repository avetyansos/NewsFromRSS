//
//  ActiveNewsModels.swift
//  SmartClickAITest
//

import UIKit

enum ActiveNews
{
    
    enum UseCase
    {
        struct Request
        {
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
