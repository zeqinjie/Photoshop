//
//  ZQPhotoPickTool.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/10/17.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import CropViewController
import AssetsLibrary
class ZQPhotoTool: NSObject,CropViewControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    fileprivate var croppingStyle = CropViewCroppingStyle.default
    fileprivate var singleImagePicker: UIImagePickerController!
    fileprivate weak var delegate:UIViewController?
    fileprivate var image: UIImage?
    fileprivate var photoView:ZQPhotoView?
    
    fileprivate var padding:CGFloat = 3
    
    var photoPickerToolBlock:((_ img:UIImage?)->())?
    // MARK: - Private Method
    fileprivate func layoutImageView() {
        guard let photoView = self.photoView else {return}
        guard let image = self.image else {return}
        var viewFrame = photoView.frame
        viewFrame.size.width -= padding
        viewFrame.size.height -= padding
        
        var imageFrame = CGRect.zero
        imageFrame.size = image.size;
        let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
        imageFrame.size.width *= scale
        imageFrame.size.height *= scale
        imageFrame.origin.x = (photoView.frame.size.width - imageFrame.size.width) * 0.5
        imageFrame.origin.y = (photoView.frame.size.height - imageFrame.size.height) * 0.5
        photoView.setContentFrame(frame:imageFrame)
    }
    
    fileprivate func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        updateChoiceImage(image: image)
        if cropViewController.croppingStyle != .circular {
            self.photoView?.setContentHide(isHide:true)
            cropViewController.dismissAnimatedFrom(self.delegate!, withCroppedImage: image,
                                                   toView: self.photoView?.imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: {
                                                    self.photoView?.setContentHide(isHide:false)
            })
        }
    }
    
    fileprivate func showPickerPhoto(sourceType: UIImagePickerControllerSourceType) {
        var isAuthorize:Bool = true
        var cameraStr = "相机"
        if sourceType == .camera {//相机
            isAuthorize = ZQTool.isAuthorizeCamera()
        }else if sourceType == .photoLibrary {//相册
            isAuthorize = ZQTool.isAuthorizePhoto()
            cameraStr = "相册"
        }
        if isAuthorize {
            self.croppingStyle = .default
            if singleImagePicker == nil {
                singleImagePicker = UIImagePickerController()
                singleImagePicker.allowsEditing = false
                singleImagePicker.delegate = self
            }
            singleImagePicker.sourceType = sourceType
//            singleImagePicker.isHideNavigationBar = false
            self.delegate?.present(singleImagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "未获得权限访问您的"+cameraStr, message: "请在设置选项中允许此滤镜九宫格获取权限,来编辑您的照片？", preferredStyle: .alert)
            let ensureMode = UIAlertAction(title: "确定",
                                           style: .default,
                                           handler:  { _ in
                                            ZQTool.openSetUrl()
            })
            let cancelMode = UIAlertAction(title: "取消",
                                           style: .cancel,
                                           handler: nil)
            alert.addAction(ensureMode)
            alert.addAction(cancelMode)
            delegate?.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    // MARK: - Public Method
    
    /// 设置图片
    func updateChoiceImage(image: UIImage){
        self.image = image
        self.photoView?.img = image
        layoutImageView()
    }
    
    /// 显示pickerPhoto
    func showPickerPhoto(photoView:ZQPhotoView?,delegate:UIViewController?,padding:CGFloat = 5){
        self.padding = padding
        self.delegate = delegate
        self.photoView = photoView
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraMode = UIAlertAction(title: "拍照",
                                       style: .default) { _ in
                                        self.showPickerPhoto(sourceType: .camera)
        }
        let libraryMode = UIAlertAction(title: "相册",
                                        style: .default) { _ in
                                        self.showPickerPhoto(sourceType: .photoLibrary)

        }
        let cancelMode = UIAlertAction(title: "取消",
                                       style: .cancel,
                                       handler: nil)
        
        alert.addAction(cameraMode)
        alert.addAction(libraryMode)
        alert.addAction(cancelMode)
        delegate?.present(alert, animated: true, completion: nil)
    }
    
}

extension ZQPhotoTool {
    /// 选择图片
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        self.image = image
        if croppingStyle != .circular {
            picker.dismiss(animated: true, completion: {
                self.delegate?.present(cropController, animated: true, completion: nil)
            })
        }
    }
    
    /// 编辑图片
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        if let img = image.fixOrientation() { //fixOrientation
            self.photoPickerToolBlock?(img)
            updateImageViewWithImage(img, fromCropViewController: cropViewController)
        }
    }

    
}
