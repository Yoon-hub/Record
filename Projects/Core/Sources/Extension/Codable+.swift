//
//  Codable+.swift
//  Core
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

import Alamofire
import RxSwift

public extension ObservableType where Element == (HTTPURLResponse, Data) {
    
    func map<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T?> {
        return self.map { response -> T? in
            let decoder = decoder ?? JSONDecoder()
            
            var res: T? = nil
            do {
                res = try decoder.decode(type, from: response.1)
            } catch {
                debugPrint("Parsing error: \(error)")
            }
            
            return res
        }
    }
}
