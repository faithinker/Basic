//
//  TabPagerHeaderView.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class TabPagerHeaderView: UIView {
    var data: TabPagerHeaderCellModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View
    lazy var title = UIButton()
//        .then {
//        $0.setTitleColor(.white ~ 70%, for: .normal)
//        $0.setTitleColor(.white, for: .selected)
//        $0.setTitleColor(.white, for: .highlighted)
//    }

    let container = UIView()

    var selectedFont: UIFont = TabPagerHeaderDefault.selectedFont
    var deSelectedFont: UIFont = TabPagerHeaderDefault.deSelectedFont

    var selectedColor: UIColor = TabPagerHeaderDefault.selectedColor
    var deSelectedColor: UIColor = TabPagerHeaderDefault.deSelectedColor

    func setupLayout() {
        self.addSubview(container)
        container.addSubview(title)

        title.isSelected = false
    }

    func setupDI(index: Int, actionRelay: PublishRelay<Int>) {
        title.rx.tap
            .map { index }
            .bind(to: actionRelay)
            .disposed(by: rx.disposeBag)
    }

    func bindView() {
        self.title.rx.observe(Bool.self, "selected").compactMap { $0 }
            .subscribe(onNext: {[weak self] isSelected in
                guard let `self` = self else { return }
//                self.title.titleLabel?.font = isSelected ? self.selectedFont : self.deSelectedFont
            }).disposed(by: rx.disposeBag)
    }

    func cellset(_ data: TabPagerHeaderCellModel?) {

        self.selectedFont = data?.selectedFont ?? TabPagerHeaderDefault.selectedFont
        self.deSelectedFont = data?.deSelectedFont ?? TabPagerHeaderDefault.deSelectedFont

        self.selectedColor = data?.titleSelectedColor ?? TabPagerHeaderDefault.selectedColor
        self.deSelectedColor = data?.titleDeSelectedColor ?? TabPagerHeaderDefault.deSelectedColor

        title.setAttributedTitle(data?.title.styling(.font(deSelectedFont), .color(deSelectedColor), .letterSpace(-0.4)), for: .normal)
        title.setAttributedTitle(data?.title.styling(.font(selectedFont), .color(selectedColor), .letterSpace(-0.4)), for: .selected)
        guard let string = data?.title else { return }
        let currentFont = title.isSelected ? self.selectedFont : self.deSelectedFont
        var width = string.widthOfString(usingFont: currentFont)
        if width < 30 {
            width = 31
        }
        Log.d("title: \(data?.title), width: \(width), font : \(currentFont)")

        if let normalImg = data?.iconImage {
            title.setImage(normalImg, for: .normal)
        }
        if let selectedImage = data?.iconSelectedImage {
            title.setImage(selectedImage, for: .highlighted)
            title.setImage(selectedImage, for: .selected)
        }
        
        if let highlightedImg = data?.iconHighlightedImage {
            title.setImage(highlightedImg, for: .highlighted)
        }
        
        if let iconEdgeInset = data?.iconEdgeInset {
            title.imageEdgeInsets = iconEdgeInset
        }
        
        container.snp.remakeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(56)
        }

        title.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
//            $0.top.equalToSuperview()
//            $0.width.equalTo(ceil(width))
            $0.top.equalToSuperview().offset(4)
//            $0.height.equalTo(25)
            $0.bottom.equalToSuperview().offset(-3)
            $0.width.equalTo(width)
        }

        updateConstraints()
        layoutIfNeeded()
    }
}

