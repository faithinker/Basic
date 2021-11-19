//
//  ReviewTableViewCell.swift
//  Basic
//
//  Created by pineone on 2021/11/08.
//

import RxCocoa
import RxSwift
import Reusable
import UIKit
import SDWebImage

/// Center - App Rating
class ReviewTableViewCell: UITableViewCell, Reusable {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    lazy var reviewTitle = UILabel().then {
        $0.text = "리뷰 (152건)"
    }
    
    lazy var divider = UIView().then {
        $0.backgroundColor = .systemGray3
    }
    
    
    lazy var name = UILabel()
    
    lazy var parentInfo = UILabel()
    
    lazy var editButton = UIButton()
    
    lazy var removeButton = UIButton()
    
    lazy var date = UILabel()
}
