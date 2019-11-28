//
//  BaseNavigationViewController.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
class BaseNavigationViewController: UINavigationController,UINavigationControllerDelegate {
    var popDelegate: UIGestureRecognizerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedStringKey.font: ZQSYSFontSize(17), NSAttributedStringKey.foregroundColor: ZQColor_ffffff]
        navigationBar.titleTextAttributes = textAttributes
        // Do any additional setup after loading the view.
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        self.delegate = self
        
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    

    //UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers.first {
            self.interactivePopGestureRecognizer!.delegate = self.popDelegate
        }else {
            self.interactivePopGestureRecognizer!.delegate = nil
        }
    }
}
