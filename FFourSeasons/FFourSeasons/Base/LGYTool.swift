//
//  LGYTool.swift
//  Created by LGY  on 2018/1/9.
//  Copyright © 2018年. All rights reserved.
//

import UIKit

class LGYTool: NSObject {

    //MARK:获取UUID,保存唯一
   class func uuidGet() -> String{
        let userid = UserDefaults.standard.string(forKey: "hua否已经存e@qq.com")
        //判断UserDefaults中是否已经存在
        if(userid != nil){
            return userid!
        }else{
            //不存在则生成一个新的并保存
            let uuid_ref = CFUUIDCreate(nil)
            let uuid_string_ref = CFUUIDCreateString(nil , uuid_ref)
            let uuid = uuid_string_ref! as String
            UserDefaults.standard.set(uuid, forKey: "hua否已经存e@qq.com")
            return uuid
        }
    }
    
    //MARK:获取文字的大小
    class func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size
    }
    
    //MARK:设置角标
    class func cornerAdd(view:UIView?,text:String,backgroundColor:UIColor,textColor:UIColor,font:UIFont,maxSize : CGSize,maginLeft:CGFloat,maginTop:CGFloat){
        if view == nil {
            return
        }
        let size = textSize(text: text, font: font, maxSize: maxSize)
        let x = (view?.frame.width)! - size.width/2 + maginLeft
        let y = -size.height/2 + maginTop
        var label = view?.viewWithTag(100) as? UILabel
        if label == nil {
            var wid = size.width+10
            if ((size.height+10)>(size.width+10)){
                wid = size.height+10
            }
            label = UILabel.init(frame: CGRect(x: x, y: y, width: wid, height: size.height+10))
            label?.tag = 100
            view?.addSubview(label!)
        }
        label?.font = font
        label?.text = text;
        label?.textAlignment = .center
        label?.backgroundColor = backgroundColor
        label?.textColor = textColor
        label?.layer.cornerRadius = (label?.frame.height)!/2
        label?.layer.masksToBounds = true
    }
    
    //MARK:设置角标
    class func cornerAdd(view:UIView?,text:String,backgroundColor:UIColor,textColor:UIColor,borderColor:UIColor,borderWidht:CGFloat,font:UIFont,maxSize : CGSize,maginLeft:CGFloat,maginTop:CGFloat){
        if view == nil {
            return
        }
        let size = textSize(text: text, font: font, maxSize: maxSize)
        let x = (view?.frame.width)! - size.width/2 + maginLeft
        let y = -size.height/2 + maginTop
        var label = view?.viewWithTag(100) as? UILabel
        if label == nil {
            var wid = size.width+10
            if ((size.height+10)>(size.width+10)){
                wid = size.height+10
            }
            label = UILabel.init(frame: CGRect(x: x, y: y, width: wid, height: size.height+10))
            label?.tag = 100
            view?.addSubview(label!)
        }
        label?.font = font
        label?.text = text;
        label?.textAlignment = .center
        label?.backgroundColor = backgroundColor
        label?.textColor = textColor
        label?.layer.cornerRadius = (label?.frame.height)!/2
        label?.layer.borderColor = borderColor.cgColor
        label?.layer.borderWidth = borderWidht
        label?.layer.masksToBounds = true
    }
    
    //MARK:统一设置阴影
    class func viewLayerShadow(view:UIView,color:CGColor,shadowRadius:Float) ->Void{
        //添加阴影
        view.layer.shadowOpacity = 0.7 //不透明图
        view.layer.shadowColor = color
        view.layer.shadowOffset = CGSize(width: 0, height: 3) // 设置阴影的偏移量
        view.layer.shadowRadius = CGFloat(shadowRadius)
        view.clipsToBounds = false //添加此句展示效果
    }
    
    //MARK:统一设置阴影
    class func viewLayerShadow(view:UIView) ->Void{
        //添加阴影
        view.layer.shadowOpacity = 1 //不透明图
        view.layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.15).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height:3) // 设置阴影的偏移量
        view.layer.shadowRadius = CGFloat(3)
        view.clipsToBounds = false //添加此句展示效果
    }
    
    //MARK:统一设置阴影
    class func viewLayerShadowShadowOffsetHeight(view:UIView) ->Void{
        //添加阴影
        view.layer.shadowOpacity = 1 //不透明图
        view.layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.15).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height:0) // 设置阴影的偏移量
        view.layer.shadowRadius = CGFloat(3)
        view.clipsToBounds = false //添加此句展示效果
    }
    
    //MARK:统一设置阴影
    class func viewLayerShadowAll(view:UIView) ->Void{
        //添加阴影
        view.layer.shadowOpacity = 1 //不透明图
        view.layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.15).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height:0) // 设置阴影的偏移量
        view.layer.shadowRadius = CGFloat(3)
        view.clipsToBounds = false //添加此句展示效果
    }
    
    //MARK:统一设置阴影
    class func viewLayerShadowCornerRadius(view:UIView,color:CGColor,cornerRadius:Float,shadowRadius:Float) ->Void{
        //添加阴影
        view.layer.shadowOpacity = 1 //不透明图
        view.layer.shadowColor = color
        view.layer.shadowOffset = CGSize(width: 0, height: 0) // 设置阴影的偏移量
        view.layer.shadowRadius = CGFloat(shadowRadius)
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = false //添加此句展示效果
    }
    
    
    //MARK:统一设置阴影
    class func viewLayerShadowCornerRadius(view:UIView,cornerRadius:Float) ->Void{
        //添加阴影
        view.layer.shadowOpacity = 1 //不透明图
        view.layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.15).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3) // 设置阴影的偏移量
        view.layer.shadowRadius = CGFloat(3)
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = false //添加此句展示效果
    }
    
    //MARK:画虚线
    class func drawDottedLine(view:UIView,color:UIColor) ->Void{
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.bounds = view.bounds
        shapeLayer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)] //设置线长和间隔
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0)) //开始位置
        path.addLine(to: CGPoint(x: view.frame.width-5, y: 0)) //结束位置
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    
    // MARK:正则判断手机号码地址格式
    class func isMobileNumber(mobileNum:String?) -> Bool {
        if mobileNum == nil{
            return false
        }
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
         * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
         * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
         * 电信号段: 133,149,153,170,173,177,180,181,189
         */
        let MOBILE = "^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
        /**
         * 中国移动：China Mobile
        134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
         */
         let CM = "^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
        /**
         * 中国联通：China Unicom
         * 130,131,132,145,155,156,170,171,175,176,185,186
         */
        let CU = "^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
        /**
         * 中国电信：China Telecom
         * 133,149,153,170,173,177,180,181,189
         */
         let CT = "^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
        
        let perdicate1 = NSPredicate.init(format: "SELF MATCHES %@",MOBILE)
        let perdicate2 = NSPredicate.init(format: "SELF MATCHES %@",CM)
        let perdicate3 = NSPredicate.init(format: "SELF MATCHES %@",CU)
        let perdicate4 = NSPredicate.init(format: "SELF MATCHES %@",CT)
        
        if perdicate1.evaluate(with:mobileNum) || perdicate2.evaluate(with:mobileNum) || perdicate3.evaluate(with:mobileNum) || perdicate4.evaluate(with:mobileNum) {
            return true
        }else{
            return false
        }
    }
    //MARK:生成二维码
    class func generateQRCode(messgae:NSString,width:CGFloat,height:CGFloat) -> UIImage {
        var returnImage:UIImage?
        if (messgae.length > 0 && width > 0 && height > 0){
            let inputData = messgae.data(using: String.Encoding.utf8.rawValue)! as NSData
            // CIQRCodeGenerator
            let filter = CIFilter.init(name: "CIQRCodeGenerator")!
            filter.setValue(inputData, forKey: "inputMessage")
            var ciImage = filter.outputImage!
            let min = width > height ? height :width;
            let scaleX = min/ciImage.extent.size.width
            let scaleY = min/ciImage.extent.size.height
            ciImage = ciImage.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
            returnImage = UIImage.init(ciImage: ciImage)
        }else {
            returnImage = nil;
        }
        return returnImage!
    }
    
    //MARK:生成带图片的二维码
    class func generateQRCodeWithCenterImage(messgae:NSString,width:CGFloat,height:CGFloat,centerImage:UIImage) -> UIImage {
        let backImage = generateQRCode(messgae: messgae, width: width, height: height)
        UIGraphicsBeginImageContext(backImage.size);
        backImage.draw(in: CGRect.init(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height))
        let centerImageWH:CGFloat = backImage.size.width > backImage.size.height ? backImage.size.height * 0.2 : backImage.size.width*0.2
        centerImage.draw(in: CGRect.init(x: (backImage.size.width - centerImageWH)*0.5, y: (backImage.size.height - centerImageWH)*0.5, width: centerImageWH, height: centerImageWH))
        let returnImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return returnImage!
    }
    
    //MARK:生成条码
   class func generateBarCode(messgae:NSString,width:CGFloat,height:CGFloat) -> UIImage {
        var returnImage:UIImage?
        if (messgae.length > 0 && width > 0 && height > 0){
            let inputData:NSData? = messgae.data(using: String.Encoding.utf8.rawValue)! as NSData
            // CICode128BarcodeGenerator
            let filter = CIFilter.init(name: "CICode128BarcodeGenerator")!
            filter.setValue(inputData, forKey: "inputMessage")
            var ciImage = filter.outputImage!
            let scaleX = width/ciImage.extent.size.width
            let scaleY = height/ciImage.extent.size.height
            ciImage = ciImage.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
            returnImage = UIImage.init(ciImage: ciImage)
        }else {
            returnImage = nil;
        }
        return returnImage!
    }
    
    //MARK:计算字符串的宽度，高度
   class func stringSize(string:String,font:UIFont,maxSize:CGSize) ->CGSize{
        // 计算字符串的宽度，高度
        let attributes = [NSAttributedStringKey.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = string.boundingRect(with: maxSize, options: option, attributes: attributes, context: nil)
        return rect.size
    }
    
    
    //MARK:geitextField设置提示Label
    class func cornerAdd(view:UIView?,text:String,textColor:UIColor){
        if view == nil {
            return
        }
        var label = view?.viewWithTag(100) as? UILabel
        if label == nil {
            label = UILabel.init(frame: CGRect(x: 0, y: (view?.frame.size.height)!-10, width: (view?.frame.size.width)!-20 , height: 20))
            label?.tag = 100
            view?.addSubview(label!)
        }
        label?.font = UIFont.systemFont(ofSize: 10)
        label?.text = text;
        label?.textAlignment = .right
        label?.textColor = textColor
    }
    
    //MARK:文件写入
    class func writeToFile(homeFolder:String,fileName:String,data:Data) ->Void{
        
        let fileManager = FileManager.default
        let filePath:String = NSHomeDirectory() + homeFolder //文件夹路径
        let file = filePath+"/"+fileName //文件寻址路径
        //判断文件是否存在
        let exist = fileManager.fileExists(atPath: filePath)
        if !exist{
        //创建文件夹
        //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
            do{
                try fileManager.createDirectory(atPath: filePath,
                                         withIntermediateDirectories: false, attributes: nil)
            }catch{
                print("writeToFile >> createFolder false >",error.localizedDescription)
            }
//        }else{
//            try! fileManager.removeItem(atPath: file)
        }
        
        if !fileManager.fileExists(atPath: filePath) {
            //nil的话，输出空
            print("writeToFile >> createFolder false >",filePath)
        }else{
            //创建文件
            try? data.write(to: URL(fileURLWithPath: file))
            
            //从url里面读取数据，读取成功则赋予readData对象，读取失败则走else逻辑
            if fileManager.contents(atPath: file) == nil {
                //nil的话，输出空
                print("writeToFile >> writeData false >",file)
            }
        }
    }
    
    //MARK:文件读取
    class func readToFile(homeFolder:String,fileName:String) ->Data?{
        
        let fileManager = FileManager.default
        let filePath:String = NSHomeDirectory() + homeFolder //文件夹路径
        let file = filePath+"/"+fileName //文件寻址路径
        //从url里面读取数据
        return fileManager.contents(atPath: file)
    }
    
    //MARK:带html格式的富文本
    class func htmLString(htmLstring:String,fontSize:CGFloat) ->NSMutableAttributedString?{
        var attributedString: NSMutableAttributedString? = nil
        let data = htmLstring.data(using: .unicode)
        if data == nil{
            print("error ","htmLstring.data(using: .unicode) is nil")
            return nil
        }
        attributedString = try? NSMutableAttributedString.init(data: data!, options:[.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        attributedString?.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: NSRange(location: 0, length: attributedString?.length ?? 0))
        return attributedString
    }
    
    
    //MARK:判断UserDefaults中是否已经存在
    class func isFrist(str:String) -> Bool{
        var flag = false
        let userid = UserDefaults.standard.string(forKey: str)
        if(userid == nil){
            flag = true
        }
        //不存在则生成一个新的并保存
        let uuid_ref = CFUUIDCreate(nil)
        let uuid_string_ref = CFUUIDCreateString(nil , uuid_ref)
        let uuid = uuid_string_ref! as String
        UserDefaults.standard.set(uuid, forKey: str)
        
        return false
    }
    
}
