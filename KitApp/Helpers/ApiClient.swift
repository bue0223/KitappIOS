//
//  ApiClient.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Alamofire

class ApiClient {
    func download(url: URL, completion: @escaping (Result<Data, Error>) -> ()){
        AF.download(url).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data))
            }
        }
    }
}
