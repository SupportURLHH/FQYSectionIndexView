//
//  FQYSectionIndexView.swift
//  FQYSectionIndexView
//
//  Created by 范庆宇 on 2021/6/15.
//

import UIKit

let kFQYSectionIndexViewObserveKeyPath = "contentOffset"

protocol FQYSectionIndexViewDelegate:class {
    func FQYSectionIndexView(_ indexView:FQYSectionIndexView, didSelect section:Int)
    
}

class SectionIndexItemConfig {
    var titleColor:UIColor = UIColor.black
    var titleSelectedColor:UIColor = UIColor.white
    var contentColr:UIColor = UIColor.clear
    var contentSelectedColor:UIColor = UIColor.green
    var titleFont:UIFont = UIFont.systemFont(ofSize: 11)
    
}

class CalloutViewConfig {
    var calloutImage:UIImage = UIImage(named: "bg_retrieving_letter")!
    var titleFont:UIFont = UIFont.boldSystemFont(ofSize: 20)
    var titleColor:UIColor = UIColor.white
    
}

class FQYSectionIndexView: UIView {

    var sectionIndexItemConfig:SectionIndexItemConfig = SectionIndexItemConfig()
    
    var calloutViewConfig:CalloutViewConfig = CalloutViewConfig(){
        didSet{
            calloutView.calloutViewConfig = calloutViewConfig
            
        }
    }
    
    var backgroundViewColor:UIColor = UIColor.clear {
        didSet {
            contentView.backgroundColor = backgroundViewColor
        }
    }
    
    private var kContentViewHMargin: CGFloat = 5
    private var kContentViewVMargin: CGFloat = 5
    private var kContentViewVPadding: CGFloat = 5
    private var itemViewSpace:CGFloat = 5
    private var itemViewHeight:CGFloat = 25
    
    weak var tableView:UITableView? {
        didSet {
            if oldValue != nil {
                tableView?.removeObserver(self, forKeyPath: kFQYSectionIndexViewObserveKeyPath)
            }
            let options = NSKeyValueObservingOptions.init(rawValue: NSKeyValueObservingOptions.old.rawValue + NSKeyValueObservingOptions.new.rawValue)
            tableView?.addObserver(self, forKeyPath: kFQYSectionIndexViewObserveKeyPath, options: options , context: nil)
        }
    }
    
    weak var indexDelegate:FQYSectionIndexViewDelegate?
    
    var sectionIndexTitles = [String]() {
        didSet{
            reloadItemViews()
        }
    }
    private var currentItemIndex:Int = -1
    private var itemViewList = [FQYSectionIndexItemView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = backgroundViewColor
        
        self.addSubview(contentView)
        self.addSubview(calloutView)
        
    }
    
    /**
     选中索引操作
     @param index   索引的位置
     @param isTouch 是否是触摸触发
     */
    func didSelectRowIndex(index:Int, byTouch isTouch:Bool){
        //如果选中的索引超出标题数组，或者和当前选中的相同则直接return
        if index >= self.sectionIndexTitles.count || index < 0 || index == currentItemIndex {
            return
            
        }
        
        if currentItemIndex != index {
            //保存当前选中的index
            currentItemIndex = index
            //如果正常状态颜色和高亮颜色则循环遍历设置选中的index为高亮颜色
            selectItemViewForSection(section: index)
            if isTouch {
                // 显示指示器
                let itemView = self.itemViewList[index]
                let title = self.sectionIndexTitles[index]
                showIndecatorWithTitle(titleStr: title, and:( itemView.frame.origin.y + itemView.frame.size.height/2.0 + contentView.frame.origin.y))
                //如果当前选中的index在tablview的section范围内，则滚动tableview到相应位置
                if index < tableView?.numberOfSections ?? 0 {
                    tableView?.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
                    
                }
                //通知代理
                indexDelegate?.FQYSectionIndexView(self, didSelect: index)
                
            }
        }
    }
    
    private func reloadFirstShow() {
        currentItemIndex = -1 // 重置
        didSelectRowIndex(index: 0, byTouch: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func reloadItemViews() {
        itemViewHeight = self.frame.size.width - kContentViewHMargin*2
        for itemView in itemViewList {
            itemView.removeFromSuperview()
        }
        itemViewList.removeAll()
        for (index,title) in sectionIndexTitles.enumerated() {
            let frame = CGRect.init(x: 0, y:kContentViewVPadding + CGFloat(index)*(itemViewHeight+itemViewSpace), width: self.frame.size.width-2*kContentViewHMargin, height: itemViewHeight)
            let itemView = FQYSectionIndexItemView.init(frame: frame)
            itemView.sectionIndexItemConfig = sectionIndexItemConfig
            itemView.titleLabel.text = title
            itemViewList.append(itemView)
            contentView.addSubview(itemView)
            
        }
        
        layoutFrame()
        
        setNeedsDisplay()
        layoutIfNeeded()
        
        reloadFirstShow()
        
    }
    
    private func layoutFrame() {
        setCalloutViewFrame()
        setContentViewFrame()
        
    }

    private func selectItemViewForSection(section: Int){
        for itemView in itemViewList {
            itemView.selected = false
        }
        
        let seletedItemView = itemViewList[section]
        seletedItemView.selected = true
        indexDelegate?.FQYSectionIndexView(self, didSelect: section)
        
    }
    
    private func setContentViewFrame() {
        let contentHeight = (itemViewHeight + itemViewSpace) * CGFloat(sectionIndexTitles.count) + 2*kContentViewVPadding - 2*kContentViewVMargin
        let contentRect = CGRect.init(x: kContentViewHMargin, y: (self.frame.size.height - contentHeight)/2.0 + kContentViewVMargin, width: self.frame.size.width - 2*kContentViewHMargin, height: contentHeight)
        contentView.frame = contentRect
        contentView.layer.cornerRadius = (self.frame.size.width - 2*kContentViewHMargin)/2.0
        
    }
    
    private func setCalloutViewFrame() {
        calloutView.frame = CGRect(x: 0, y: 0, width: calloutViewConfig.calloutImage.size.width, height: calloutViewConfig.calloutImage.size.height)
        let calloutViewMidW = calloutView.frame.width/2
        let centerX = calloutViewMidW
        calloutView.center = CGPoint(x: -centerX, y: calloutView.center.y)
        
    }
    
    lazy var contentView: UIView = {
        let v = UIView()
        return v
        
    }()
    
    // 左侧 indicator
    lazy var calloutView: CallOutView = {
        let v = CallOutView()
        v.isHidden = true
        v.calloutViewConfig = calloutViewConfig
        return v
        
    }()
    
    deinit {
        tableView?.removeObserver(self, forKeyPath: kFQYSectionIndexViewObserveKeyPath)
        
    }
    
}


extension FQYSectionIndexView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let e = event {
            handleTouches(touches: touches, withEvent: e)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let e = event {
            handleTouches(touches: touches, withEvent: e)
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let e = event {
            handleEndTouches(touches: touches, withEvent: e)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let e = event {
            handleEndTouches(touches: touches, withEvent: e)
        }
        
    }
    
    /**
        处理触摸结束和取消事件
    */
    func handleEndTouches(touches:Set<UITouch>, withEvent:UIEvent) {
        //延迟隐藏指示器
        self.perform(#selector(dismissIndecatorTitle), with: nil, afterDelay: 0.5)
        
    }
    
    /**
        处理触摸事件
     */
    func handleTouches(touches:Set<UITouch>, withEvent:UIEvent) {
        //获取触摸点位置
        let touch = touches.first
        if let touchPoint = touch?.location(in: contentView) {
            if touchPoint.x < 0 {
                return
            }
            var index = (touchPoint.y - kContentViewVPadding) / (itemViewHeight + itemViewSpace) //通过触摸的位置计算出选中的索引
            if index < 0 {
                index = 0
                
            }else if index >= CGFloat(sectionIndexTitles.count) {
                index = CGFloat(self.sectionIndexTitles.count - 1)
                
            }
            didSelectRowIndex(index: Int(index), byTouch: true)
            
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kFQYSectionIndexViewObserveKeyPath {
            if let oldValue = change?[NSKeyValueChangeKey.oldKey] as? NSValue {
                if let newValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                    let oldoffset_y = oldValue.uiOffsetValue.vertical
                    let newoffset_y = newValue.uiOffsetValue.vertical
                    //scrollView的滑动不是由手指拖拽产生
                    if !(tableView?.isDragging ?? false) && !(tableView?.isDecelerating ?? false) {
                        return
                        
                    }
                    
                    /*
                    //滑到边界时，继续通过scrollView的bouces效果滑动时，直接return
                    if (tableView?.contentOffset.y ?? 0.0 < 0) || ((tableView?.contentOffset.y ?? 0.0) > ((tableView?.contentSize.height ?? 0.0) - (tableView?.bounds.size.height ?? 0.0))) {
                        return
                        
                    }
                    */
                    //如果contenoffset不变了说明停止滚动了，否则还在滚动
                    if newoffset_y != oldoffset_y {
                        tableViewDidScroll()
                        
                    }else{
                        tableViewDidEndScroll()
                    }
                }
            }
        }
    }
    
    /**
     tableView滚动
     */
    func tableViewDidScroll() {
        //计算出当前滚动到的section
        if let rows = tableView?.indexPathsForVisibleRows {
            let row = rows[0]
            let section = row.section
            didSelectRowIndex(index: section, byTouch: false)
            
        }
    }
    
    /**
     tableView停止滚动
     */
    func tableViewDidEndScroll() {
        
    }
    
    /**
     显示指示器
     @param titleStr 指示器的标题
     @param centerY  指示器的中心点Y值
     */
    func showIndecatorWithTitle(titleStr:String, and centerY:CGFloat) {
        self.calloutView.isHidden = false
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismissIndecatorTitle), object: nil)//取消隐藏指示器的方法
        //根据指示器的中心Y值计算出Center
        var center:CGPoint = self.calloutView.center
        center.y = centerY
        self.calloutView.center = center
        self.calloutView.titleLabel.text = titleStr
        
    }

    /**
     隐藏指示器
     */
    @objc func dismissIndecatorTitle() {
        self.calloutView.isHidden = true

    }
    
}


