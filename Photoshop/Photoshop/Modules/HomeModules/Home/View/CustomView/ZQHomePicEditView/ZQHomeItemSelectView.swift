//
//  ZQHomeItemSelectView.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/11/15.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit
protocol ZQHomeItemSelectViewProtocol:NSObjectProtocol{
    /// 滤镜值选择
    func didSeletedItemCell(_ itemCell:ZQHomeItemColCell?,indexPath:IndexPath)
}
class ZQHomeItemSelectView: BaseView {

    weak var delegate:ZQHomeItemSelectViewProtocol?
    fileprivate var sectionIndex:Int = 0
    fileprivate var dataSource:[ZQHomeBottomModel]?
    fileprivate var didSelectedItemDic = [Int:ZQHomeBottomModel]()
    fileprivate var collectionViews = [UICollectionView]()
    

    // MARK: - Override
    override func defaultSet() {
        super.defaultSet()
        
    }
    
    
    // MARK: - Private Method
    /// 显示下标
    func showCollectionSection(_ section:Int) {
        for (i,collectionView) in collectionViews.enumerated() {
            collectionView.isHidden = i == section ? false :true
        }
    }

    // MARK: - Public Method
    /// 加载数据
    func loadData(dataSource:[ZQHomeBottomModel]?){
        guard let data = dataSource else {return}
        self.dataSource = data
        common_removeAllSubview(view: self)
        collectionViews.removeAll()
        for (i,_) in data.enumerated() {
            let collectionView = self.common_collectionViewFrame(CGRect.zero, minLineSpacing: 10, interitemSpacing: 10, scrollDirection: .horizontal)
            if let collectionView = collectionView {
                collectionView.backgroundColor = ZQColor_clear
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.tag = i
                collectionView.register(ZQHomeItemColCell.self, forCellWithReuseIdentifier: "ZQHomeItemColCell")
                addSubview(collectionView)
                collectionView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                collectionViews.append(collectionView)
                collectionView.isHidden = i == 0 ? false :true
            }
        }
    }
    
    /// 刷新数据
    func reloadData(section:Int) {
        self.sectionIndex = section
        if collectionViews.count > section {
            let collectionView = collectionViews[section]
            collectionView.reloadData()
        }
    }
    
    /// 更新当前的点击的Cell
    func updateDidSeletedCell(section:Int){
        // 刷新cell
        let selectedItem = didSelectedItemDic[section]
        guard let didSelectedItem = selectedItem else {return}
        guard let indexPath = didSelectedItem.indexPath else {return}
        let collectionView = collectionViews[section]
        let cell = collectionView.cellForItem(at: indexPath) as? ZQHomeItemColCell
        cell?.model = didSelectedItem
    }
    
    /// 返回最后点击的item
    func getSectionSelectItem(section:Int)->ZQHomeBottomModel?{
        return didSelectedItemDic[section]
    }
    
    /// 更新特效图片
    func updateEfficiency(img:UIImage){
//        if let model = dataSource?.last {
//            for item in model.items {
//                item.modifyEfficiency(image: img)
//            }
//        }
//        self.collectionViews.last?.reloadData()
//        ZQFilterTool.deleteFilterCache()
    }
}


// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
extension ZQHomeItemSelectView : UICollectionViewDelegate,UICollectionViewDataSource {
    
    //UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if dataSource?.isEmpty == false {
            let model = dataSource?[collectionView.tag]
            return model?.items.count ?? 0
        }else{
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell:ZQHomeItemColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZQHomeItemColCell", for: indexPath) as! ZQHomeItemColCell
        let section = dataSource?[collectionView.tag]
        let item = section?.items[indexPath.row]
        if let item = item {
            item.section = collectionView.tag
            item.indexPath = indexPath
            item.cell = cell
            cell.model = item
            if item.isSel {
                didSelectedItemDic[collectionView.tag] = item
            }
            
        }
        return cell
    }
    
    //UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as? ZQHomeItemColCell
        guard let model = cell?.model else {
            return
        }
        didSelectedItemDic[collectionView.tag] = model
        delegate?.didSeletedItemCell(cell, indexPath: indexPath)
        
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ZQHomeItemSelectView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: 60, height: 75)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(5, 10, 5, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    
}
