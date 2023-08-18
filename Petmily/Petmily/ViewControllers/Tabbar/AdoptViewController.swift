//
//  AdoptViewController.swift
//  Petmily
//
//  Created by 김지은 on 2023/08/14.
//

import UIKit

class AdoptViewController: BaseViewController {
    @IBOutlet weak var cvMain: UICollectionView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cmButton: UIButton!
    
    @IBOutlet weak var heighView: NSLayoutConstraint!
    
    let imageNames = ["image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8"] // 이미지 파일 이름
    let textNames = ["분양", "강아지 MBTI", "애견동반 펜션", "고양이 츄르", "애견 미용", "동물 병원", "산책로", "캣타워" ]
    let linkURLs = [
            "http://barkbark.co.kr/category/%EA%B0%95%EC%95%84%EC%A7%80%EB%B6%84%EC%96%91/12/",
            "https://gghyui.tistory.com/entry/%EA%B0%95%EC%95%84%EC%A7%80-DBTI-%EB%82%98%EC%9D%98-%EB%B0%98%EB%A0%A4%EA%B2%AC-MBTI%EB%8A%94-%EB%AD%98%EA%B9%8C-%EA%B0%95%EC%95%84%EC%A7%80-%EC%84%B1%ED%96%A5-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0",
            "https://www.instagram.com/thehero_playground/",
            "https://brand.naver.com/doctorby/products/4928000259?n_media=27758&n_query=%EA%B3%A0%EC%96%91%EC%9D%B4%EC%B8%84%EB%A5%B4&n_rank=1&n_ad_group=grp-a001-02-000000026460752&n_ad=nad-a001-02-000000177059891&n_campaign_type=2&n_mall_id=ncp_1np4t7_01&n_mall_pid=4928000259&n_ad_group_type=2&NaPm=ct%3Dllen7xq0%7Cci%3D0yy0002pBrPyrpitYfl7%7Ctr%3Dpla%7Chk%3D6d093f29c1bc3c1a2fa1454dca7845f811f1e0a3",
            "https://map.naver.com/v5/search/%EC%95%A0%EA%B2%AC%20%EB%AF%B8%EC%9A%A9/place/1645807472?placePath=%3Fentry=pll%26from=nx%26fromNxList=true&c=15,0,0,0,dh",
            "https://map.naver.com/v5/search/%EB%8F%99%EB%AC%BC%EB%B3%91%EC%9B%90/place/36481345?placePath=%3Fentry=pll%26from=nx%26fromNxList=true&c=15,0,0,0,dh",
            "https://www.notepet.co.kr/news/article/article_view/?idx=20669",
            "https://brand.naver.com/gatoblanco/products/3354340321?NaPm=ct%3Dllewdwkw%7Cci%3D0zS0002YQrPycYuSKf2S%7Ctr%3Dpla%7Chk%3Dbcc8dfc6c2693b4d6080d3850ff56fc6b1e531bb"
            
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvMain.delegate = self
        cvMain.dataSource = self
        
        let nibName = UINib(nibName: "UrlBtnCollectionViewCell", bundle: nil)
        cvMain.register(nibName, forCellWithReuseIdentifier: "UrlBtnCollectionViewCell")
        
        cmButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
    }
    
    // viewDidLayoutSubviews에 reloadData()를 호출하여 레이아웃이 완료된 후 콜렉션 뷰를 새로 고칩니다.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cvMain.reloadData()
    }
    @objc func openLink() {
            if let url = URL(string: "https://spartacodingclub.kr/") { // 원하는 링크로 수정
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }


extension AdoptViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UrlBtnCollectionViewCell", for: indexPath) as! UrlBtnCollectionViewCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])
        cell.textLabel.text = textNames[indexPath.item]
        
        // 각 셀에 해당하는 링크를 설정
        if indexPath.item < linkURLs.count {
            cell.link = linkURLs[indexPath.item]
        }
        
        return cell
    }
    
    // 셀의 크기를 설정합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 10 // 화면 너비의 1/4에서 약간의 간격(10)을 뺀 값을 셀의 너비로 설정합니다.
        heighView.constant = (width + 40) * 2
        heighView.isActive = true
        return CGSize(width: width, height: width + 20) // 너비와 높이를 같게 해서 정사각형 모양의 셀을 만듭니다.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32 // 원하는 간격 값으로 수정하세요
    }
    
}