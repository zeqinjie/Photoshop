//
//  ZQPrivateViewController.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/12/22.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

class ZQPrivateViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - override
    override func defaultSet() {
        super.defaultSet()
        self.title = "隐私条款"
    }
    
    override func creatUI() {
        super.creatUI()
        creatBackBarBtn()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
