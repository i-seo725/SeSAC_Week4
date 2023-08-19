//
//  TranslateAPIManager.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class TranslateAPIManager {
    static let share = TranslateAPIManager()
    private init() { }
    
    func callRequest(code: String, language: String, text: String, resultString: @escaping (String) -> Void ) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = ["X-Naver-Client-Id": "\(APIKey.naverID)",
                                   "X-Naver-Client-Secret": "\(APIKey.naverKey)"]
        
        let parameter: Parameters = ["source": code, "target": language, "text": text]


        AF.request(url, method: .post, parameters: parameter , headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                let data = json["message"]["result"]["translatedText"].stringValue
                resultString(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
