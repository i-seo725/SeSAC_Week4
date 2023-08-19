//
//  TranslateViewController.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Languages: String, CaseIterable {
    case 한국어 = "ko", 영어 = "en", 일본어 = "ja", 중국어_간체 = "zh-CN", 중국어_번체 = "zh-TW", 베트남어 = "vi", 인도네시아어 = "id", 태국어 = "th", 독일어 = "de", 러시아어 = "ru", 스페인어 = "es", 이탈리아어 = "it", 프랑스어 = "fr"
}

class TranslateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var sourceText: UITextView!
    @IBOutlet var targetText: UITextView!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var pickTextField: UITextField!
    let pickerView = UIPickerView()
    let languages = Languages.allCases
    
    
    var targetLang = ""
    var langCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sourceText.text = UserDefaultsHelper.standard.nickname
        UserDefaults.standard.set("고래밥", forKey: "nickname")
        UserDefaults.standard.set(33, forKey: "age")
        
        UserDefaultsHelper.standard.nickname = "은서"
        UserDefaults.standard.string(forKey: "nickname")
        UserDefaults.standard.integer(forKey: "age")
        
        designView()
        sourceText.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
    }

    func designView() {
        sourceText.text = ""
        sourceText.layer.borderWidth = 1
        sourceText.layer.borderColor = UIColor.gray.cgColor
        sourceText.layer.cornerRadius = 5
        
        targetText.text = ""
        targetText.isEditable = false
        targetText.layer.borderWidth = 1
        targetText.layer.borderColor = UIColor.gray.cgColor
        targetText.layer.cornerRadius = 5
        
        pickTextField.placeholder = "어떤 언어로 번역하시겠나요?"
        pickTextField.textAlignment = .center
        pickTextField.font = .boldSystemFont(ofSize: 14)
        pickTextField.inputView = pickerView
        
        requestButton.setTitle("번역하기", for: .normal)
        requestButton.tintColor = .white
        requestButton.backgroundColor = .darkGray
        requestButton.layer.cornerRadius = 5
    }
    func textViewDidChange(_ textView: UITextView) {
        print(#function)
        detectLang()
    }
    
    func detectLang() {
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let header: HTTPHeaders = ["X-Naver-Client-Id": "\(APIKey.naverID)",
                                   "X-Naver-Client-Secret": "\(APIKey.naverKey)"]
        let parameter: Parameters = ["query": sourceText.text ?? "테스트 중"]
        AF.request(url, method: .post, parameters: parameter, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.langCode = json["langCode"].stringValue
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        TranslateAPIManager.share.callRequest(code: langCode, language: targetLang, text: sourceText.text ?? "") { result in
            self.targetText.text = result
        }
        view.endEditing(true)
    }
    
}

extension TranslateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(#function, languages.count)
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(languages[row])
        return "\(languages[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        targetLang = languages[row].rawValue
        pickTextField.text = "\(languages[row])로 번역"
    }
    
}
