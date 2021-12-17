//
//  ReportSubViewModel.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import Action

enum ReportType: String {
    case day, week, month
}

enum ReportSubActionType {
    
}

class ReportSubViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = ReportSubViewModel
    
    var disposeBag = DisposeBag()
    
    var modelType: ReportType = .day
    
    let action = PublishRelay<HomeActionType>()
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - Actions
    lazy var actionForNaviBar = Action<BaseNavigationActionType, Void> { [weak self] in
        guard let `self` = self else { return .empty() }
        switch $0 {
        case .back:
            self.steps.accept(MainSteps.popViewController)
        default: break
        }
        return .empty()
    }
    
    struct Input {
        let actionTrigger: Observable<HomeActionType>
    }
    
    struct Output {
        
    }
    
    // ParentView -> SubView Input
    func setupDI(_ actionRelay: PublishRelay<HomeActionType>) {
        self.action
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .bind(to: actionRelay)
            .disposed(by: disposeBag)
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        
        switch modelType {
        case .day:
            Log.d("jhKim : \(modelType)")
        case .week:
            Log.d("jhKim : \(modelType)")
        case .month:
            Log.d("jhKim : \(modelType)")
        }

        return Output()
    }
    
    
}
