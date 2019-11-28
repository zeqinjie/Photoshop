//
//  BaseTableViewController.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/12/22.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit
import Hero
class BaseTableViewController: UITableViewController,ZQCommonProtocol {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSet()
        creatUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionEnable(isEnabled:false)
    }
    
    //MARK: - Override Method
    func defaultSet() {
        view.backgroundColor = ZQColor_181818
        navBarBgAlpha = 0
        navBarTintColor = .white
    }
    
    //MARK: - UI
    func creatUI() {
        creatBackBarBtn()
    }
    
    func creatBackBarBtn() {
        let backBtn = common_barBtnItem(btnType: .back,imgStr: "back", self, #selector(backAction(_:)))
        navigationItem.leftBarButtonItems = [backBtn]
    }
    
    // MARK: - Action
    @objc func backAction(_ btn:ZQButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Public Method
    func transitionEnable(isEnabled:Bool){
        self.navigationController?.hero.isEnabled = isEnabled
    }
    
    func setAutomaticallyAdjustsScrollView(_ scrollView: UIScrollView?) {
        if #available(iOS 11.0, *) {
            if scrollView != nil {
                scrollView?.contentInsetAdjustmentBehavior = .never
            }
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    

}
