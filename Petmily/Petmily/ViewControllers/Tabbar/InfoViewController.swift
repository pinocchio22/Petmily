import UIKit

class InfoViewController: BaseViewController, UISearchBarDelegate {
    
    
    
    // 현재 페이지
    var currentPage = 1
    // 스크롤 한 번에 로드할 데이터 개수
    let itemsPerPage = 5
    // 추가 데이터 여부
    var isMoreDataAvailable = true
    // 데이터 로딩 여부
    var isLoadingData = false
    // 검색중 여부
    var isSearching = false
    // 검색 결과를 저장할 배열
    var filteredInfoList = [Info]()
    
    @IBOutlet weak var tbvInfo: UITableView!
    
    @IBOutlet weak var infoSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvInfo.reloadData()
        setUI()
    }
    
    func setUI() {
        // 테이블 뷰 설정
        tbvInfo.delegate = self
        tbvInfo.dataSource = self
        tbvInfo.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        let nib = UINib(nibName: "InfoTableViewCell", bundle: nil)
        tbvInfo.register(nib, forCellReuseIdentifier: "InfoTableViewCell")
        
        // 서치바 설정
        infoSearchBar.delegate = self
        infoSearchBar.backgroundImage = UIImage()
        infoSearchBar.placeholder = "원하시는 동물 종을 검색해보세요"
        filteredInfoList = InfoList.list
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty{
            // 검색어가 비어있으면 전체 리스트를 보여줌
            isSearching = false
            filteredInfoList = InfoList.list
        } else
        if searchText.count == 1 {
            isSearching = true
            // 검색어가 1개인 경우 아무 동작도 하지 않음
            filteredInfoList = []
        } else {
            isSearching = true
            filteredInfoList = InfoList.list.filter { info in
                let lowercasedSearchText = searchText.lowercased()
                
                // 제목, 본문, 해시태그 중 하나라도 일치하는지 확인
                let titleMatches = info.title.lowercased().contains(lowercasedSearchText)
                let contentMatches = info.description.lowercased().contains(lowercasedSearchText)
                let hashtagMatches = info.tag.lowercased().contains(lowercasedSearchText)
                
                return titleMatches || contentMatches || hashtagMatches
            }
        }
        tbvInfo.reloadData()
    }
    
    
}




extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    // 출력할 셀의 개수
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredInfoList.count
    }
    
    // 셀 설정
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
        cell.setInfo(filteredInfoList[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택 해제
        tbvInfo.deselectRow(at: indexPath, animated: true)
        
        // 선택한 정보 가져오기
        let selectedInfo = filteredInfoList[indexPath.row]
        let selectedUser = UserList.list[indexPath.row]
        
        // 목표 뷰 컨트롤러 초기화
        let vc = InfoDetailViewController.init(nibName: "InfoDetailViewController", bundle: nil)
        vc.selectedInfo = selectedInfo // 정보 전달
        vc.selectedUser = selectedUser // 유저 정보
        navigationPushController(viewController: vc, animated: true)
    }


    
    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 스크롤 뷰의 현재 Y 오프셋
        let offsetY = scrollView.contentOffset.y
        
        // 사용자가 화면을 위로 스크롤할 때만 데이터 로딩
        if offsetY < -20 {
            // 데이터 로딩 함수 호출
            loadData()
        }
    }
    
    // 사용자가 화면을 위로 스크롤할 때 데이터를 더 로드하는 함수
    func loadData() {
        // 데이터 로딩 중이거나 추가로 불러올 데이터가 없으면 종료
        guard !isLoadingData && isMoreDataAvailable else {
            return
        }
        
        // 검색중이라면 종료
        guard !isSearching else {
            return
        }
        
        // 데이터 로딩 중임을 표시
        isLoadingData = true
        
        // 실제 데이터 로딩 로직
        DispatchQueue.global().async { [weak self] in
            // 새 데이터를 로드
            let newData = InfoList.loadMoreData(page: self?.currentPage ?? 1, itemsPerPage: self?.itemsPerPage ?? 10)
            let newUserData = UserList.loadMoreUserData(page: self?.currentPage ?? 1, itemsPerPage: self?.itemsPerPage ?? 10)
            
            DispatchQueue.main.async {
                // 로드된 데이터가 없으면 추가 데이터 없음으로 표시
                if newData.isEmpty || newUserData.isEmpty {
                    self?.isMoreDataAvailable = false
                } else {
                    // 로드된 데이터를 배열의 맨 앞에 추가
                    InfoList.list.insert(contentsOf: newData, at: 0)
                    UserList.list.insert(contentsOf: newUserData, at: 0)
                    // 현재 페이지를 증가시킴
                    self?.currentPage += 1
                    // 필터된 데이터도 업데이트
                    self?.filteredInfoList.insert(contentsOf: newData, at: 0)
                }
                
                // 데이터 로딩이 완료되었으므로 상태를 업데이트
                self?.isLoadingData = false
                // 테이블 뷰를 다시 로드하여 변경사항을 반영
                self?.tbvInfo.reloadData()
            }
        }
    }
}