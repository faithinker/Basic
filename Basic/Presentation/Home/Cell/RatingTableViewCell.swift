//
//  RatingTableViewCell.swift
//  Basic
//
//  Created by pineone on 2021/11/08.
//

import RxCocoa
import RxSwift
import Reusable
import UIKit


/// Bottom - Review
class RatingTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var ratingTitle = UILabel().then {
        $0.text = "평가 (10명 참여)"
        $0.font = R.font.notoSansKRBold(size: 32)
    }
    
    lazy var ratingButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("앱 평가하기", for: .normal)
        $0.setBackgroundColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .highlighted)
        $0.borderColor = .black
        $0.borderWidth = 1
        $0.cornerRadius = 8
        
    }
    
    func setupLayout() {
        addSubview(ratingTitle)
        
        ratingTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalTo(5)
            $0.centerX.equalToSuperview()
        }
        
        ratingButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func setData(_ item: String?) {
        if let people = item {
            ratingTitle.text = "평가 (" + people + "명 참여)"
        }
    }

}
