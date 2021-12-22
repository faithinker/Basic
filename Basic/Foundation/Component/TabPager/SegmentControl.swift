//
//  SegmentControl.swift
//  Basic
//
//  Created by pineone on 2021/12/20.
//

import Foundation
import SwiftUI

class SegmentControl: UIView {
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
    lazy var selectedSegment = UIButton().then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setBackgroundColor(UIColor(96, 57, 142) ~ 70%, for: .highlighted)
        $0.setBackgroundColor(UIColor(96, 57, 142), for: .selected)
    }
    
    lazy var title = UILabel().then {
        $0.textColor = .white
        $0.text = "네네네"
    }
    
    var selectedFont: UIFont = TabPagerHeaderDefault.selectedFont
    var deSelectedFont: UIFont = TabPagerHeaderDefault.deSelectedFont

    var selectedColor: UIColor = TabPagerHeaderDefault.selectedColor
    var deSelectedColor: UIColor = TabPagerHeaderDefault.deSelectedColor
    
    
    // MARK: Method
    func setupDI(index: Int, actionRely: PublishRelay<Int>) {
        
    }
    
    
    
    func setupLayout() {
        self.backgroundColor = UIColor(226, 227, 230) ~ 30%
        self.cornerRadius = 10
        
        addSubviews([selectedSegment])
        
        selectedSegment.addSubview(title)
        
        selectedSegment.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bindView() {
        self.selectedSegment.rx.observe(Bool.self, "selected").compactMap { $0 }
        .subscribe(onNext: { [weak self] isSelected in
            guard let `self` = self else { return }
            
            Log.d("jhKim Test : \(isSelected) ::: \(self.selectedSegment.state)")
            
            //self.selectedSegment.backgroundColor = .clear
            self.selectedSegment.isSelected = !isSelected
            
        }).disposed(by: rx.disposeBag)
        
        self.selectedSegment.rx.tap
            .subscribe(onNext: {
                Log.d("jhKim test : \($0)")
                
                //self.selectedSegment.isSelected = true
                
            }).disposed(by: rx.disposeBag)
        
        selectedSegment.rx.selected
            .subscribe(onNext: {
                Log.d("jhKim rx.selected : \($0) :: \(self.selectedSegment.state)")
            }).disposed(by: rx.disposeBag)
    }
    
    func cellset(_ data: TabPagerHeaderCellModel?) {

    }
    
    
}
