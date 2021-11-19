//
//  HomeView.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class HomeView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
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
}
// https://myseong.tistory.com/14
// https://stackoverflow.com/questions/39079491/rxswift-table-view-with-multiple-custom-cell-types
// TableView -> [Cell, Cell, Cell]  2개의 부분이 고정되어 있으므로
// 순서를 배열에 담아 고정시키고 row 값으로 == 0, == 1 그 외에만 마지막 Cell 업데이트 시킴
// Section 개념 사용. Datasource를 사용하여 여러개의 Cell이 바인딩 하는것처럼 구현한다.

// ScrollView -> UIView, UIView, TableView(Cell)

// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return HomeView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = HomeView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
