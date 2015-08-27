//
//  RefreshView.swift
//  PullToRefresh
//
//  Created by fang on 15/6/9.
//  Copyright (c) 2015年 Fang YiXiong. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(refreshView: RefreshView)
}

private let kSceneHeight: CGFloat = 120.0

class RefreshView: UIView, UIScrollViewDelegate {
    private unowned var scrollView: UIScrollView
    private var progress: CGFloat = 0.0
    
    var refreshItems = [RefreshItem]()
    weak var delegate: RefreshViewDelegate?
    
    var isRefreshing = false
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
//        backgroundColor = UIColor.greenColor()
        updateBackgroundColor()
        setupRefreshItems()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRefreshItems() {
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        let catImageView = UIImageView(image: UIImage(named: "cat"))
        let capeBackImageView = UIImageView(image: UIImage(named: "cape_back"))
        let capeFrontImageView = UIImageView(image: UIImage(named: "cape_front"))
        
        refreshItems = [
            RefreshItem(view: buildingsImageView,
                centerEnd: CGPoint(x: CGRectGetMidX(bounds),
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds) - CGRectGetHeight(buildingsImageView.bounds) / 2),
                parallaxRatio: 1.5, sceneHeight: kSceneHeight),
            RefreshItem(view: sunImageView,
                centerEnd: CGPoint(x: CGRectGetWidth(bounds) * 0.1,
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds) - CGRectGetHeight(sunImageView.bounds)),
                parallaxRatio: 3, sceneHeight: kSceneHeight),
            RefreshItem(view: groundImageView,
                centerEnd: CGPoint(x: CGRectGetMidX(bounds),
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2),
                parallaxRatio: 0.5, sceneHeight: kSceneHeight),
            RefreshItem(view: capeBackImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(capeBackImageView.bounds)/2), parallaxRatio: -1, sceneHeight: kSceneHeight),
            RefreshItem(view: catImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(catImageView.bounds)/2), parallaxRatio: 1, sceneHeight: kSceneHeight),
            RefreshItem(view: capeFrontImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(capeFrontImageView.bounds)/2), parallaxRatio: -1, sceneHeight: kSceneHeight),
        ]
        
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
        
    }
    
    func updateBackgroundColor() {
        backgroundColor = UIColor(white: 0.7 * progress + 0.2, alpha: 1.0)
    }
    
    func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(progress)
        }
    }
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top += kSceneHeight
        }) { (_) -> Void in
        }
    }
    
    func endRefreshing() {
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top -= kSceneHeight
            }) { (_) -> Void in
            self.isRefreshing = false
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progress == 1 {
            beginRefreshing()
            targetContentOffset.memory.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(self)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        
        //1. 先拿到刷新视图可见区域的高度
        let refreshViewVisibleHeight = max(0, -scrollView.contentOffset.y - scrollView.contentInset.top)
        //2. 计算当前滚动的进度，范围是0-1
        progress = min(1, refreshViewVisibleHeight / kSceneHeight)
        //3. 根据进度来改变背景色
        updateBackgroundColor()
        //4. 根据进度来更新图片位置
        updateRefreshItemPositions()
    }
    

}
