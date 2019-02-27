//
//  OWXReaderCollectionViewCell.swift
//  LeapParent
//
//  Created by 王史超 on 2018/7/2.
//  Copyright © 2018年 offcn. All rights reserved.
//

import UIKit

class OWXReaderCollectionViewCell: UICollectionViewCell {
    
    var pictureView: UIImageView!
    var statementLabel: UILabel!
    
    var wordRanges = [NSRange]()
    
    var sectionModel: OWXReaderSectionModel? {
        didSet {
            
            guard let section = sectionModel else { return }
            
            wordRanges.removeAll()
            if let words = section.words {
                for wordModel in words {
                    let rang = (section.text as NSString).range(of: wordModel.word_text)
                    wordRanges.append(rang)
                }
            }
            
            let attributedText = NSMutableAttributedString(string: section.text)
            attributedText.addAttributes([NSForegroundColorAttributeName : UIColor.white], range: NSMakeRange(0, attributedText.length))
            statementLabel.attributedText = attributedText
            
            guard let sectionIndex = Int(section.section_sequence) else { return }
            
            if sectionIndex == 1 {
                pictureView.image = UIImage(named: "cover.png")
            }
            else {
                pictureView.image = UIImage(named: "p_\(sectionIndex - 1).png")
            }
            
        }
    }
    
    func updateStatementState(rang: NSRange?) {
        
        let attributeString = NSMutableAttributedString(string: statementLabel.text!)
        attributeString.addAttributes([NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, attributeString.length))
        
        if let currentRang = rang {
            attributeString.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: currentRang)
        }

        statementLabel.attributedText = attributeString
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildSubViews()
    }
    
    func buildSubViews() {
        
        pictureView = UIImageView()
        contentView.addSubview(pictureView)
        pictureView.mas_makeConstraints { (make) in
            make?.top.offset()(0)
            make?.left.offset()(0)
            make?.right.offset()(0)
            make?.height.mas_equalTo()(380)
        }
        pictureView.contentMode = .scaleAspectFit
        
        statementLabel = UILabel()
        contentView.addSubview(statementLabel)
        statementLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(-20)
            make?.top.equalTo()(pictureView.mas_bottom)?.offset()(0)
        }
        
        statementLabel.numberOfLines = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
