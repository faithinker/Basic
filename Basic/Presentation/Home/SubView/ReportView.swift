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
    
    let mainView = UIView().then {
        $0.backgroundColor = UIColor.green ~ 20%
    }
    
    var containerView: TabPagerView!
    
    init(_ data: String = "") {
        super.init(frame: .zero)
        setupLayout()
        bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        
        self.containerView = TabPagerView(isEquleSpace: true)
        
        containerView.backgroundColor = .blue ~ 20%
        
        addSubview(mainView)
        mainView.snp.makeConstraints {
            //$0.edges.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
        
        addSubviews([containerView])
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // 이게 문제다... parentVC가 nil이라고 뜸... 시점문제..?
    // 리포트뷰가 생성되고 나서 homeView에서 addSubView가 발생하는 것 같다.
    // po parentViewController 찍어보면 nil 값이 나온다. HomeViewController가 나와야 하는데...
    func reloadDatas() {
        
        defer {
            let test = self.parentViewController as? ReportSubViewController
            Log.d("jhKim : \(test)")
        }
        
        if self.containerView.delegate == nil, let parentVC = self.parentViewController as? HomeViewController { // ParentViewController로 변경
            self.containerView.delegate = parentVC.viewModel
            self.containerView.layoutDelegate = parentVC.viewModel
            self.containerView.dataSource = parentVC.viewModel
            self.containerView.hostController = parentVC
            
            self.containerView.reload()
            
            self.containerView.didLoadsetupLayout()

        } else {
            Log.d("jhKim Test : \(containerView.delegate)")
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
