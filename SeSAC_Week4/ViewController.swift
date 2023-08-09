//
//  ViewController.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var movieTitle: String
    var openDate: String
}

class ViewController: UIViewController {
    
    @IBOutlet var movieTableView: UITableView!
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.rowHeight = 60
        callRequest()
    }
    
    func callRequest() {
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=20120101"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
//
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//
//                print(name1, name2, name3, separator: " / ")
//                self.movieList.append(contentsOf: [name1, name2, name3])
//
                for i in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = i["movieNm"].stringValue
                    let openDt = i["openDt"].stringValue
                    
                    let data = Movie(movieTitle: movieNm, openDate: openDt)
                    self.movieList.append(data)
                }
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = movieList[indexPath.row].movieTitle
        cell.detailTextLabel?.text = movieList[indexPath.row].openDate
        
        return cell
    }
    
}
