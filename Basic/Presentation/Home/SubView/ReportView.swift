//
//  ReportView.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import Action

class ReportView: UIView {
    
    var PVC: UIViewController?
    
    let disposeBag = DisposeBag()

    let action = PublishRelay<HomeActionType>()
    
    lazy var containerView = TabPagerView()
    
    init(_ data: String = "") {
        super.init(frame: .zero)
        setupLayout()
        bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - View

    
    // MARK: - Methods
    func setupLayout() {
        
        self.containerView = TabPagerView(isEquleSpace: true, isTabAnimation: false)
        
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
            //$0.edges.equalToSuperview()
        }
    }
    
    func reloadDatas() {
        // 현재 뷰가 부모뷰에 addSubView가 된 상태이고 레이아웃까지 잡혀있어야 한다.
        if self.containerView.delegate == nil, let parentVC = self.parentViewController as? HomeViewController { // ParentViewController로 변경
            self.containerView.delegate = parentVC.viewModel
            self.containerView.layoutDelegate = parentVC.viewModel
            self.containerView.dataSource = parentVC.viewModel
            self.containerView.hostController = parentVC
            
            self.containerView.reload()
            self.containerView.didLoadsetupLayout()

        }
    }
    
    // 액션 바인딩
    func bindData() {
        
    }
    
    func setupDI(actionRelay: PublishRelay<HomeActionType>) {
        self.action
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .bind(to: actionRelay)
            .disposed(by: rx.disposeBag)
    }
    

    
}
