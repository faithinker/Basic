//
//  TabPagerHeaderCellModel.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//

import UIKit

public struct TabPagerHeaderCellModel {
    var title: String
    var selectedFont: UIFont?
    var deSelectedFont: UIFont?

    var titleSelectedColor: UIColor?
    var titleDeSelectedColor: UIColor?

    var displayNewIcon: Bool?
    var iconImage: UIImage?
    var iconSelectedImage: UIImage?
    var iconHighlightedImage: UIImage?
    var indicatorPadding: CGFloat? = nil // 삭제
    var iconEdgeInset: UIEdgeInsets? = nil
    
    func callAsFunction() -> TabPagerHeaderView {
        TabPagerHeaderView().then {
            $0.cellset(self)
            $0.data = self
        }
    }
}

/// 탭페이저 상단의 아이템 설정.
/// 구분선 및 지시선은 TabPagerView의 DataSource와 LayoutDelegate에서 처리함
class TabPagerHeaderDefault {
    static let selectedFont = UIFont.notoSans(.bold, size: 16)
    static let selectedColor: UIColor = .black //R.Color.black
    static let deSelectedFont = UIFont.notoSans(.bold, size: 16)
    static let deSelectedColor: UIColor = R.Color.black ~ 50%
}
