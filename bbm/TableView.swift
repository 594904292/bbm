

import UIKit
enum ChatBubbleTypingType
{
    case Nobody
    case Me
    case Somebody
}
class TableView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    
    var bubbleSection:NSMutableArray!
    var chatDataSource:ChatDataSource!
    
    var  snapInterval:NSTimeInterval!
    var  typingBubble:ChatBubbleTypingType!
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect)
    {
        //the snap interval in seconds implements a headerview to seperate chats
        self.snapInterval = 60 * 60 * 24; //one day
        self.typingBubble = ChatBubbleTypingType.Nobody
        self.bubbleSection = NSMutableArray()
        
        super.init(frame:frame,  style:UITableViewStyle.Grouped)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.delegate = self
        self.dataSource = self
        
        
    }
    //按日期排序方法
    func sortDate(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        if((m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970)
        {
            return NSComparisonResult.OrderedAscending
        }
        else
        {
            return NSComparisonResult.OrderedDescending
        }
    }
    
    override func reloadData()
    {
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bubbleSection = NSMutableArray()
        var count =  0
        if ((self.chatDataSource != nil))
        {
            count = self.chatDataSource.rowsForChatTable(self)
            
            if(count > 0)
            {
                
                var bubbleData =  NSMutableArray(capacity:count)
                
                for (var i = 0; i < count; i++)
                {
                    
                    var object =  self.chatDataSource.chatTableView(self, dataForRow:i)
                    
                    bubbleData.addObject(object)
                    
                }
                bubbleData.sortUsingComparator(sortDate)
                
                var last =  ""
                
                var currentSection = NSMutableArray()
                // 创建一个日期格式器
                var dformatter = NSDateFormatter()
                // 为日期格式器设置格式字符串
                dformatter.dateFormat = "dd"
                
                
                for (var i = 0; i < count; i++)
                {
                    var data =  bubbleData[i] as! MessageItem
                    // 使用日期格式器格式化日期，日期不同，就新分组
                    var datestr = dformatter.stringFromDate(data.date)
                    if (datestr != last)
                    {
                        currentSection = NSMutableArray()
                        self.bubbleSection.addObject(currentSection)
                    }
                    self.bubbleSection[self.bubbleSection.count-1].addObject(data)
                    
                    last = datestr
                }
            }
        }
        super.reloadData()
        
        //滑向最后一部分
//        var secno = self.bubbleSection.count - 1
//        if(secno>0)
//        {
//            var indexPath =  NSIndexPath(forRow:self.bubbleSection[secno].count,inSection:secno)
//            self.scrollToRowAtIndexPath(indexPath,                atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
//        }
    }
    func numberOfSectionsInTableView(tableView:UITableView)->Int
    {
        var result = self.bubbleSection.count
        if (self.typingBubble != ChatBubbleTypingType.Nobody)
        {
            result++;
        }
        return result;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if (section >= self.bubbleSection.count)
        {
            return 1
        }
        
        return self.bubbleSection[section].count+1
    }
    
    
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat
    {
        
        // Header
        if (indexPath.row == 0)
        {
            return TableHeaderViewCell.getHeight()
        }
        var section : AnyObject  =  self.bubbleSection[indexPath.section]
        var pos:Int=indexPath.row - 1
        var data:AnyObject = section[pos] as AnyObject
        
        var item =  data as! MessageItem
        var height  = max(item.insets.top + item.view.frame.size.height + item.insets.bottom, 52)
        print("height:\(height)")
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        // Header based on snapInterval
        if (indexPath.row == 0)
        {
            var cellId = "HeaderCell"
            
            var hcell =  TableHeaderViewCell(reuseIdentifier:cellId)
            var secno = indexPath.section
            var section : AnyObject  =  self.bubbleSection[indexPath.section]
            var pos:Int=indexPath.row
            var data:AnyObject = section[pos] as AnyObject
            
            var item =  data as! MessageItem
            
            //var msgdata:MessageItem = section[indexPath.row] as! MessageItem
            
            hcell.setDate(item.date)
            return hcell
        }
        // Standard
        var cellId = "ChatCell"
        
        var section : AnyObject  =  self.bubbleSection[indexPath.section]
        
        var pos:Int=indexPath.row - 1
        var data:AnyObject = section[pos] as AnyObject

       
        
        let cell =  TableViewCell(data:data as! MessageItem, reuseIdentifier:cellId)
        
        return cell
    }
}
