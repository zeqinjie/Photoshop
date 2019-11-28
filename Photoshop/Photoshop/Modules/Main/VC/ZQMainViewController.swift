//
//  ZQMainViewController.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/12/9.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit
import CircleMenu
class ZQMainViewController: BaseViewController {

    
    @IBOutlet weak var iconImgView: UIImageView!
    fileprivate var sectionGap:CGFloat = (ZQScreenWidth - 200) / 3
    fileprivate let mainItemSize:CGFloat = 100
    fileprivate let distance:Float = 120
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = self.common_collectionViewFrame(CGRect.zero, minLineSpacing: 10, interitemSpacing: 10, scrollDirection: .horizontal)
        collectionView!.backgroundColor = ZQColor_clear
        collectionView!.register(ZQMainColCell.self, forCellWithReuseIdentifier: "ZQMainColCell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        return collectionView!
    }()
    
    fileprivate lazy var circleMenu:CircleMenu = {
        let button = CircleMenu(
            frame: CGRect(x: 0, y: 0, width: 60, height: 60),
            normalIcon:"icon_menu",
            selectedIcon:"icon_close",
            buttonsCount: 4,
            duration: 1,
            distance: distance)
        button.backgroundColor = ZQColor_ffffff
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        return button
    }()
    
    var dataSource:[ZQMainModel]?
    fileprivate let viewModel = ZQMainViewModel()
    
//    var items: [(icon: String, color: UIColor)]?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Override
    override func defaultSet() {
        super.defaultSet()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func creatUI() {
        super.creatUI()
//        creatCollectionView()
        creatCircleView()
    }
    
    // MARK: - Private Method
    
    func creatCollectionView(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    func creatCircleView() {
        view.addSubview(circleMenu)
        circleMenu.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView.snp.bottom).offset(self.distance + 10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    func loadData() {
        viewModel.loadData { [weak self] (dataSource) in
            guard let dataSource = dataSource as? [ZQMainModel] else {return}
            self?.dataSource = dataSource
//            self?.collectionView.reloadData()
            
        }
    }
    
    
    func jumpAction(_ model:ZQMainModel) {
        performSegue(withIdentifier: model.segue, sender: nil)
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let controller = segue.destination
        if controller.isKindClass(of: ZQBasePhotoPickerViewController.self) {
            self.transitionEnable(isEnabled: true)
            self.navigationController?.hero.navigationAnimationType = .zoom
        }else{
            self.transitionEnable(isEnabled: false)
        }
    }
 

}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
extension ZQMainViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    //UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        DLog("didSelectItemAt index = \(indexPath.row)")
        let model = dataSource?[indexPath.row]
        guard let m = model else {return}
        jumpAction(m)
    }
    
    //UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSource?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:ZQMainColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZQMainColCell", for: indexPath) as! ZQMainColCell
        let model = dataSource?[indexPath.row]
        cell.model = model
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ZQMainViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //(ZQScreenWidth - 200) / 3
        let size = CGSize(width: mainItemSize - 1, height: mainItemSize)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, sectionGap, 0, sectionGap)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return sectionGap
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    
}

extension ZQMainViewController:CircleMenuDelegate {
    
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        guard let dataSource = dataSource else {return}
        button.backgroundColor = UIColor(hexString: dataSource[atIndex].color)
        button.setImage(UIImage(named: dataSource[atIndex].photo), for: .normal)
        // set highlited image
        let highlightedImage = UIImage(named: dataSource[atIndex].selPhoto)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_: CircleMenu, buttonWillSelected _: UIButton, atIndex: Int) {
        DLog("button will selected: \(atIndex)")
    }
    
    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        DLog("button did selected: \(atIndex)")
        let model = dataSource?[atIndex]
        guard let m = model else {return}
        jumpAction(m)
    }
}
