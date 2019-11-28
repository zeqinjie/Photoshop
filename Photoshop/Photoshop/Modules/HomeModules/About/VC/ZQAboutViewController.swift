//
//  AboutViewController.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/12/22.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit
import MessageUI
class ZQAboutViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - override
    override func defaultSet() {
        super.defaultSet()
        self.title = "关于"
    }

    override func creatUI() {
        super.creatUI()
        creatBackBarBtn()
    }
    
    // MARK: - Action
    func praiseAction() {
        ZQTool.openURLStr("https://itunes.apple.com/us/app/itunes-u/id1448200154?action=write-review&mt=8")
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let dvc = MFMailComposeViewController()
            dvc.mailComposeDelegate = self
            //设置邮件地址、主题及正文
            dvc.setToRecipients(["zhengzeqin007@gmail.com"])
            dvc.setSubject("问题反馈")
            dvc.setMessageBody("", isHTML: false)
            presentVC(dvc)
        }else{
            hideHudHint("您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送")
        }
    }
    
    // MARK: - UITableDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DLog("didSelectRowAt")
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            praiseAction()
        }else if indexPath.row == 1 {
            sendMail()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
}


extension ZQAboutViewController:MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismissVC(completion: nil)
        if error == nil {
            switch result {
            case .sent:
                hideHudHint("发送成功")
            case .cancelled:
                hideHudHint("已取消")
            case .failed:
                hideHudHint("发送失败")
            case .saved:
                hideHudHint("已保存")
            default:
                hideHudHint("发送成功")
            }
        }
    }
}

