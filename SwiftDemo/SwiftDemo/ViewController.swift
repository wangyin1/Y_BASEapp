//
//  ViewController.swift
//  SwiftDemo
//
//  Created by 王印 on 16/9/1.
//  Copyright © 2016年 王印. All rights reserved.
//

import UIKit




class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var tableView:UITableView?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
         tableView = UITableView.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height), style:.Plain);
        
        tableView?.delegate = self;
        tableView?.dataSource = self;
        
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!);
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCellWithIdentifier("cell")!;
        cell?.textLabel?.text=NSString.init(format: "第%d个cell", indexPath.section) as String;
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var alert:UIAlertView?
        alert = UIAlertView.init(title: "提示", message: NSString.init(format: "点击了第%d个cell", indexPath.section) as String, delegate: nil, cancelButtonTitle: "取消");
        alert?.show();
        
    }

}

