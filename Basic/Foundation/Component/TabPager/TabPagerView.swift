//
//  TabPagerView.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//


import NSObject_Rx
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

// PageVC 델리게이트를 TabPager델리게이트로 복사 전달
@objc public protocol TabPagerViewDelegate: AnyObject {
    @objc optional func willSelectButton(from fromIndex: Int, to toIndex: Int) -> Bool
    @objc optional func didSelectButton(at index: Int)
    @objc optional func willTransition(to index: Int)
    @objc optional func didTransition(to index: Int)
}

public protocol TabPagerViewDataSource: AnyObject {
    func numberOfItems() -> Int?
    func controller(at index: Int) -> UIViewController?
    func setCell(at index: Int) -> TabPagerHeaderCellModel?
    /// 구분선 색깔
    func separatViewColor() -> UIColor
    /// 탭 상태
    func defaultIndex() -> Int
    func shouldEnableSwipeable() -> Bool // default is true
    func wholeCellModel() -> [TabPagerHeaderCellModel]
}

/// 딜리게이트 채택하여 각페이지마다 개별적인 설정이 가능하거나 닐합병연산자로 기본값을 준다.
@objc public protocol TabPagerViewDelegateLayout: AnyObject {
    // Header Setting

    /// 탭의 높이 default: 40
    @objc optional func heightForHeader() -> CGFloat
    /// default: 0
    @objc optional func leftOffsetForHeader() -> CGFloat
    /// 구분선 default: 2
    @objc optional func heightForSeparation() -> CGFloat
    /// 지시선 default: 2
    @objc optional func heightForIndicator() -> CGFloat
    /// 지시선 색깔 default: black
    @objc optional func colorForIndicator() -> UIColor
    /// backgroundColor
    @objc optional func backgroundColor() -> UIColor
    /// equalHeaderCellWidth
    @objc optional func isStaticCellWidth() -> Bool // default is true

}

class TabPagerView: UIView {
    // MARK: delegate
    weak var delegate: TabPagerViewDelegate?
    weak var dataSource: TabPagerViewDataSource?
    weak var layoutDelegate: TabPagerViewDelegateLayout?
    
    /// pageHeader를 쓸지 StackCollection을 쓸지 정해준다.
    var equleSpace = false
    
    var tabAnimation = true

    // MARK: init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }

    init(isEquleSpace: Bool = false, isTabAnimation: Bool = true ) {
        super.init(frame: .zero)
        self.equleSpace = isEquleSpace
        self.tabAnimation = isTabAnimation
        setupLayout()
        binding()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
        binding()
    }

    // MARK: view
    /// 고정된 헤더탭
    private lazy var stackCollection = StackCollection().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        // .equalSpacing으로 하게 되면 글자크기만큼만 width를 잡는다.
        $0.distribution = .fillEqually
        $0.delegate = self
    }
    
    /// 구분선
    lazy var separateView = UIView().then {
        $0.accessibilityLabel = "SeparateView"
    }
    
    /// 탭 지시선
    private lazy var indicatorView = UIView().then {
        $0.layer.cornerRadius = 1.5
        $0.backgroundColor = self.layoutDelegate?.colorForIndicator?() ?? .black
        $0.accessibilityLabel = "IndicatorView"
    }
    
    /// 좌우 스크롤되는 헤더탭
    private lazy var pagerHeader = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        if !equleSpace {
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: 50, height: 50)
    }).then {
        $0.register(TabPagerHeaderCell.self, forCellWithReuseIdentifier: TabPagerHeaderCell.identifier)
        $0.backgroundColor = R.Color.background
//        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 6)
        $0.dataSource = self
        $0.delegate = self
    }

    private lazy var contentView = TabPagerContents().then {
        $0.onSelectionChanged = selectionChangeCloser
    }

    // MARK: Property
    /// PVC 스와이프시 index 변경을 전달
    lazy var selectionChangeCloser : ((_ index: Int) -> Void) = { index in
        self.current.accept(index)
        self.oldIndex.accept(index)
    }

    private lazy var current = BehaviorRelay<Int?>(value: nil)
    
    private lazy var oldIndex = BehaviorRelay<Int?>(value: defaultPageIndex)

    private var defaultPageIndex: Int? {
        guard let _ = self.dataSource?.numberOfItems() else {
            return nil
        }
        guard let index = self.dataSource?.defaultIndex() else {
            return 0
        }
        return index
    }

    public weak var hostController: UIViewController?

    func setupLayout() {
        if !equleSpace {
            if let _ = pagerHeader.superview {
                pagerHeader.removeFromSuperview()
            }

            self.addSubview(pagerHeader)
            pagerHeader.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(30)
            }
        } else {
            // add Stack
            if let _ = stackCollection.superview {
                stackCollection.removeFromSuperview()
            }
            self.addSubview(stackCollection)
            stackCollection.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(33) //높이 설정 필요...
            }
        }

        if let _ = separateView.superview {
            separateView.removeFromSuperview()
        }
        
        insertSubview(separateView, at: 0)
        separateView.snp.makeConstraints {
            $0.top.equalTo(self.equleSpace ? stackCollection.snp.bottom : pagerHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        if let _ = contentView.superview {
            contentView.removeFromSuperview()
        }

        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(separateView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func binding() {
        self.current.compactMap { $0 }
            //.distinctUntilChanged()
            .subscribe(onNext: { [weak self] currentIndex in
                guard let `self` = self else { return }
                let interactionView = self.equleSpace ? self.stackCollection : self.pagerHeader
                interactionView.isUserInteractionEnabled = false
                self.contentView.pageScroll(to: currentIndex) {
                    interactionView.isUserInteractionEnabled = true
                }
                
                UIView.animate(withDuration: self.tabAnimation ? 0.2 : 0, delay: 0, options: .curveEaseInOut) {
                    self.indicatorView.frame.origin.x = (self.stackCollection.frame.width / CGFloat(self.dataSource?.numberOfItems() ?? 4)) * CGFloat(currentIndex)
                } completion: { _ in
                    // 백그라운드 -> 포그라운드 진입시 레이아웃 정보가 잡히지 않는 문제로 인한 계산식
                    self.indicatorView.snp.updateConstraints {
                        $0.leading.equalToSuperview().offset((self.stackCollection.frame.width / CGFloat(self.dataSource?.numberOfItems() ?? 4)) * CGFloat(currentIndex))
                    }
                }
        }).disposed(by: rx.disposeBag)

        let currentIndex = current.filter { $0 != nil }
            .map { index in
                return IndexPath(item: index!, section: 0)
            }

        if !equleSpace {
            pagerHeader.rx.itemSelected
                .map { $0.item }
                .bind(to: current)
                .disposed(by: rx.disposeBag)

            currentIndex.subscribe(onNext: { [weak self] index in
                self?.pagerHeader.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
            }).disposed(by: rx.disposeBag)
        } else {
            // currentIndex bind stackSelection
            currentIndex.subscribe(onNext: { [weak self] index in
                self?.stackCollection.reloadData(at: index.item)
            }).disposed(by: rx.disposeBag)
        }
    }

    func reload() {
        self.contentView.delegate = self.delegate
        self.contentView.dataSource = self.dataSource
        self.contentView.hostController = self.hostController

        if !equleSpace {
            self.pagerHeader.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(self.layoutDelegate?.leftOffsetForHeader?() ?? 0)
                $0.top.trailing.equalToSuperview()
                $0.height.equalTo(self.layoutDelegate?.heightForHeader?() ?? 40)
            }

            self.pagerHeader.reloadData()

            if let bgColor = self.layoutDelegate?.backgroundColor?() {
                self.contentView.backgroundColor = bgColor
                pagerHeader.backgroundColor = bgColor
            }
        } else {
            // stack reloadData

            if let itemCount = dataSource?.numberOfItems(), itemCount == 1 {
                self.stackCollection.snp.remakeConstraints {
//                    $0.leading.equalToSuperview().offset(20)
//                    $0.trailing.equalToSuperview().offset(-20)
                    $0.leading.equalToSuperview().offset(20)
                    $0.width.equalTo(63)
                    $0.top.equalToSuperview()
                    $0.height.equalTo(self.layoutDelegate?.heightForHeader?() ?? 56)
                }
            } else {
                self.stackCollection.snp.remakeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalToSuperview()
                    $0.height.equalTo(self.layoutDelegate?.heightForHeader?() ?? 56)
                }
            }
            self.stackCollection.addArrangedSubviews(models: dataSource?.wholeCellModel() ?? [])
            self.stackCollection.reloadInputViews()
        }
        
        separateView.snp.makeConstraints {
            $0.height.equalTo(self.layoutDelegate?.heightForSeparation?() ?? 2)
        }
        
        
        self.contentView.reload(self.current.value ?? 0)
        
        // 안하면 stackCollection.frame.width가 0으로 찍힘
        layoutIfNeeded()

        guard let count = self.dataSource?.numberOfItems() else { return }
        stackCollection.addSubview(indicatorView)
        indicatorView.snp.remakeConstraints {
            $0.width.equalTo(stackCollection.frame.width/CGFloat(count))
            $0.height.equalTo(self.layoutDelegate?.heightForIndicator?() ?? 2)
            $0.bottom.equalTo(separateView.snp.top).offset(1)
            $0.leading.equalToSuperview().offset((self.stackCollection.frame.width / CGFloat(self.dataSource?.numberOfItems() ?? 4)) * CGFloat(self.current.value ?? 0))
        }
    }

    func didLoadsetupLayout(handler: (() -> Void)? = nil) {
        separateView.backgroundColor = dataSource?.separatViewColor() ?? .lightGray
        
        self.contentView.reload(current.value ?? 0)

        if (self.layoutDelegate?.isStaticCellWidth?() ?? false) && !equleSpace {
            updateFixedHeaderCelllayout(count: self.dataSource?.numberOfItems() ?? 0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let `self` = self else { return }
            self.changeIndex(self.defaultPageIndex ?? 0)
            self.layoutIfNeeded()
            handler?()
        })
    }

    func changeIndex(_ index: Int) {
        self.current.accept(index)
        self.oldIndex.accept(index)
    }

    func updateFixedHeaderCelllayout(count: Int) {
        switch count {
        case 2, 3:
            let cellWidth = (UIScreen.main.bounds.width - 40) / CGFloat(count)
            pagerHeader.setCollectionViewLayout(UICollectionViewFlowLayout().then {
                $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0
                $0.minimumInteritemSpacing = 0
                $0.itemSize = CGSize(width: cellWidth, height: self.layoutDelegate?.heightForHeader?() ?? 56)
            }, animated: true)
        default: break
        }
    }

    func spacing() -> CGFloat {
        if let items = dataSource?.numberOfItems() {
            let cellsItemSize = (0..<items).map {
                dataSource?.setCell(at: $0)
            }.compactMap {
                guard var width = $0?.title.widthOfString(usingFont: TabPagerHeaderDefault.selectedFont) else { return nil }
                if width < 30 {
                    width = CGFloat(31)
                }
//                return ceil(width)
                return width
            }.reduce(CGFloat(0), +)

            return UIScreen.main.bounds.width - cellsItemSize - 40
        }

        return 0
    }
}

extension TabPagerView: SCDelegate {
    /// 헤더탭을 탭할 시 index 전달
    func stackCollection(_ sc: StackCollection, didSelectItemAt item: Int) {
        current.accept(item)
        oldIndex.accept(item)
    }
}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TabPagerView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabPagerHeaderCell.reuseIdentifier, for: indexPath) as? TabPagerHeaderCell, let data = self.dataSource?.setCell(at: indexPath.item) {
            cell.cellset(data)

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.collectionViewLayout.invalidateLayout()

        self.current.accept(indexPath.item)
        self.oldIndex.accept(indexPath.item)
//
//        DispatchQueue.main.async {
//            collectionView.layoutIfNeeded()
//            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
    }
}
