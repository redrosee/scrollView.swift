# scrollView.swift
#解决主要问题
1.scrollView的高度根据子控件label内容的高度而动态变化
在viewdidload里面设置contentSize的时候，scrollView是不能滑动的，原因说是在设置约束的时候已经重新设置，故需要在方法viewDidLayoutSubviews里面设置即可，这个调的时间比较靠后，连scrollview上的子控件button都可以拿到对应的Y值，故设置scrollview的高度就顺其自然了
override func viewDidLayoutSubviews() {
scrollView!.frame = view.bounds
scrollView!.contentSize = CGSizeMake(view.width, cancelButton!.frame.origin.y + 100)
}

2.遍历navigation栈里面的VC
for vc1:UIViewController in (self.navigationController!.viewControllers){
    if vc1.isKindOfClass(KLConversationListControllerViewController){
        let conversationVC = vc1 as! KLConversationListControllerViewController
        }
        }

3.关于snap的约束设置
