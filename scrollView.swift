import UIKit

class publicDetailsVC: UIViewController {
    var scrollView:UIScrollView?
    var publicNumArray:NSMutableArray = []
    var publicDetail:publicNumberDetailModel?
    var appID:String?
    var firstView:UIView?
    var publicImage : UIImageView?
    var titleLabel:UILabel?
    var detailLabel:UILabel?
    var titleLabel2:UILabel?
    var detailLabel2:UILabel?
    var switch1 = UISwitch()
    var switch2 = UISwitch()
    var cancelButton:UIButton?

    var secondView:UIView?
    var firthView:UIView?
    var fourView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLine()
        secondView = setupSecontView("消息免打扰", switc: switch1, tag: 1004)
        firthView = setupSecontView("置顶公众号", switc: switch2, tag: 1005)
        fourView = setupSecontView("查看历史消息", switc: switch1, tag: 1006)
        cancelButton = setupCancelAttention()
        //添加手势
        let tapLogic: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "historyMessageTapAction")
        fourView!.addGestureRecognizer(tapLogic)
        Constraints()
        //网络请求
        requestNetWork()
    }

    func requestNetWork() {
        //公众号详情
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NetworkManager.sharedInstance.requestPublicDetail(self.appID!, success: { (jsonDic:AnyObject) in
                let dic = jsonDic as! Dictionary<String,AnyObject>
                let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "obj")
                self.publicDetail = publicNumberDetailModel.init(jsonDic: dataDic)
                dispatch_async(dispatch_get_main_queue(), {

                    self.titleLabel2!.text = self.publicDetail!.enterprise_name
                    self.detailLabel2!.text = self.publicDetail!.descriptionn
                    self.publicImage!.sd_setImageWithURL(NSURL.init(string: self.publicDetail!.logo), placeholderImage: UIImage.init(named: "no_avatar"))
                    if  self.publicDetail!.disturb == "1" { //消息免打扰设置
                        self.switch1.on = false
                    }else if self.publicDetail!.disturb == "2"{
                        self.switch1.on = true
                    }
                    if  self.publicDetail!.order_by == "0" { //公众号置顶设置
                        self.switch2.on = false

                    }else{
                        if  self.publicDetail!.order_by != "" {
                            self.switch2.on = true
                        }else{
                            self.switch2.on = false
                        }
                    }
                    if   self.publicDetail!.descriptionn == "" {
                        self.detailLabel2!.snp_updateConstraints { (make) -> Void in
                            make.top.equalTo(self.titleLabel2!.snp_bottom).offset(6)
                            make.left.equalTo(self.detailLabel!.snp_right).offset(-10)
                            make.right.equalTo(self.firstView!).offset(-10)
                            make.height.equalTo(36)
                        }
                    }

                })

            }) { (error:String, repeal:Bool) in
                pprLog(error)
            }
        }
    }

    func setupFirstLine(){
        scrollView = UIScrollView()
        view.addSubview(scrollView!)
        firstView = UIView()
        publicImage = UIImageView()
        titleLabel = UILabel()
        detailLabel = UILabel()
        titleLabel2 = UILabel()
        detailLabel2 = UILabel()
        titleLabel!.text = "企业名称："
        detailLabel!.text = "简       介："
        detailLabel2!.numberOfLines = 0
        titleLabel!.textColor = grayDeepColor
        titleLabel2!.textColor = blackColor
        detailLabel!.textColor = grayDeepColor
        detailLabel2!.textColor = blackColor
        titleLabel!.font = UIFont.systemFontOfSize(14)
        titleLabel2!.font = UIFont.systemFontOfSize(14)
        detailLabel!.font = UIFont.systemFontOfSize(14)
        detailLabel2!.font = UIFont.systemFontOfSize(14)
        firstView!.backgroundColor = UIColor.whiteColor()
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.backgroundColor = view.backgroundColor
        scrollView!.addSubview(firstView!)
        firstView!.addSubview(publicImage!)
        firstView!.addSubview(titleLabel!)
        firstView!.addSubview(titleLabel2!)
        firstView!.addSubview(detailLabel!)
        firstView!.addSubview(detailLabel2!)
        //约束
        publicDetailsConstraints()
    }

    //分隔线
    func setupSeparatedLine(Y:CGFloat)->UIView{
        let separateLine = UIView()
        separateLine.backgroundColor = grayLineColor
        separateLine.frame = CGRectMake(0, Y, view.size.width, 1)
        return separateLine
    }

    func setupSecontView(titleName:String,switc:UISwitch,tag:Int)->UIView{
        let someView = UIView()
        someView.backgroundColor = UIColor.whiteColor()
        let label = UILabel()
        label.text = titleName
        label.font = UIFont.systemFontOfSize(16)
        label.textColor = blackColor
        scrollView!.addSubview(someView)
        someView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(someView).offset(10)
            make.centerY.equalTo(someView.snp_centerY).offset(0)
        }
        if tag == 1006 {//查看历史消息
            let imageVieww = UIImageView()
            imageVieww.image = UIImage.init(named: "directionArrow")
            someView.addSubview(imageVieww)
            imageVieww.snp_makeConstraints { (make) -> Void in
                make.right.equalTo(someView).offset(-10)
                make.centerY.equalTo(someView.snp_centerY).offset(0)
            }

        }else{
            switc.tag = tag
            switc.addTarget(self, action: "openAction:", forControlEvents:.ValueChanged)
            someView.addSubview(switc)
            switc.snp_makeConstraints { (make) -> Void in
                make.right.equalTo(someView).offset(-10)
                make.centerY.equalTo(someView.snp_centerY).offset(0)
            }
        }
        return someView
    }

    //取消关注按钮
    func setupCancelAttention()->UIButton{
        let btn = UIButton.init(type: .Custom)
        scrollView!.addSubview(btn)
        btn.setTitle("取消关注", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(17)
        btn.titleLabel?.textAlignment = .Center
        btn.addTarget(self, action: "CancelAction", forControlEvents:.TouchUpInside)
        btn.backgroundColor = UIColor.init(red: 234.0/255, green: 66.0/255, blue: 74.0/255, alpha: 1)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        return btn
    }
    //MARK: Action
    func CancelAction(){
        let poppverView = KLPopCancelPublicNumView()
        let window = UIApplication.sharedApplication().keyWindow
        poppverView.frame = UIScreen.mainScreen().bounds
        let descristionContent = "取消关注后，你将无法再收到来自" + self.title! + "的消息"
        poppverView.redlabel!.text = descristionContent
        poppverView.recordBtn?.setTitle("再想一会", forState: UIControlState.Normal)
        poppverView.giveUpBtn?.setTitle("取消关注", forState: UIControlState.Normal)
        poppverView.giveUpBtn?.setTitleColor(redColor, forState: UIControlState.Normal)
        poppverView.backgroundColor = UIColor.clearColor()
        window?.addSubview(poppverView)
        //x按钮
        poppverView.closePoppveBlock = {()->() in
            poppverView.removeFromSuperview()
        }
        //再想一会
        poppverView.chargeAccountBlock = {()->() in
            poppverView.removeFromSuperview()
        
        }
        //取消按钮
        poppverView.giveUpPoppveBlock = {()->() in
            poppverView.removeFromSuperview()
            //网络请求
            NetworkManager.sharedInstance.requestUnsubscribePublicNum(self.appID!, success: { (dicJson:AnyObject) in
                //1.从置顶列表删除对应appid
                let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                let setTopPath = (documentPath as NSString).stringByAppendingPathComponent("List.plist")
                if let publicArray = NSMutableArray.init(contentsOfFile: setTopPath) {
                    self.publicNumArray = publicArray as NSMutableArray
                }
                let appid = "app_" + self.appID!
                //要是已经置顶，就从列表删除，不置顶不需要处理
                if self.publicNumArray.count > 0 {
                    for temp in self.publicNumArray {
                        if temp as! String == appid {
                            self.publicNumArray.removeObject(appid)
                            self.publicNumArray.writeToFile(setTopPath, atomically: true)
                        }
                    }
                }
                //2.删除对应公众号
                for vc1:UIViewController in (self.navigationController!.viewControllers){
                    if vc1.isKindOfClass(KLConversationListControllerViewController){
                        let conversationVC = vc1 as! KLConversationListControllerViewController
                        if conversationVC.dataArray.count > 0 {
                            for model  in conversationVC.dataArray {
                                let modell = model as! EaseConversationModel
                                let appid = "app_" + self.appID!
                                if modell.conversation.chatter == appid {
                                conversationVC.dataArray.removeObject(model)
                                EaseMob.sharedInstance().chatManager.removeConversationByChatter!(modell.conversation.chatter,deleteMessages:true,append2Chat:true)
                                  self.navigationController?.popToRootViewControllerAnimated(false)
                                }
                            }
                            
                        }
                        }
                    }
                }, fail: { (error:String, re:Bool) in
                    
            })
        }

    }
    //手势点击 查看历史消息
    func historyMessageTapAction(){
            let webVC: WebViewController?
            webVC = webHelper.getWebVC((publicDetail?.history_url)!)
            self.navigationController?.pushViewController(webVC!, animated: true)
    }
    func openAction(send:UISwitch){
        if send.tag == 1004 {//消息免打扰
            let clickAction1 = switch1.on == true ? 2 : 1
            NetworkManager.sharedInstance.requestPublicSetdisturb(appID!, action: clickAction1, success: { (dicjson:AnyObject) in
                }, fail: { (error:String, re:Bool) in
            })
        }else if send.tag == 1005{//置顶公众号 1 置顶 2 取消置顶
            let clickAction2 = switch2.on == true ? 1 : 2
            let clickPublicNumTop = switch2.on == true ? "1" : "2"
            NetworkManager.sharedInstance.requestPublicSetTop(appID!, action: clickAction2, success: { (dicjson:AnyObject) in
                let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                let setTopPath = (documentPath as NSString).stringByAppendingPathComponent("List.plist")
                if let publicArray = NSMutableArray.init(contentsOfFile: setTopPath) {
                    self.publicNumArray = publicArray as NSMutableArray
                }
                let appid = "app_" + self.appID!
                if clickPublicNumTop == "1" {
                    self.publicNumArray.addObject(appid)
                }else{
                    self.publicNumArray.removeObject(appid)
                }
                self.publicNumArray.writeToFile(setTopPath, atomically: true)
                }, fail: { (error:String, re:Bool) in
                    pprLog(error)
            })
        }
    }
    //MARK: Constraints
    func publicDetailsConstraints(){
        self.firstView!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(scrollView!).offset(0)
        }

        self.publicImage!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(firstView!).offset(10)
            make.top.equalTo(firstView!).offset(20)
            make.height.equalTo(65)
            make.width.equalTo(65)
        }

        self.titleLabel!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(publicImage!.snp_right).offset(15)
            make.top.equalTo(firstView!).offset(13)
            make.height.equalTo(30)
            make.width.equalTo(73)
        }
        self.detailLabel!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel!.snp_bottom).offset(0)
            make.left.equalTo(publicImage!.snp_right).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(73)
        }

        self.titleLabel2!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel!.snp_right).offset(0)
            make.top.equalTo(firstView!).offset(13)
            make.height.equalTo(30)
            make.right.equalTo(firstView!).offset(-10)
        }
        self.detailLabel2!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel2!.snp_bottom).offset(6)
            make.left.equalTo(detailLabel!.snp_right).offset(0)
            make.right.equalTo(firstView!).offset(-10)
            make.bottom.equalTo(firstView!).offset(-23) //important
        }
    }

    func Constraints(){
        self.secondView!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(firstView!.snp_bottom).offset(15)
            make.height.equalTo(60)

        }
        self.firthView!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(secondView!.snp_bottom).offset(1)
            make.height.equalTo(60)

        }
        self.fourView!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(firthView!.snp_bottom).offset(15)
            make.height.equalTo(60)

        }

        self.cancelButton!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(fourView!.snp_bottom).offset(30)
            make.height.equalTo(45)
            
        }

    }
    override func viewDidLayoutSubviews() {
        scrollView!.frame = view.bounds
        scrollView!.contentSize = CGSizeMake(view.width, cancelButton!.frame.origin.y + 100)
    }
}













