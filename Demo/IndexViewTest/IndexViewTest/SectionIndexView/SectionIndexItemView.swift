//
//  SectionIndexItemView.swift
//  SectionIndexView
//
//  Created by 范庆宇 on 2021/6/15.
//

import UIKit

public class SectionIndexItemView: UIView {

    var sectionIndexItemConfig:SectionIndexItemConfig = SectionIndexItemConfig() {
        didSet{
            titleLabel.font = sectionIndexItemConfig.titleFont
            titleLabel.textColor = sectionIndexItemConfig.titleColor
            titleLabel.highlightedTextColor = sectionIndexItemConfig.titleSelectedColor
        }
    }
    
    var section:NSInteger?
    
    private var highlighted:Bool = false {
        didSet{
            titleLabel.isHighlighted = highlighted
            if highlighted {
                contentView.backgroundColor = sectionIndexItemConfig.contentSelectedColor
            }else {
                contentView.backgroundColor = sectionIndexItemConfig.contentColr
            }
        }
    }
    
    var selected:Bool = false {
        didSet{
            highlighted = selected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customInit() {
        self.addSubview(contentView)
        self.addSubview(titleLabel)
        
    }
    
    lazy var contentView:UIView = {
        let contentView = UIView.init(frame: CGRect.zero)
        return contentView;
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .center
        return label;
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect.init(x: 0, y: (self.bounds.size.height-self.bounds.size.width)/2.0, width: self.bounds.size.width, height: self.bounds.size.width)
        titleLabel.frame = self.contentView.bounds
        contentView.layer.cornerRadius = self.bounds.size.width/2.0
        
    }
}

public class CallOutView:UIView {
    
    var calloutViewConfig:CalloutViewConfig = CalloutViewConfig() {
        didSet{
            backgroundImageView.image = calloutViewConfig.calloutImage
            titleLabel.font = calloutViewConfig.titleFont
            titleLabel.textColor = calloutViewConfig.titleColor
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func customInit() {
        self.addSubview(backgroundImageView)
        self.addSubview(titleLabel)
        
    }
    
    lazy var backgroundImageView:UIImageView = {
        let backgroundImageView = UIImageView.init(frame: CGRect.zero)
        return backgroundImageView
        
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .center
        return label
        
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = self.bounds
        titleLabel.frame = self.bounds
        
    }
}
