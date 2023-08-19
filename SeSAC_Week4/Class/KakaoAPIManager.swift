//
//  KakaoAPIManager.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    static let shared = KakaoAPIManager()
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
    
    func callRequest(type: Endpoint, query: String, page: Int, completionHandler: @escaping (SearchVideo) -> Void ) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let page = "&page=\(page)"
        let url = type.requestURL + text + page
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseDecodable(of: SearchVideo.self) { response in
            switch response.result {
            case .success(let value): completionHandler(value)
            case .failure(let error): print(error)
            }
        }
    }
}
