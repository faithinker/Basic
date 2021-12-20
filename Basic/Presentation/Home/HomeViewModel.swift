//
//  HomeViewModel.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow

enum HomeActionType {
    case report
}

class HomeViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    let disposeBag = DisposeBag()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = HomeViewModel
    
    /// 페이지컨트롤러 Model
    private lazy var cellModel: [TabPagerHeaderCellModel] = makeModels()
    private lazy var subControllers: [UIViewController] = makeInit()
    
    // 이모티콘 액션
    let subViewTrigger = PublishRelay<HomeActionType>()
    
    struct Input {
        let actionTrigger: Observable<HomeActionType>
    }
    
    struct Output {
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.actionTrigger.subscribe(onNext: { [weak self] type in
            self?.actionProcess(type)
        }).disposed(by: disposeBag)
        
        // 페이지 컨트롤러
        subViewTrigger.subscribe(onNext: { [weak self] type in
            self?.actionProcess(type)
            
        }).disposed(by: disposeBag)
        
        return Output()
    }
    
    
    func actionProcess(_ type: HomeActionType) {
        switch type {
        case .report:
            Log.d("type : \(type)")
        }
    }
    
    func makeInit() -> [UIViewController] {
        let vc1 = ReportSubViewController()
        let vm1 = ReportSubViewModel()
        vm1.modelType = .day
        vc1.viewModel = vm1
        vm1.setupDI(self.subViewTrigger)
        
        let vc2 = ReportSubViewController()
        let vm2 = ReportSubViewModel()
        vm2.modelType = .week
        vc2.viewModel = vm2
        vm2.setupDI(self.subViewTrigger)
        
        let vc3 = ReportSubViewController()
        let vm3 = ReportSubViewModel()
        vm3.modelType = .month
        vc3.viewModel = vm3
        vm3.setupDI(self.subViewTrigger)
        
        return [vc1, vc2, vc3]
    }
    
    func makeModels() -> [TabPagerHeaderCellModel] {
        let dayTableHeaderCell = TabPagerHeaderCellModel(title: "일별", indicatorHeight: 4)
        let weekTableHeaderCell = TabPagerHeaderCellModel(title: "주별", indicatorHeight: 4)
        let monthTableHeaderCell = TabPagerHeaderCellModel(title: "월별", indicatorHeight: 4)
        
        let models: [TabPagerHeaderCellModel] = [dayTableHeaderCell, weekTableHeaderCell, monthTableHeaderCell]
        
        return models
    }
}


extension HomeViewModel: TabPagerViewDataSource {
    func numberOfItems() -> Int? {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController? {
        return self.subControllers[index]
    }
    
    func setCell(at index: Int) -> TabPagerHeaderCellModel? {
        return self.cellModel[index]
    }
    
    func separatViewColor() -> UIColor {
        return .clear
    }
    
    func defaultIndex() -> Int {
        return 0
    }
    
    func shouldEnableSwipeable() -> Bool {
        return true
    }
    
    func wholeCellModel() -> [TabPagerHeaderCellModel] {
        return self.cellModel
    }
}


extension HomeViewModel: TabPagerViewDelegate {
    func didTransition(to index: Int) {
        if let vc = subControllers[index] as? ReportSubViewController {
            Log.d("JHKim : \(vc.viewModel.modelType.rawValue)")
        }
    }
    func didSelectButton(at index: Int) {
        if let vc = subControllers[index] as? ReportSubViewController {
            Log.d("JHKim : \(vc.viewModel.modelType.rawValue)")
        }
    }
}

extension HomeViewModel: TabPagerViewDelegateLayout {
    func leftOffsetForHeader() -> CGFloat { // 이만큼 공간 만들고 view에서 버튼 넣으면 될듯. 가로 50 세로 50으로.
        return 56
    }
    
    func heightForHeader() -> CGFloat {
        return 55
    }
    
    func heightForSeparation() -> CGFloat {
        return 0
    }
    
    func backgroundColor() -> UIColor {
        return .clear // #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1294117647, alpha: 0.5047451762)
    }
}
