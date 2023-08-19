//
//  UserDefaultHelper.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/11.
//

import Foundation

class UserDefaultsHelper {
    
    //모든 뷰컨트롤러에서 접근할 수 있도록 타입 프로퍼티에 인스턴스 생성, 같은 일을 하는 데 공간을 각각 만드는 건 비효율적이라서
    static let standard = UserDefaultsHelper()  //싱글턴 패턴
    private init() { }  //접근 제어자 : 외부에서 init()에 접근할 수 없게 설정 -> 인스턴스 생성 못함
    
    let userDefaults = UserDefaults.standard
    
    //모든 파일에서 열거형을 사용할 필요가 없으면 사용할 클래스/구조체 안에 생성하면 됨 -> 컴파일 최적화
    enum Key: String {
        case nickname, age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            return userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
}
