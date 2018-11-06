//
//  DashboardCell.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

class DashboardCell: UITableViewCell {
    
    var titleString: String?
    var iconImage: UIImage?
    
    var titleLabel = UILabel()
    var iconImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configure()
    }
    
    func configure(){
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = .clear
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(iconImageView)
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func update(){
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = self.titleString {
            titleLabel.text = title
        }
        
        if let icon = self.iconImage {
            self.iconImageView.image = icon
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
