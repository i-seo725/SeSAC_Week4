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
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var movieTableView: UITableView!
    var movieList: [Movie] = []
    
    //Codable
    var result: BoxOffice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        searchBar.delegate = self
        movieTableView.rowHeight = 60
        indicatorView.isHidden = true
    }
    func callRequest(date: String) {
        //네트워크 통신 전 인디케이터 보이게 하기
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        AF.request(url, method: .get).validate().responseDecodable(of:BoxOffice.self) { response in
            print(response.value)
            self.result = response.value
        }
        
        
        
        
//            .responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//
//                for i in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
//                    let movieNm = i["movieNm"].stringValue
//                    let openDt = i["openDt"].stringValue
//
//                    let data = Movie(movieTitle: movieNm, openDate: openDt)
//                    self.movieList.append(data)
//                }
//                //갱신 전 다시 숨기기
//                self.indicatorView.stopAnimating()
//                self.indicatorView.isHidden = true
//                self.movieTableView.reloadData()
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result!.boxOfficeResult.dailyBoxOfficeList.count//movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = movieList[indexPath.row].movieTitle
        cell.detailTextLabel?.text = movieList[indexPath.row].openDate
        
        return cell
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색어가 8글자인지, 올바른 날짜 형식인지, 날짜 범주가 맞는지 체크 필요
        movieList.removeAll()
        
        guard let text = searchBar.text else { return }
        callRequest(date: text)
    }
}
