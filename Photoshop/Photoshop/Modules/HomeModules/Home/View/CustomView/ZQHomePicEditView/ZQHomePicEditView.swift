//
//  ZQHomeBottomView.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/10/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

protocol ZQHomePicEditViewProtocol:NSObjectProtocol{
    /// 滤镜值选择
    func filterStyleValueSelect(_ item:ZQHomeBottomModel)
    /// 颜色选择
    func colorSelect(_ colorItem:ZQHomeColorModel,_ didSeletedItem: ZQHomeBottomModel?,_ sectionIndex:Int)
    /// item项选择
    func bottomItemSelect(_ item:ZQHomeBottomModel,_ indexPath:IndexPath)
    /// 重置滤镜效果
    func resetAllFliter()
}

class ZQHomePicEditView: BaseView {
    
    fileprivate var sectionIndex = 0
    weak var delegate:ZQHomePicEditViewProtocol?
    var img:UIImage?
    fileprivate var dataSource:[ZQHomeBottomModel]?
    fileprivate var sectionGap:CGFloat = 0
    ///多少组
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    ///多少项
    @IBOutlet weak var bottomCenterView: UIView!
    
    @IBOutlet weak var sliderView: ZQHomeSliderView!
    fileprivate lazy var itemSelectView:ZQHomeItemSelectView = {
        let v = ZQHomeItemSelectView()
        return v
    }()
    
    
    fileprivate lazy var colorItemView: ZQHomeColorItemView = {
        let colorItemView = ZQHomeColorItemView.init(frame: CGRect.zero)
        colorItemView.block = {
            [weak self](colorItem,indexPath) in
            if self?.img == nil {
                SwiftNotice.showText("请选择图片")
                return
            }
            let seletedItem = self?.itemSelectView.getSectionSelectItem(section:self?.sectionIndex ?? 0)
            seletedItem?.filterColor = colorItem.color
            self?.delegate?.colorSelect(colorItem, seletedItem, self?.sectionIndex ?? 0)
        }
        return colorItemView
    }()
    
    // MARK: - Override
    override func defaultSet() {
        super.defaultSet()
        sliderView.actionBlock = {
            [weak self] (slider,newValue,finished) in
            self?.dealFliterValueChange(newValue: newValue)
        }
    }
    
    override func creatUI() {
        super.creatUI()
        addSubview(colorItemView)
        colorItemView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(45)
        }
        
        bottomCenterView.addSubview(itemSelectView)
        itemSelectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        itemSelectView.delegate = self
    }
    
    // MARK: - Public Method
    ///更新数据
    func loadData(dataSource:[ZQHomeBottomModel]?) {
        guard let dataSourceArr = dataSource else {return}
        self.dataSource = dataSourceArr
        self.sectionGap = (ZQScreenWidth - CGFloat(50 * dataSourceArr.count))/CGFloat(dataSourceArr.count+1)
        self.sectionCollectionView.reloadData()
        self.itemSelectView.loadData(dataSource: dataSource)
    }
    
    
    /// 清空所以滤镜
    func resetAllFilterStyle(){
        delegate?.resetAllFliter()
        sliderView.value = 0
        guard let section = dataSource?[2] else {return}
        for item in section.items {
            item.value = 0
            item.filterColor = ""
        }
        if self.sectionIndex == 2 {
            reloadItemSelectViewData()
        }
    }
    
    /// 更新选中item cell
    func updateItemSeletedCell(){
        itemSelectView.updateDidSeletedCell(section: self.sectionIndex)
    }
    
    /// 更新特效图片
    func updateEfficiency(img:UIImage){
        itemSelectView.updateEfficiency(img:img)
    }
    
    // MARK: - Private Method
    /// 刷新当前item数据
    fileprivate func reloadItemSelectViewData(){
        itemSelectView.reloadData(section: self.sectionIndex)
    }
    
    
    /// 刷新选中section
    fileprivate func didSelectSectionIndex(_ section:Int){
        if section != sectionIndex {
            sectionIndex = section
            sectionCollectionView.reloadData()
            reloadItemSelectViewData()
            if section == 0 {
                setSliderIsHide(true, colorItemIsHide: true)
            }else if section == 1 {
                setSliderIsHide(true, colorItemIsHide: false)
            }else if section == 2 {
                let seletedItem = itemSelectView.getSectionSelectItem(section:section)
                if seletedItem == nil || seletedItem?.index == 2{ // 颜色
                    setSliderIsHide(true, colorItemIsHide: false)
                }else{
                    setSliderIsHide(false, colorItemIsHide: true)
                }
            }else if section == 3 {
                setSliderIsHide(true, colorItemIsHide: true)
            }
            itemSelectView.showCollectionSection(section)
        }
    }
    
    fileprivate func didSelectItemAt(cell:ZQHomeItemColCell?,indexPath: IndexPath){
        guard let cell = cell else {return}
        guard let item = cell.model else {return}
        
        cell.opacityAnimation()
        if item.section == 2 {
            if item.index == 7 {
                // 清空所有
                resetAllFilterStyle()
            }else{
                if item.index == 2{// 颜色则
                    setSliderIsHide(true,colorItemIsHide: false)
                }else{
                    setSliderIsHide(false,colorItemIsHide: true)
                }
                ZQPostNoticeCenter(ZQFilterUnSelectNotification, obj: nil)
                sliderView.value = item.value
                item.isSel = true
                cell.setStyleColor()
            }
        }else{
            delegate?.bottomItemSelect(item, IndexPath(item: indexPath.row, section: sectionIndex))
        }
    }
    
    /// 处理滤镜值
    fileprivate func dealFliterValueChange(newValue:CGFloat) {
        DLog("silder newValue = \(newValue)")
        guard let seletedItem = itemSelectView.getSectionSelectItem(section:sectionIndex) else {return}
        if seletedItem.section == 2{
            seletedItem.value = newValue.noDecimal()
            delegate?.filterStyleValueSelect(seletedItem)
            itemSelectView.updateDidSeletedCell(section: seletedItem.section)
        }
    }

    /// 设置滑块是否隐藏
    fileprivate func setSliderIsHide(_ isHide:Bool, colorItemIsHide:Bool){
        sliderView.isHidden = isHide
        colorItemView.isHidden = colorItemIsHide
    }
}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
extension ZQHomePicEditView : UICollectionViewDelegate,UICollectionViewDataSource {
    //UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        DLog("didSelectItemAt index = \(indexPath.row)")
        if collectionView == self.sectionCollectionView{
            didSelectSectionIndex(indexPath.row)
        }
    }
    
    //UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSource?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell:ZQHomeBottomSectionColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZQHomeBottomSectionColCell", for: indexPath) as! ZQHomeBottomSectionColCell
        let section = dataSource?[indexPath.row]
        section?.isSel = sectionIndex == indexPath.row ? true : false
        section?.indexPath = indexPath
        cell.model = section
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ZQHomePicEditView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: 50, height: 45)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, self.sectionGap, 0, self.sectionGap)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return self.sectionGap
    }
    
    
}

extension ZQHomePicEditView:ZQHomeItemSelectViewProtocol {
    func didSeletedItemCell(_ itemCell:ZQHomeItemColCell?,indexPath:IndexPath){
        if img == nil {
            SwiftNotice.showText("请选择图片")
            return
        }
        didSelectItemAt(cell: itemCell, indexPath: indexPath)
    }
}
