
import UIKit

enum ChatType
{
    case Mine
    case Someone
}

class MessageItem
{
    var user:UserInfo
    var date:NSDate
    var mtype:ChatType
    var view:UIView
    var insets:UIEdgeInsets
    
    
    class func getTextInsetsMine() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:5, left:10, bottom:11, right:17)
    }
    
    class func getTextInsetsSomeone() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:5, left:15, bottom:11, right:10)
    }
    class func getImageInsetsMine() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    class func getImageInsetsSomeone() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    
    
    convenience init(body:NSString, user:UserInfo, date:NSDate, mtype:ChatType)
    {
        var font =  UIFont.boldSystemFontOfSize(12)
        
        var width =  225, height = 10000.0
        
        //var atts =  NSMutableDictionary()
        //atts.setObject(font,forKey:NSFontAttributeName)
        
        //let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
          let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let atts = NSDictionary(object: font, forKey: NSFontAttributeName)

        var size =  body.boundingRectWithSize(CGSizeMake(CGFloat(width), CGFloat(height)),options:option,attributes:atts as! [String : AnyObject] ,context:nil)
        
        var label =  UILabel(frame:CGRectMake(0, 0, size.size.width+2, size.size.height))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = (body.length != 0 ? body as String : "").stringByAppendingString(" ")
        label.font = font
        label.backgroundColor = UIColor.clearColor()
        
        var insets:UIEdgeInsets =  (mtype == ChatType.Mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:label, insets:insets)
    }
    
    init(user:UserInfo, date:NSDate, mtype:ChatType, view:UIView, insets:UIEdgeInsets)
    {
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
    }
    
    convenience init(image:UIImage, user:UserInfo,  date:NSDate, mtype:ChatType)
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
        
        let insets:UIEdgeInsets =  (mtype == ChatType.Mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user:user,  date:date, mtype:mtype, view:imageView, insets:insets)
    }
    
    
}