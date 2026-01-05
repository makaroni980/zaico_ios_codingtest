//
//  InventoryTableViewCell.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

/**
 ラベルのみの在庫セル
 */
class InventoryCell: UITableViewCell {
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 左側のラベルの設定
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 右側のラベルの設定
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        
        // レイアウト制約
        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 10),
            
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            rightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(leftText: String, rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
}
