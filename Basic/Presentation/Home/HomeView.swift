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

class HomeView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    // MARK: - init
    override init(naviType: BaseNavigationShowType = .none) {
        super.init(naviType: naviType)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    lazy var label = UILabel().then {
        $0.text = "Home Views"
        $0.textColor = .red
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func setupDI(observable: Observable<[Model]>) {
        // model Dependency Injection
    }
}


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
