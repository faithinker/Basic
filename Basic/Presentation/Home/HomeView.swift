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
        naviBar.title = "테스트"
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
