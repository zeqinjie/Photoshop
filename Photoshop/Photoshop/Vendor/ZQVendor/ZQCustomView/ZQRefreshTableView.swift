//
//  ZQRrefreshTableView.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/25.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import ESPullToRefresh

class ZQRefreshTableView: UITableView {
    var loadMoreBlock:((_ tableView:ZQRefreshTableView)->())? {
        didSet{
            if loadMoreBlock != nil {
                self.es.addInfiniteScrolling {[weak self] in
                    self?.loadMoreBlock?(self!)
                }
            }
        }
    }
    var loadNewDataBlock:((_ tableView:ZQRefreshTableView)->())? {
        didSet{
            if loadNewDataBlock != nil {
                self.es.addPullToRefresh {[weak self] in
                    self?.loadNewDataBlock?(self!)
                }
            }
        }
    }
    
    
    /// 没有更多数据
    func noticeNoMoreData(){
        self.es.stopLoadingMore()
        self.es.noticeNoMoreData()
    }
    
    ///停止上拉刷新，停止下拉加载更多
    func endRefreshing(){
        if loadNewDataBlock != nil {
            self.es.stopPullToRefresh()
        }
        if loadMoreBlock != nil {
            self.es.stopLoadingMore()
        }
    }
    
    
    /// 重置数据
    func resetNoData(){
        self.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
    }
}
