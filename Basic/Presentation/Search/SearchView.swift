//
//  SearchView.swift
//  Basic
//
//  Created by pineone on 2021/09/23.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SearchView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionRelay = PublishRelay<SearchActionType>()

    // MARK: - init
    override init(naviType: BaseNavigationShowType = .centerTitle) {
        super.init(naviType: naviType)
        naviBar.title = "ZEM 앱 상세보기"
        setupLayout()
        appInfoTest()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    /// 앱 상세보기 테이블 뷰
    lazy var tableView = UITableView().then {
        $0.register(cellType: AppInfoTableViewCell.self)
        $0.register(cellType: RatingTableViewCell.self)
//        $0.register(cellType: ReviewTableViewCell.self)
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    func appInfoTest() {
        let apps = [HomeModel(appImageUrl: "https://tinyurl.com/yfmag6fm", appName: "브롤스타즈",
                              apppVersion: "버전 5.2.1", appDesc: "만7세 / 순위 1위 / 일 평균 2시간 20분")]
        let appsOb: Observable<[HomeModel]> = Observable.of(apps)
        appsOb
            .bind(to: tableView.rx.items(cellIdentifier: AppInfoTableViewCell.reuseIdentifier, cellType: AppInfoTableViewCell.self)) { [weak self] row, element, cell in
                cell.setData(element)
            }.disposed(by: rx.disposeBag)
    }
    ///FIXME: - HomeDataSource 로 구현해보기... AIS 홈부분 참고.
    /// 여러가지 방법
    /// 1. 스크롤뷰 -> 뷰,뷰, 테이블뷰
    /// 2. 테이블뷰 -> 1,2번 CellType 고정 맨마지막만 늘어남.
    /// 3. DataSource를 사용하여 섹션 구분하기
    
    @discardableResult
    func setupDI(observable: Observable<[HomeModel]>) -> Self {
        observable
            .bind(to: tableView.rx.items(cellIdentifier: AppInfoTableViewCell.reuseIdentifier, cellType: AppInfoTableViewCell.self)) { row, element, cell in
                cell.setData(element)
            }.disposed(by: rx.disposeBag)
        return self
    }
    
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<SearchActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
}


// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct Search_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return SearchView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = SearchView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
