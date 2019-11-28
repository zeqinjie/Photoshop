//
//  BaseViewController.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import Hero
class BaseViewController: UIViewController,ZQCommonProtocol {
    
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

/*
 
 //MARK: - LifeCycle
 
 //MARK: - Setter && Getter
 
 //MARK: - UI
 
 //MARK: - API
 
 //MARK: - IBAction
 
 //MARK: - Override Method
 
 //MARK: - Private Method
 
 //MARK: - Public Method
 
 //MARK: - KVO
 
 //MARK: - NSNotifaction
 
 
 
 */
