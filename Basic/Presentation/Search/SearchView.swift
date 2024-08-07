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
        naviBar.title = "검색"
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        
    }
    
//    @discardableResult
//    func setupDI(observable: Observable<[HomeModel]>) -> Self {
//        observable
//            .bind(to: tableView.rx.items(cellIdentifier: TableViewCell.reuseIdentifier, cellType: TableViewCell.self)) { row, element, cell in
//                cell.setData(element)
//            }.disposed(by: rx.disposeBag)
//        return self
//    }
    
    
//    @discardableResult
//    func setupDI(observable: Observable<[HomeModel]>) -> Self {
//        observable
//            .bind(to: tableView.rx.items(cellIdentifier: TableViewCell.reuseIdentifier, cellType: CellName.self)) { row, element, cell in
//                cell.setData(element)
//            }.disposed(by: rx.disposeBag)
//        return self
//    }
    
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
