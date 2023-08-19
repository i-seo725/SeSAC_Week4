//
//  AsyncViewController.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {

    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstImageView.backgroundColor = .blue
        print("1")
        
        //이 함수에 넣은 코드는 큐에 넣었다가 메인에 줄 서있는 다른 코드 먼저 실행 다 하고 큐에서 꺼내서 나중에 실행
        //시리얼로 동작하지만 비동기, main 쓰레드는 시리얼(직렬)
        DispatchQueue.main.async {
            print("2")
            self.firstImageView.layer.cornerRadius = self.firstImageView.frame.width / 2
        }
        print("3")
    }
    
    //sync async serial concurrent
    //UI Freezing
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!
        
        DispatchQueue.global().async {
            //오래 걸리는 작업
            let data = try! Data(contentsOf: url)
        
            //UI 관련 작업은 메인 쓰레드에서 해야 함
            DispatchQueue.main.async {
                self.firstImageView.image = UIImage(data: data)
            }
        }
        
    }
    
}
