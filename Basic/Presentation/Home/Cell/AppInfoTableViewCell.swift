//
//  AppInfoTableViewCell.swift
//  Basic
//
//  Created by pineone on 2021/11/08.
//

import RxCocoa
import RxSwift
import Reusable
import UIKit
import SDWebImage


class AppInfoTableViewCell: UITableViewCell, Reusable {

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View
    lazy var appImage = UIImageView().then {
        $0.cornerRadius = 8
    }
    
    lazy var appName = UILabel().then {
        $0.text = "브롤스타즈"
    }
    
    lazy var appVersion = UILabel().then {
        $0.text = "버전 1.0.2"
    }
    
    lazy var appDesc = UILabel().then {
        $0.text = "만5세 / 순위 N위 / 일 평균 1시간 20분"
    }
    
    
    func setupLayout() {
        contentView.addSubviews([appImage, appName, appVersion, appDesc])
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.leading.trailing.equalToSuperview()
        }
        
        appImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        appName.snp.makeConstraints {
            $0.top.equalTo(appImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        appVersion.snp.makeConstraints {
            $0.top.equalTo(appName.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        appDesc.snp.makeConstraints {
            $0.top.equalTo(appVersion.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setData(_ item: HomeModel) {
        if let strUrl = item.appImageUrl, let imgUrl = URL(string: strUrl) {
            appImage.sd_setImage(with: imgUrl)
        }
        
        if let name = item.appName {
            appName.text = name
        }
        
        if let version = item.apppVersion {
            appVersion.text = version
        }
        
        if let desc = item.appDesc {
            appDesc.text = desc
        }
    }
}
