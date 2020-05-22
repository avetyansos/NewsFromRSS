//
//  NetworkRequestWorker.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/21/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    let baseUrl: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(method: HTTPMethod, path: String, baseUrl: String) {
        self.method = method
        self.path = path
        self.baseUrl = baseUrl
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: String, baseUrl: String, body: Body) throws {
        self.method = method
        self.path = path
        self.baseUrl = baseUrl
        self.body = try JSONEncoder().encode(body)
    }
}

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode,
                                     body: decodedJSON)
    }
}

struct FailureResponse<Body> {
    let statusCode: Int?
    let body: APIError
}

struct APIErrorResponse: Decodable {
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
    case passforFailure
    case noInternet
    case badResponse
    case withDrawError(errorString: String)
    case addBankAccountError(errorString: String)
    case deleteAccountError(errorString: String)
    case deleteBankError(errorString: String)
    case getProviderError(errorString: String)
    case depositError(errorString: String)
    case generalErrorWithString(errorString: String)
    case errorWithString(date: Data)
    case errorWithInfo(info: APIErrorResponse)
    case KYCUnverified
}

enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(FailureResponse<Body>)
}

struct APIClient {
    
    typealias APIClientCompletion = (APIResult<Data?>) -> Void
    
    let session = URLSession.shared
    
    func downloadImage(_ url: URL, _ success: @escaping (_ location: URL, _ response: URLResponse?) -> Void, _ failure: @escaping ( _ error: Error) -> Void) {
        URLSession.shared.downloadTask(with: url) { location, response, error in
            guard let location = location else {
                print("download error:", error ?? "")
                failure(error!)
                return
            }
            success(location, response)
        }.resume()

    }
    
    func perform(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {
        let baseURL = URL(string: request.baseUrl)!
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .invalidURL))); return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        urlRequest.timeoutInterval = 3000
        let startDate = Date()
        DispatchQueue.main.async {
            UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
                .filter({$0.isKeyWindow}).first?.rootViewController?.view.isUserInteractionEnabled = false
        }
        let postTask = session.dataTask(with: urlRequest.debugLog()) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                    .filter({$0.isKeyWindow}).first?.rootViewController?.view.isUserInteractionEnabled = true
            }
            self.log(data: data, response: response as? HTTPURLResponse, error: error)
            let requestExecutionTime = Date().timeIntervalSince(startDate)
            if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .noInternet)))
            } else if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorBadServerResponse {
                completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .badResponse)))
            } else {
                #if DEBUG
                    print("REQUESTTTT EXECUTION TIMMMEEEE =========\(requestExecutionTime)")
                #endif
                guard let httpResponse = response as? HTTPURLResponse else {
                    #if DEBUG
                        let executionTimeWithError = Date().timeIntervalSince(startDate)
                        print("REQUESTTTT==== ERRRRRROOOOORRRR==== EXECUTION TIMMMEEEE =========\(executionTimeWithError)")
                    #endif
                    completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .requestFailed))); return
                }
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 401 {
//                        if APPInternalWorker.shared.canLogOut() {
//                            APPInternalWorker.shared.isFromClosedApp = false
//                            DispatchQueue.main.async {
//                                SwitchManager.updateRootVC()
//                            }
//                        }
                    } else if httpResponse.statusCode == 400 {
                        if let uData = data, let errorInfo = try? JSONDecoder().decode(APIErrorResponse.self, from: uData) {
                            completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .errorWithInfo(info: errorInfo))))
                        } else {
                            completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .errorWithString(date: data!))))
                        }
                        
                    } else {
                        completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .requestFailed)))
                    }
                    return
                }
                let executionTimeWithSuccess = Date().timeIntervalSince(startDate)
                #if DEBUG
                    print("REQUESTTTT==== SUCCESSSSSSS==== EXECUTION TIMMMEEEE =========\(executionTimeWithSuccess)")
                #endif
                completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
            }
        }
        postTask.resume()
    }
    
    fileprivate func log(data: Data?, response: HTTPURLResponse?, error: Error?) {
        #if DEBUG
            let urlString = response?.url?.absoluteString
            let components = NSURLComponents(string: urlString ?? "")
            
            let path = "\(components?.path ?? "")"
            let query = "\(components?.query ?? "")"
            
            var responseLog = " \n <---------- IN ---------- \n "
            if let urlString = urlString {
                responseLog += "\(urlString)"
                responseLog += "\n\n"
            }
            
            if let statusCode =  response?.statusCode {
                responseLog += "HTTP \(statusCode) \(path)?\(query) \n "
            }
            if let host = components?.host {
                responseLog += "Host: \(host) \n "
            }
            for (key, value) in response?.allHeaderFields ?? [:] {
                responseLog += "\(key): \(value) \n "
            }
            if let body = data {
                responseLog += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")\n"
            }
            if error != nil {
                responseLog += " \n Error: \(error!.localizedDescription) \n "
            }
            
            responseLog += "<------------------------ \n "
            print(responseLog)
        #endif
    }
}

extension URLRequest {
    public func debugLog() -> URLRequest {
        #if DEBUG
            let urlString = self.url?.absoluteString ?? ""
            let components = NSURLComponents(string: urlString)
            
            let method = self.httpMethod != nil ? "\(self.httpMethod!)": ""
            let path = "\(components?.path ?? "")"
            let query = "\(components?.query ?? "")"
            let host = "\(components?.host ?? "")"
            
            var requestLog = " \n ---------- OUT ----------> \n "
            requestLog += "\(urlString)"
            requestLog += "\n\n"
            requestLog += "\(method) \(path)?\(query) HTTP/1.1 \n "
            requestLog += "Host: \(host)\n"
            for (key,value) in self.allHTTPHeaderFields ?? [:] {
                requestLog += "\(key): \(value) \n "
            }
            if let body = self.httpBody{
                requestLog += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")\n"
            }
            
            requestLog += " \n -------------------------> \n ";
            print(requestLog)
        #endif
        return self
    }
}

