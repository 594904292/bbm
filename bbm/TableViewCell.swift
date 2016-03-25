

import UIKit
import Alamofire
class TableViewCell:UITableViewCell
{
    var customView:UIView!
    var bubbleImage:UIImageView!
    var avatarImage:UIImageView!
    var msgItem:MessageItem!
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    //- (void) setupInternalData
    init(data:MessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        rebuildUserInterface()
    }
    
    
    func rebuildUserInterface()
    {
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        if (self.bubbleImage == nil)
        {
            self.bubbleImage = UIImageView()
            self.addSubview(self.bubbleImage)
            
        }
        
        let type =  self.msgItem.mtype
        let width =  self.msgItem.view.frame.size.width
        
        let height =  self.msgItem.view.frame.size.height
        
        var x =  (type == ChatType.Someone) ? 0 : self.frame.size.width - width - self.msgItem.insets.left - self.msgItem.insets.right
        
        var y:CGFloat =  0
        //if we have a chatUser show the avatar of the YDChatUser property
        if (self.msgItem.user.username != "")
        {
             let thisUser =  self.msgItem.user
            var picname:String = thisUser.avatar
             let logo = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(picname);
            Alamofire.request(.GET, logo).response { (_, _, data, _) -> Void in
                if let d = data as? NSData!
                {
                    //self.avatarImage?.image=UIImage(data: d)
                    self.avatarImage = UIImageView(image:UIImage(data: d))
                    self.avatarImage.layer.cornerRadius = 9.0
                    self.avatarImage.layer.masksToBounds = true
                    self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).CGColor
                    self.avatarImage.layer.borderWidth = 1.0
                    //别人头像，在左边，我的头像在右边
                   let avatarX =  (type == ChatType.Someone) ? 2 : self.frame.size.width - 52
                    //头像消息底部
                    let avatarY =  height
                    //set the frame correctly
                    self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50)
                    self.addSubview(self.avatarImage)
                }
            }

            
            
            
       
            
            
            
            let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height)
            print("delta:\(delta)")
            if (delta > 0)
            {
                y = delta
            }
            if (type == ChatType.Someone)
            {
                x += 54
            }
            if (type == ChatType.Mine)
            {
                x -= 54
            }
        }
        print("Y:\(y)")
        //self.customView.removeFromSuperview()
        
        self.customView = self.msgItem.view
        self.customView.frame = CGRectMake(x + self.msgItem.insets.left, y + self.msgItem.insets.top, width, height)
        
        self.addSubview(self.customView)
        
        //depending on the ChatType a bubble image on the left or right
        if (type == ChatType.Someone)
        {
            self.bubbleImage.image = UIImage(named:("yoububble.png"))!.stretchableImageWithLeftCapWidth(21,topCapHeight:14)
            
        }
        else {
            self.bubbleImage.image = UIImage(named:"mebubble.png")!.stretchableImageWithLeftCapWidth(15, topCapHeight:14)
        }
        self.bubbleImage.frame = CGRectMake(x, y, width + self.msgItem.insets.left + self.msgItem.insets.right, height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
    
    
}
