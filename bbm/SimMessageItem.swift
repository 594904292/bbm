
import UIKit

//消息类型，我的还是别人的
enum SimChatType
{
    case Mine
    case Someone
}

class SimMessageItem
{
    //头像
    var logo:String
    //消息时间
    var date:NSDate
    //消息类型
    var mtype:SimChatType
    //内容视图，标签或者图片
    var view:UIView
    
    //内容视图，标签或者图片
    var timeview:UIView

    //边距
    var insets:UIEdgeInsets
    
    //设置我的文本消息边距
    class func getTextInsetsMine() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:5, left:10, bottom:11, right:17)
    }
    
    //设置他人的文本消息边距
    class func getTextInsetsSomeone() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:5, left:15, bottom:11, right:10)
    }
    
    //设置我的图片消息边距
    class func getImageInsetsMine() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    
    //设置他人的图片消息边距
    class func getImageInsetsSomeone() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    
    //构造文本消息体
    convenience init(body:NSString, logo:String, date:NSDate, mtype:SimChatType)
    {
        var font =  UIFont.boldSystemFontOfSize(12)
        
        var width =  225, height = 10000.0
        
        var atts =  NSMutableDictionary()
        atts.setObject(font,forKey:NSFontAttributeName)
        
        var size =  body.boundingRectWithSize(CGSizeMake(CGFloat(width), CGFloat(height)),
            options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:nil, context:nil)
        
        var label =  UILabel(frame:CGRectMake(0, 0, size.size.width, size.size.height))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = (body.length != 0 ? body as String : "")
        label.font = font
        label.backgroundColor = UIColor.clearColor()
        
        
        
        var datelabel =  UILabel(frame:CGRectMake(0, 30, size.size.width, size.size.height))
        
        datelabel.numberOfLines = 0
        datelabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        datelabel.text = "2015-10-16"
        datelabel.font = font
        datelabel.backgroundColor = UIColor.blueColor()
        
        var insets:UIEdgeInsets =  (mtype == SimChatType.Mine ?
            SimMessageItem.getTextInsetsMine() : SimMessageItem.getTextInsetsSomeone())
        
        self.init(logo:logo, date:date, mtype:mtype, view:label, dateview:datelabel,insets:insets)
    }
    
    //可以传入更多的自定义视图
    init(logo:String, date:NSDate, mtype:SimChatType, view:UIView,dateview:UIView,  insets:UIEdgeInsets)
    {
        self.view = view
        self.timeview = dateview
        self.logo = logo
        self.date = date
        self.mtype = mtype
        self.insets = insets
    }
    
    //构造图片消息体
    convenience init(image:UIImage, logo:String,  date:NSDate, mtype:SimChatType)
    {
        var size = image.size
        //等比缩放
        if (size.width > 220)
        {
            size.height /= (size.width / 220);
            size.width = 220;
        }
        let imageView = UIImageView(frame:CGRectMake(0, 0, size.width, size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets:UIEdgeInsets =  (mtype == SimChatType.Mine ?
            SimMessageItem.getImageInsetsMine() : SimMessageItem.getImageInsetsSomeone())
        
        var font =  UIFont.boldSystemFontOfSize(12)

        var datelabel =  UILabel(frame:CGRectMake(0, 0,size.width,size.height))
        
        datelabel.numberOfLines = 0
        datelabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        datelabel.text = "2015-10-16"
        datelabel.font = font
        
        datelabel.backgroundColor = UIColor.blueColor()
        
        self.init(logo:logo,  date:date, mtype:mtype, view:imageView, dateview:datelabel,insets:insets)
    }
}