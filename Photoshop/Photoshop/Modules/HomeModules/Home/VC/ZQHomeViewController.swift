//
//  HomeViewController.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import CropViewController
class ZQHomeViewController: ZQBasePhotoPickerViewController {

    @IBOutlet weak var picEditView: ZQHomePicEditView!
    lazy var colorPickerTool = ZQColorPickerTool.share
    
    lazy var viewModel:ZQHomeViewModel = {
        let vm = ZQHomeViewModel()
        vm.photoView = photoView
        return vm
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBottomData()
    }
    
    // MARK: - UI
    override func creatUI() {
        super.creatUI()
        picEditView.delegate = self
    }
    
    // MARK: - Override
    override func getPhotoViewType() -> ZQPhotoViewType {
        return .editPhoto
    }
    
    override func getPhotoPickerType()->PhotoPickerVCType {
        return .edit
    }
    
    override func layoutFrame() {
        super.layoutFrame()
        contentView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(ZQStatusAndNavigationHeigth)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.picEditView.snp.top)
        }
    }
    
    override func photoPickerChoice(img: UIImage?) {
        super.photoPickerChoice(img: img)
        self.picEditView.img = img
        self.picEditView.resetAllFilterStyle()
        guard let image = img else {return}
        self.picEditView.updateEfficiency(img: image)
    }
    
    override func resetAll() {
        picEditView.resetAllFilterStyle()
        viewModel.resetAll()
    }
    
    // MARK: - Private Method
    /// 颜色选择
    fileprivate func colorChoice(_ colorItem:ZQHomeColorModel,_ didSeletedItem: ZQHomeBottomModel?,_ sectionIndex:Int){
        if didSeletedItem != nil && sectionIndex == 2 {
            viewModel.dealImageFilter(item:didSeletedItem!)
            picEditView.updateItemSeletedCell()
        }else if (sectionIndex == 1){
            viewModel.dealCutImageColorIndexPath(item: colorItem)
        }
    }
    
    // MARK: - Data
    fileprivate func loadBottomData(){
        viewModel.loadBottomData(successBlock:{
            [unowned self] (json) in
            guard let dataSource = json as? [ZQHomeBottomModel] else {return}
            self.picEditView.loadData(dataSource: dataSource)
        });
    }

}


extension ZQHomeViewController:ZQHomePicEditViewProtocol{
    /// 滤镜值选择
    func filterStyleValueSelect(_ item:ZQHomeBottomModel){
        viewModel.dealImageFilter(item:item)
    }

    /// 颜色选择
    func colorSelect(_ colorItem:ZQHomeColorModel,_ didSeletedItem: ZQHomeBottomModel?,_ sectionIndex:Int){
        if colorItem.title == ZQHomeColorModel.MORE {
            colorPickerTool.presentColorPicker(delegate: self) { [weak self](btn,color) in
                if btn.tag == 11 {
                    colorItem.color = color
                    didSeletedItem?.filterColor = color
                    self?.colorChoice(colorItem, didSeletedItem, sectionIndex)
                }
            }
            return
        }
        self.colorChoice(colorItem, didSeletedItem, sectionIndex)
    }
   
    /// item项选择
    func bottomItemSelect(_ item:ZQHomeBottomModel,_ indexPath:IndexPath){
        viewModel.dealImageIndexPath(item:item)
    }
    
    /// 重置所有滤镜效果
    func resetAllFliter(){
        viewModel.resetFilter()
    }
    
}
