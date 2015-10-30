
import UIKit

class SimTableViewCell:UITableViewCell
{
    //消息内容视图
    var customView:UIView!
    //消息背景
    var bubbleImage:UIImageView!
    //头像
    var avatarImage:UIImageView!
    //消息数据结构
    var msgItem:SimMessageItem!
    
    //消息时间视图
    var customtimeView:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    //- (void) setupInternalData
    init(data:SimMessageItem, reuseIdentifier cellId:String)
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
        
        var x :CGFloat = 0
        
        var y:CGFloat =  0
        //显示用户头像
        if (self.msgItem.logo != "")
        {
            
            let logo =  self.msgItem.logo
            
            self.avatarImage = UIImageView(image:UIImage(named:(logo != "" ? logo : "noAvatar.png")))
            
            self.avatarImage.layer.cornerRadius = 9.0
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).CGColor
            self.avatarImage.layer.borderWidth = 1.0
            
            //别人头像，在左边，我的头像在右边
            var avatarX :CGFloat = 2
            //头像居于消息底部
            let avatarY =  height
            //set the frame correctly
            self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50)
            self.addSubview(self.avatarImage)
            
            
            let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom
                + self.msgItem.view.frame.size.height)
            if (delta > 0)
            {
                y = delta
            }
            x += 54        }
        
        self.customView = self.msgItem.view
        self.customView.frame = CGRectMake(x + self.msgItem.insets.left, y + self.msgItem.insets.top, width, height)
        
        self.addSubview(self.customView)
        
        self.customtimeView = self.msgItem.timeview
        self.customtimeView.frame = CGRectMake(x + self.msgItem.insets.left, y + self.msgItem.insets.top+10, width, height)
        
        self.addSubview(self.customtimeView)
        
        
        self.bubbleImage.image = UIImage(named:("yoububble.png"))!.stretchableImageWithLeftCapWidth(21,topCapHeight:14)
        
        self.bubbleImage.frame = CGRectMake(x, y, width + self.msgItem.insets.left
            + self.msgItem.insets.right, height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
}
