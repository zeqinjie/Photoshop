//
//  ZQFilterTool.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/11/8.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit
import GPUImage
import GPUImageBeautifyFilter

class ZQFilterTool: NSObject {
    
    var sourcePicture:GPUImagePicture?
    var brightnessFilter = GPUImageBrightnessFilter() // 亮度
    var exposureFilter = GPUImageExposureFilter() // 曝光
    var contrastFilter = GPUImageContrastFilter() // 对比度
    var saturationFilter = GPUImageSaturationFilter() // 饱和度
    var whiteBalanceFilter =  GPUImageWhiteBalanceFilter() // 色温
    var hightlightShadowFilter =  GPUImageHighlightShadowFilter() // 高光
    var levelsFilter = GPUImageLevelsFilter() // 色阶
    var hueFilter = GPUImageHueFilter() // HUE
    var rgbFilter = GPUImageRGBFilter() // 颜色
    var pipeline: GPUImageFilterPipeline? // 组合滤镜
    
    
    /// 特效
    var sepiaFilter = GPUImageSepiaFilter()
    var grayscaleFilter = GPUImageGrayscaleFilter()
    var sketchFilter = GPUImageSketchFilter()
    var smoothToonFilter = GPUImageSmoothToonFilter()
    var gaussianBlurFilter = GPUImageGaussianBlurFilter()
    var vignetteFilter = GPUImageVignetteFilter()
    var embossFilter = GPUImageEmbossFilter()
    var gammaFilter = GPUImageGammaFilter()
    var bulgeDistortionFilter = GPUImageBulgeDistortionFilter()
    var stretchDistortionFilter = GPUImageStretchDistortionFilter()
    var pinchDistortionFilter = GPUImagePinchDistortionFilter()
    var colorInvertFilter = GPUImageColorInvertFilter()
    var beautifyFilter = GPUImageBeautifyFilter()
    
    var hadAddEfficiencyFilter:GPUImageOutput?
    
    var originImg:UIImage? //初始的img
    // MARK: - LifeCycle
    static let share = ZQFilterTool()
//    override init() {
//    }
    
    

    deinit {
        GPUImageContext.sharedImageProcessing().framebufferCache.purgeAllUnassignedFramebuffers()
    }
    
    // MARK: - Common Method
    func refreshPictureFliter() {
        weak var weakSource = sourcePicture
        DispatchQueue.main.async(execute: {
            weakSource?.processImage()
//            weakSource?.imageFromCurrentFramebuffer(with: .up)
        })
    }
    
    // MARK: - Public Method
    
    /// 初始化
    func setupFilters(image:UIImage,gpuImageView:GPUImageView){
//        setFilterRotaion(brightnessFilter)
//        setFilterRotaion(exposureFilter)
//        setFilterRotaion(contrastFilter)
//        setFilterRotaion(saturationFilter)
//        setFilterRotaion(whiteBalanceFilter)
//        setFilterRotaion(hightlightShadowFilter)
//        setFilterRotaion(rgbFilter)
        let filers = [brightnessFilter,
                      exposureFilter,
                      contrastFilter,
                      saturationFilter,
                      whiteBalanceFilter,
                      hightlightShadowFilter,
                      rgbFilter]
        
        sourcePicture = GPUImagePicture(image: image, smoothlyScaleOutput: true)
        pipeline = GPUImageFilterPipeline(orderedFilters: filers, input: sourcePicture, output: gpuImageView)
        //    [sourcePicture addTarget:pipeline.output]; // 加上这段话 编辑的时候闪烁
        resetFiler()
    }
    
    func resetFiler(){
        brightnessFilter.brightness = 0.0 // 亮度
        exposureFilter.exposure = 0.0 // 曝光
        contrastFilter.contrast = 1.0 // 对比度
        saturationFilter.saturation = 1.0 // 饱和度
        whiteBalanceFilter.temperature = 5000.0 // 色温
        hightlightShadowFilter.highlights = 1.0 // 高光
        hightlightShadowFilter.shadows = 0.0 // 阴影
        rgbFilter.red = 1.0
        rgbFilter.green = 1.0
        rgbFilter.blue = 1.0
        refreshPictureFliter()
    }
    
    
    
    /// 滤镜操作
    func filterPhoto(item:ZQHomeBottomModel) {
        guard let sourcePicture = sourcePicture else {return}
        let value = item.value   ///-100 -> 100
        if item.index == 0 {
            brightnessFilter.brightness = value / 100.0// 亮度
        }else if item.index == 1 {
            exposureFilter.exposure = value / 100.0// 曝光
        }else if item.index == 2 { //颜色
            if let colorStr = item.filterColor {
                let color = UIColor(hexString: colorStr)
                let components = color?.cgColor.components
                if let components = components{
                    rgbFilter.red = components[0]
                    rgbFilter.green = components[1]
                    rgbFilter.blue = components[2]
                    sourcePicture.processImage()
                }else{
                    rgbFilter.red = 0
                    rgbFilter.green = 0
                    rgbFilter.blue = 0
                    sourcePicture.processImage()
                }
                
            }
            
        }else if item.index == 3 { //饱和度  0 1 2
            saturationFilter.saturation = (value + 100)/100
        }else if item.index == 4 { // 高光  0 1
            hightlightShadowFilter.highlights = (value + 100)/200
        }else if item.index == 5 { // 阴影  0 1
            hightlightShadowFilter.shadows = (value + 100)/200
        }else if item.index == 6 { // 色温  0 10000
            whiteBalanceFilter.temperature = (value+100)/2 * 100
        }else if item.index == 8 { // 色温  0 10000
            contrastFilter.contrast = (value + 100)/100
        }
        refreshPictureFliter()
    }
    

    /// 设置亮度
    func setImageBrightnessFilter(image:UIImage,value:CGFloat = 0) -> UIImage {
        let filer = GPUImageBrightnessFilter()
        filer.brightness = value
        return getFilerImage(image: image, filer: filer,size:nil)
    }
    
    
    /// 设置曝光
    func setImageExposureFilter(image:UIImage,value:CGFloat = 0) -> UIImage {
        let filer = GPUImageExposureFilter()
        filer.exposure = value
        return getFilerImage(image: image, filer: filer, size: nil)
    }
    
    
    /// 重置特效
    func resetEfficiency(){
        guard let filter = hadAddEfficiencyFilter else {return}
        pipeline?.removeFilter(filter as? GPUImageOutput & GPUImageInput)
        hadAddEfficiencyFilter = nil
        refreshPictureFliter()
    }
    
    /// 添加特效
    func addEfficiencyFilter(filterType:String){
        resetEfficiency()
        let efficiencyFilter = getEfficiencyFilter(filterType: filterType)
        guard let filter = efficiencyFilter else {return}
        hadAddEfficiencyFilter = filter
        pipeline?.addFilter(filter as? GPUImageOutput & GPUImageInput)
        refreshPictureFliter()
    }
    
    /// 设置旋转bug 待处理
    func setFilterRotaion(_ filter:GPUImageInput){
        filter.setInputRotation(GPUImageRotationMode.init(rawValue: 7), at: 0)
    }
    
    /// 特效处理
    func getEfficiencyFilter(filterType:String)->GPUImageOutput?{
        var filter: GPUImageOutput?
        switch filterType {
        case "original":
            filter = nil
        case "sepia":
            filter = sepiaFilter
        case "grayscale":
            filter = grayscaleFilter
        case "sketch":
            filter = sketchFilter
        case "smoothToon":
            filter = smoothToonFilter
        case "gaussianBlur":
            filter = gaussianBlurFilter
            (filter as? GPUImageGaussianBlurFilter)?.blurRadiusInPixels = 5.0
        case "vignette":
            filter = vignetteFilter
        case "emboss":
            filter = embossFilter
            (filter as? GPUImageEmbossFilter)?.intensity = 1
        case "gamma":
            filter = gammaFilter
            (filter as? GPUImageGammaFilter)?.gamma = 1.5
        case "bulgeDistortion":
            filter = bulgeDistortionFilter
            (filter as? GPUImageBulgeDistortionFilter)?.radius = 0.5
        case "stretchDistortion":
            filter = stretchDistortionFilter
        case "pinchDistortion":
            filter = pinchDistortionFilter
        case "colorInvert":
            filter = colorInvertFilter
        case "beautify":
            filter = beautifyFilter
        default:
            filter = nil
        }
        return filter
    }
    
    func filterImage(_ image: UIImage, filterType: String,successBlock:@escaping ((_ img:UIImage?,_ origin:UIImage?)->())){
        
        let resizeImg = image.resize(maxSize:200)
        let pic = GPUImagePicture(image: resizeImg)
        let filter = getEfficiencyFilter(filterType:filterType)
        if filter == nil {
            successBlock(image,resizeImg)
            return
        }
        filter?.useNextFrameForImageCapture()
        if let filterr = filter{
            pic?.addTarget(filterr as? GPUImageInput)
        }
        DispatchQueue.main.async(execute: {
            pic?.processImage()
            let img = filter?.imageFromCurrentFramebuffer(with: .up)
            successBlock(img,resizeImg)
        })
        
    }
    // MARK: - Class Method
    /// 清空缓存
    class func deleteFilterCache() {
         GPUImageContext.sharedImageProcessing()?.framebufferCache.purgeAllUnassignedFramebuffers()
    }
    
    // MARK: - Private Method
    fileprivate func getFilerImage(image:UIImage,filer:GPUImageFilter,size:CGSize?) -> UIImage {
        let pic = GPUImagePicture(image: image, smoothlyScaleOutput: true)
        if let size = size {
            filer.forceProcessing(at: size)
        }
        pic?.addTarget(filer)
        pic?.processImage()
        filer.useNextFrameForImageCapture()
        let img = filer.imageFromCurrentFramebuffer()
        return img ?? image
    }
    
    
    
}
