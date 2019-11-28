//
//  ZQDrawBoardViewController.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/17.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class ZQDrawBoardViewController: ZQBasePhotoPickerViewController {

    @IBOutlet weak var funcBtn: UIButton!
    @IBOutlet weak var sliderView: ZQHomeSliderView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomTopView: UIView!
    //undo
    @IBOutlet weak var revorkBtn: UIButton!
    @IBOutlet weak var forwarkBtn: UIButton!
    @IBOutlet weak var colorBtn: UIButton!
    @IBOutlet weak var sizeBtn: UIButton!
    @IBOutlet weak var alphaBtn: UIButton!
    
    
    fileprivate lazy var colorPickerTool = ZQColorPickerTool.share
    fileprivate let drawboardModel = ZQDrawBoardModel()
    fileprivate lazy var drawBoardView:ZQDrawingView = {
        var v = self.getDrawBoardView()
        return v
    }()
    fileprivate lazy var menuViewProperty:FWMenuViewProperty = {
        var property = FWMenuViewProperty()
        property.popupCustomAlignment = .bottomLeft
        property.popupAnimationType = .scale3D
        property.popupArrowStyle = .triangle
        property.touchWildToHide = "1"
        property.topBottomMargin = 0
        property.maskViewColor = UIColor(white: 0, alpha: 0.3)
        property.backgroundColor = ZQColor_432572
        let frame = funcBtn.convert(funcBtn.frame, to: self.view)
        property.popupViewEdgeInsets = UIEdgeInsetsMake(0, 10, ZQScreenHeight - frame.minY, 0)
        property.animationDuration = 0.2
        property.cornerRadius = 0
        property.popupArrowVertexScaleX = 0.2
        return property
    }()
    
    fileprivate lazy var colorItemView: ZQHomeColorItemView = {
        let colorItemView = ZQHomeColorItemView.init(frame: CGRect.zero)
        colorItemView.block = {
            [weak self](colorItem,indexPath) in
            self?.colorPicker(colorItem,indexPath)
        }
        return colorItemView
    }()
    fileprivate var menuView:FWMenuView?
    
    fileprivate var titles : [String]?
    fileprivate var photos : [UIImage]?
    fileprivate var dataSource:[ZQDrawModel]?
    fileprivate var viewModel = ZQDrawBoardViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
    }
    
    // MARK: - Override
    override func defaultSet() {
        super.defaultSet()
    }
    
    override func getPhotoViewType() -> ZQPhotoViewType {
        return .drawPhoto
    }
    
    override func getPhotoPickerType()->PhotoPickerVCType {
        return .draw
    }
    
    override func layoutFrame() {
        super.layoutFrame()
        contentView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(ZQStatusAndNavigationHeigth)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top)
        }
    }
    
    override func photoPickerChoice(img: UIImage?) {
        super.photoPickerChoice(img: img)
        resetAll()
    }
    
    override func resetAll() {
        drawBoardView.clearScreen()
        updateButtonStatus()
    }
    // MARK: - UI
    override func creatUI() {
        super.creatUI()
        bottomTopView.addSubview(colorItemView)
        colorItemView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        colorItemView.type = .circle

        drawBoardView.delegate = self
        
        sliderView.actionBlock = {
            [weak self] (slider,newValue,finished) in
            self?.sliderValueChange(newValue: newValue, finished: finished)
        }
    }
    
    // MARK: - Pirvate Method
    fileprivate func sliderValueChange(newValue:CGFloat,finished:Bool) {
        if sliderView.sliderType == .alpha {
            drawboardModel.alpha = newValue
            drawBoardView.lineAlpha = newValue
        }else{
            drawboardModel.size = newValue
            drawBoardView.lineWidth = newValue
        }
    }
    
    fileprivate func loadData() {
        viewModel.loadData { [weak self] (dic) in
            guard let dic = dic as? [String:Any] else {return}
            if let titleArr = dic["titles"] as? [String] {
                self?.titles = titleArr
            }
            if let photoArr = dic["photos"] as? [UIImage] {
                self?.photos = photoArr
            }
            if let dataSourceArr = dic["dataSource"] as? [ZQDrawModel] {
                self?.dataSource = dataSourceArr
            }
        }
    }
    
    /// 更新按钮
    fileprivate func updateButtonStatus() {
        self.forwarkBtn.isEnabled = drawBoardView.canredo();
        self.revorkBtn.isEnabled = drawBoardView.canundo();
    }
    
    fileprivate func updateValueButtonStatus(tag:Int){
        var iscolor = true
        var issize = false
        var isalpha = false
        if tag == 4 {
            showColorPicker(isShowColor: true)
        }else if tag == 5{
            showColorPicker(isShowColor: false)
            issize = true
            iscolor = false
        }else {
            showColorPicker(isShowColor: false)
            isalpha = true
            iscolor = false
        }
        colorBtn.isSelected = iscolor
        sizeBtn.isSelected = issize
        alphaBtn.isSelected = isalpha
    }
    
    fileprivate func colorPicker(_ item:ZQHomeColorModel,_ indexPath:IndexPath){
        if item.title == ZQHomeColorModel.MORE {
            colorPickerTool.presentColorPicker(delegate: self) { [weak self](btn,color) in
                if btn.tag == 11 {
                    self?.choiceColorValue(colorValue: color)
                }
            }
            return
        }else{
            self.choiceColorValue(colorValue: item.color)
        }
    }
    
    fileprivate func choiceColorValue(colorValue:String){
        self.drawBoardView.lineColor = UIColor(hexString: colorValue) ?? UIColor.white
    }
    
    // MARK: - Public Method
    
    // MARK: - Action
    @IBAction func btnAction(_ sender: UIButton) {
        if checkSeletedImg() {
            switch sender.tag {
            case 1:
                penChooseAction(sender)
            case 2:
                revokeAction(sender)
            case 3:
                forwardAction(sender)
            case 4:
                colorAction(sender)
            case 5:
                sizeAction(sender)
            case 6:
                alphaAction(sender)
            default:
                penChooseAction(sender)
            }
        }
    }
    
}

// MARK: - DrawBoard Action
extension ZQDrawBoardViewController {
    //选择画笔
    fileprivate func penChooseAction(_ btn: UIButton) {
        if menuView == nil {
            guard let titles = titles,let photos = photos else {
                return
            }
            menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: photos, itemBlock: { [weak self](popupView, index, title) in
                DLog("\(index)")
                self?.dealFunBtnSelected(index: index)
            }, property: menuViewProperty)
        }
        menuView?.show()
    }
    //撤销
    fileprivate func revokeAction(_ btn: UIButton) {
        drawBoardView.undoLastObject()
        updateButtonStatus()
    }
    
    //向前
    fileprivate func forwardAction(_ btn: UIButton) {
        drawBoardView.redoLastObject()
        updateButtonStatus()
    }
    
    //颜色
    fileprivate func colorAction(_ btn: UIButton) {
        updateValueButtonStatus(tag: btn.tag)
    }
    
    //文字大小
    fileprivate func sizeAction(_ btn: UIButton) {
        updateValueButtonStatus(tag: btn.tag)
        sliderView.minValue = 2
        sliderView.maxValue = 50
        sliderView.value = drawboardModel.size
    }
    
    //透明度
    fileprivate func alphaAction(_ btn: UIButton) {
        updateValueButtonStatus(tag: btn.tag)
        sliderView.minValue = 0
        sliderView.maxValue = 1
        sliderView.value = drawboardModel.alpha
    }
    
    
    // MARK: - Common
    fileprivate func showColorPicker(isShowColor:Bool){
        colorItemView.isHidden = !isShowColor
        sliderView.isHidden = isShowColor
    }
    
    fileprivate func dealFunBtnSelected(index:Int) {
        let img = photos?[index]
        funcBtn.setImage(img, for: .normal)
        guard let type = dataSource?[index].type else {
            return
        }
        switch type {
        case "pen":
            self.drawBoardView.drawToolType = .pen
        case "line":
            self.drawBoardView.drawToolType = .line
        case "rect":
            self.drawBoardView.drawToolType = .rectangle
        case "rect_fill":
            self.drawBoardView.drawToolType = .rectangleFill
        case "circle":
            self.drawBoardView.drawToolType = .oval
        case "circle_fill":
            self.drawBoardView.drawToolType = .ovalFill
        case "arrow":
            self.drawBoardView.drawToolType = .arrow
        case "text":
            self.drawBoardView.drawToolType = .text
        case "att_text":
            self.drawBoardView.drawToolType = .multiText
        case "rubber":
            self.drawBoardView.drawToolType = .eraser
        default:
            self.drawBoardView.drawToolType = .pen
        }
        
    }
}


extension ZQDrawBoardViewController:ZQDrawingViewDelegate{
    func zqDrawingViewDidFinishedDraw(_ drawingView: ZQDrawingView){
        updateButtonStatus()
    }
}
