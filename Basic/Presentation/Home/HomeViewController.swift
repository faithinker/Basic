//
//  HomeViewController.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Then

class HomeViewController: UIBaseViewController, ViewModelProtocol {
    typealias ViewModel = HomeViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    private let actionTrigger = PublishRelay<HomeActionType>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
        subView.reportView.reloadDatas()
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        let res = viewModel.transform(req: ViewModel.Input(actionTrigger: actionTrigger.asObservable()))
        
        //subView.reportView.setupDI(actionRelay: )
    }
    
    // MARK: - View
    lazy var subView = HomeView()
    
    func setupLayout() {
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
}
