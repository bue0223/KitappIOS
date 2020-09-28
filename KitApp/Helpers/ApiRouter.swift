//
//  ApiRouter.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/14/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation
import Alamofire

public let AF = Session.default

enum Result<Success,Failure: Error> {
    case success(Success)
    case failure(Failure)
}

enum SampleError: Error {
    case wrongcasting
}

enum ApiRouter: Equatable {
    case authToken
    case getProducts
    case getPromos
    case getMessages
    case rewards(type: String)
    case infographics
    case content
    case getPrograms
    
    var baseUrl: String {
        return "https://2ig88nmh2j.execute-api.ap-southeast-1.amazonaws.com/kitapp-api-stg"
    }
    
    var header: HTTPHeaders {
        return [HTTPHeader(name: "Authorization", value: SessionManager.shared.loadToken() ?? "")]
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
            case .authToken:
                return [
                    "accessKey": "2930dcc2-ad6c-43e6-90c8-f893ec73bd20",
                    "secretAccessKey": "e17a5705-8d0b-419e-b144-531ac7671daf"
            ]
            
            case .rewards(let type):
                return [
                    "type" : type
            ]
            
            default:
            return nil
        }
            
    }
    
    var path: String {
        switch self {
            case .authToken:
                return "/auth-token"
            case .getProducts:
                return "/products"
            case .getMessages:
                return "/messages"
            case .getPromos:
                return "/promos"
            case .rewards:
                return "/rewards"
            case .infographics:
                return "/infographics"
            case .content:
                return "/app-version"
            case .getPrograms:
                return "/price-program"
        }
    }
    var method: HTTPMethod {
      switch self {
      case .authToken, .rewards:
        return .post
      case .getProducts, .infographics, .content, .getPromos, .getMessages, .getPrograms:
        return .get
      }
    }

    func request<T: Decodable>(completion: @escaping (Result<T, Error>) -> ()) {
        let url = "\(baseUrl)\(path)"
           
        AF.request(url, method: method, parameters: bodyParameters, encoding: JSONEncoding.default, headers: header).validate(statusCode: 200..<299).responseData { (response) in
            let statusCode = response.response?.statusCode ?? 0
            
            if self == .authToken {
                if statusCode > 500 {
                    self.request(completion: completion)
                    return
                }
            }
            
            if statusCode == 401 {
                self.handleUnauthorizedAccess(authorizedCompletion: {
                    self.request(completion: completion)
                })
                
                return
            }
            
            if let data = response.data {
                print("Request URL: \(url)")
                print("Request Headers: \(self.header)")
                print("Request Parameters: \(String(describing: self.bodyParameters ?? [:]))")
                print("Response Status Code: \(statusCode)")
                print("Response Value: \(String(describing: (String(data: data, encoding: .utf8) ?? "") ) )")
            }
            
            switch response.result {
                case .success(let value):
                    if let decoded = try? JSONDecoder().decode(T.self, from: value) {
                        completion(.success(decoded))
                    }else {
                        print("Cannot decode \(url)")
                        completion(.failure(SampleError.wrongcasting))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    fileprivate func handleUnauthorizedAccess(authorizedCompletion: @escaping () -> ()) {
        ApiRouter.authToken.request { (result: Result<ApiResponse<[Auth]>, Error>) in
            switch result {
                case .success(let value):
                SessionManager.shared.save(accessToken: value.payload.first?.token ?? "")
                authorizedCompletion()
                case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
