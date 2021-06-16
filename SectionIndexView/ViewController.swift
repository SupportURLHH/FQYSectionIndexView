//
//  ViewController.swift
//  SectionIndexView
//
//  Created by 范庆宇 on 2020/10/16.
//

import UIKit

class ViewController: UIViewController, SectionIndexViewDelegate {

    var tableView:UITableView?
    
    var indexView:SectionIndexView?
    
    var sectionIndexTitles = ["A","B","C","D","E","F","G","H","I","J"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        indexView = SectionIndexView.init(frame: CGRect.init(x: self.view.frame.size.width-25, y: 20, width: 25, height: self.view.frame.size.height-40))
        indexView?.tableView = tableView
        indexView?.indexDelegate = self
        self.view.addSubview(indexView!)
        indexView?.sectionIndexTitles = sectionIndexTitles
        
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 200, y: 20, width: 100, height: 30)
        btn.setTitle("代码滚动", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(randomScroll), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }
    
    @objc func randomScroll() {
        // 虽然contentOffset 会变化，但是代码滚动和手动滚动没办法区别开，通过didSelectRowIndex方法选中SectionIndexView
        let section = arc4random()%10
        tableView?.scrollToRow(at: IndexPath(row: 0, section: Int(section)), at: .top, animated: true)
        indexView?.didSelectRowIndex(index: Int(section), byTouch: false)
        
    }
    
    func sectionIndexView(_ indexView: SectionIndexView, didSelect section: Int) {
        NSLog("选中了")
        
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionIndexTitles[section]
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionIndexTitles.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = String(format: "section:%@---%d",sectionIndexTitles[ indexPath.section],indexPath.row)
        return cell!
        
    }
    
    
}
