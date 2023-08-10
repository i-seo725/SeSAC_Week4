//
//  TranslateViewController.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslateViewController: UIViewController {

    
    @IBOutlet var sourceText: UITextView!
    @IBOutlet var targetText: UITextView!
    @IBOutlet var requestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceText.text = "안녕하세요"
        targetText.text = ""
        targetText.isEditable = false
    }

    @IBAction func requestButtonClicked(_ sender: UIButton) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = ["X-Naver-Client-Id": "\(APIKey.naverID)",
                                   "X-Naver-Client-Secret": "\(APIKey.naverKey)"]
        let parameter: Parameters = ["source": "ko", "target": "en", "text": sourceText.text ?? ""]
        
        
        AF.request(url, method: .post, parameters: parameter , headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                self.targetText.text = data
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
}
