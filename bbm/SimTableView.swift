
import UIKit

class SimTableView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    //用于保存所有消息
    var bubbleSection:Array<SimMessageItem>!
    //数据源，用于与 ViewController 交换数据
    var chatDataSource:SimChatDataSource!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect)
    {
        self.bubbleSection = Array<SimMessageItem>()
        
        super.init(frame:frame,  style:UITableViewStyle.Grouped)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.delegate = self
        self.dataSource = self
        
        
    }
    
    override func reloadData()
    {
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        var count =  0
        if ((self.chatDataSource != nil))
        {
            count = self.chatDataSource.rowsForChatTable(self)
            
            if(count > 0)
            {
                
                for (var i = 0; i < count; i++)
                {
                    
                    let object =  self.chatDataSource.chatTableView(self, dataForRow:i)
                    bubbleSection.append(object)
                    
                }
                
                //按日期排序方法
                bubbleSection.sortInPlace({$0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970})
            }
        }
        super.reloadData()
    }
    
    //第一个方法返回分区数，在本例中，就是1
    func numberOfSectionsInTableView(tableView:UITableView)->Int
    {
        return 1
    }
    
    //返回指定分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section >= self.bubbleSection.count)
        {
            return 1
        }
        
        return self.bubbleSection.count+1
    }
    
    //用于确定单元格的高度，如果此方法实现得不对，单元格与单元格之间会错位
    func tableView(tableView:UITableView,heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        
        // Header
        if (indexPath.row == 0)
        {
            return 30.0
        }
        
        let data =  self.bubbleSection[indexPath.row - 1]
        
        return max(data.insets.top + data.view.frame.size.height + data.insets.bottom, 52)
    }
    
    //返回自定义的 TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        
        let cellId = "MsgCell"
        if(indexPath.row > 0)
        {
            let data =  self.bubbleSection[indexPath.row-1]
            
            let cell =  SimTableViewCell(data:data, reuseIdentifier:cellId)
            
            return cell
        }
        else
        {
            
            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
    }
}
