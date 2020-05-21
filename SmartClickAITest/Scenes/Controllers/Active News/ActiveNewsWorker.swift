//
//  ActiveNewsWorker.swift
//  SmartClickAITest
//

import UIKit

typealias SuccessGetNews = (_ news: [News]) -> Void
typealias FailureHandler = (_ error: APIError) -> Void

class ActiveNewsWorker : NSObject
{
    

    let recordKey = "item"
    let dictionaryKeys = Set<String>(["title", "link", "updatedAt", "pubDate", "StoryImage", "category", "description", "fullimage", "source"])


    var results: [[String: String]]?
    var currentDictionary: [String: String]?
    var currentValue: String?
    
    
    func getNewsFormRSSFeed(_ success: @escaping SuccessGetNews, _ failure: @escaping FailureHandler) {
        let request = APIRequest(method: .get, path: AppConstants.Urls.getNewsTail , baseUrl: AppConstants.Urls.basURL)
        
        APIClient().perform(request) { (response) in
            print(response)
            switch response {
            case .success(let response):
                guard let data = response.body else {failure(APIError.requestFailed); return}
                let parser = XMLParser(data: data)
                parser.delegate = self
                if parser.parse() {
                    if let res = self.results {
                        do {
                            let json = try JSONSerialization.data(withJSONObject: res)
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let decodedews = try decoder.decode([News].self, from: json)
                            decodedews.forEach{print($0)}
                            success(decodedews)
                        } catch {
                            print(error)
                        }
                        
                    } else {
                        failure(APIError.requestFailed)
                    }
                }
            case .failure(let error):
                print("Error perform network request")
                failure(error.body)
            }
        }
    }
}

extension ActiveNewsWorker: XMLParserDelegate {
    

    // initialize results structure

    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }


    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            results!.append(currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            if currentDictionary != nil {
                currentDictionary![elementName] = currentValue
                currentValue = nil
            }
        }
    }


    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)

        currentValue = nil
        currentDictionary = nil
        results = nil
    }

}
