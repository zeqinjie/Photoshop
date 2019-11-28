//
//  ZQHomeColorItemView.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/11/3.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

enum ZQHomeColorItemViewType {
    case rect
    case circle
}

class ZQHomeColorItemView: BaseView {

    var dataSource = [ZQHomeColorModel]()
    var block:((_ item:ZQHomeColorModel,_ indexPath:IndexPath)->())?
    
    lazy var itemCollectionView:UICollectionView = {
        let collectionView = self.common_collectionViewFrame(CGRect.zero, minLineSpacing: 5, interitemSpacing: 5, scrollDirection: .horizontal)
        collectionView?.backgroundColor = ZQColor_clear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ZQHomeColorItemColCell.self, forCellWithReuseIdentifier: "ZQHomeColorItemColCell")
        return collectionView!
    }()
    var type:ZQHomeColorItemViewType = .rect
    
    // MARK: - Override
    override func defaultSet() {
        super.defaultSet()
        loadData()
    }
    
    override func creatUI() {
        super.creatUI()
        addSubview(itemCollectionView)
        itemCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 加载底部视图数据
    func loadData() {
        let dic = ZQTool.getJsonDic(forResource: "home_bottom_color_data", ofType: "json")
        guard let data = dic?["data"] as? [String:Any] else {return}
        guard let arr = data["items"] as? [[String:Any]] else {
            return
        }
        let dataSource = [ZQHomeColorModel].deserialize(from: arr)
        guard let dataSourcearr = dataSource as? [ZQHomeColorModel] else {return}
        self.dataSource += dataSourcearr
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
extension ZQHomeColorItemView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.opacityAnimation()
        let item = dataSource[indexPath.row]
        block?(item, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        
    }
    
    //UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:ZQHomeColorItemColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZQHomeColorItemColCell", for: indexPath) as! ZQHomeColorItemColCell
        let item = dataSource[indexPath.row]
        cell.type = self.type
        cell.model = item
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var size = CGSize(width: 35, height: 45)
        if type == .circle {
            size = CGSize(width: 45, height: 45)
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
}
