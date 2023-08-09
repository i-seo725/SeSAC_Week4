//
//  VideoViewController.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Video {
    let author: String
    let date: String
    let time: Int
    let thumnail: String
    let title: String
    let link: String
    
    var contentsDetail: String {
        get {
            return "\(author) | \(time)초\n\(date)"
        }
    }
    
}
class VideoViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoTableView: UITableView!
    
    var videoList: [Video] = []
    var page = 1
    var isEnd = false   //현재 페이지가 마지막인지 점검하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTableView.dataSource = self
        videoTableView.delegate = self
        videoTableView.prefetchDataSource = self
        videoTableView.rowHeight = 140
        
        searchBar.delegate = self
    }
    func callRequest(query: String, page: Int) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)"
        let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
        print(url)
        //validate에서 상태코드 지정해서 성공으로 보게 할 수 있음 (200...500) -> json으로 실패 이유를 넘겨주는 api가 있어서 확인 가능
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                print(response.response?.statusCode)
                
                let statusCode = response.response?.statusCode ?? 500
                if statusCode == 200 {
                    self.isEnd = json["meta"]["is_end"].boolValue
                    
                    for item in json["documents"].arrayValue {
                        let author = item["author"].stringValue
                        let date = item["datetime"].stringValue
                        let time = item["play_time"].intValue
                        let thumbnail = item["thumbnail"].stringValue
                        let title = item["title"].stringValue
                        let link = item["url"].stringValue
                        
                        let data = Video(author: author, date: date, time: time, thumnail: thumbnail, title: title, link: link)
                        self.videoList.append(data)
//                        print(self.videoList)
                    }
                    self.videoTableView.reloadData()
                } else {
                    print("문제가 발생하였습니다. 잠시 후 다시 시도해주세요.")
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}


//UITableViewDataSourcePrefetching : iOS10 이상 사용 가능한 프로토콜, cellForRowAt 메서드가 호출되기 전에 미리 호출됨
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    //셀이 화면에 보이기 직전에 필요한 리소스 미리 다운로드 받는 기능
    //videoList 개수와 indexPath.row 위치를 비교해 마지막 스크롤 시점 확인 -> 네트워크 요청 시도
    //페이지 카운트 추가 / 새로운 키워드 검색 시 page = 1로 교체 필요
    //isEnd : 더 이상 플러스할 페이지가 없을 경우 더하지 말아야함
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && page < 15 && !isEnd {
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    //취소 기능 : 직접 취소하는 기능을 구현해줘야 함 - 데이터를 다운로드 받다가 사용자가 지나치면 다운로드 취소해라
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("======취소: \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.detailLabel.text = videoList[indexPath.row].contentsDetail
        if let url = URL(string: videoList[indexPath.row].thumnail) {
            cell.thumbnailImageView.kf.setImage(with: url)
        }
        return cell
    }
}
extension VideoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //배열을 초기화해서 검색 시마다 내용 새로 채우기
        videoList.removeAll()
        page = 1
        
        guard let query = searchBar.text else { return }
        callRequest(query: query, page: page)
    }
}
