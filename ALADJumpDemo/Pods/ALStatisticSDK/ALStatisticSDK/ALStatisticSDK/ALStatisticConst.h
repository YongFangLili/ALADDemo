//
//  ALStatisticConst.h
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#ifndef ALStatisticConst_h
#define ALStatisticConst_h

// 是否开启打印日志.
#define kLogSwitch

/// 捕获方法的时机.
static NSString * const kEventSelectorOption = @"EventSelectorOption";
/// 捕获的方法.
static NSString * const kEventSelector = @"EventSelector";
/// 处理捕获方法后的block.
static NSString * const kEventHandlerBlock = @"EventHandlerBlock";
/// 执行事件的对象.
static NSString * const kEventSender = @"EventSender";
/// 点击cell的indexpath.
static NSString * const kIndexPath = @"IndexPath";

/// 业务统计项.
/// 操作类型.
static NSString * const kTriggerType = @"triggerType";
/// 点击内容描述.
static NSString * const kTriggerName = @"triggerName";
/// 事件id.
static NSString * const kActionId = @"actionId";
/// 来源页面.
static NSString * const kSrcLocation = @"srcLocation";
/// 目标页面.
static NSString * const kToLocation = @"toLocation";
/// 资源类型.
static NSString * const kRefType = @"refType";
/// 资源id.
static NSString * const kRefId = @"refId";
/// 区块id.
static NSString * const kLocationId = @"locationId";


/// Tool.
/// AppDelegate.
static NSString * const kAppDelegate = @"AppDelegate";

/// vc.
static NSString * const kUIViewController = @"UIViewController";
/// nacVC.
static NSString * const kUINavigationController = @"UINavigationController";

/// view.
/// UITableview.
static NSString * const kUITableView = @"UITableView";
/// UICollectionView.
static NSString * const kUICollectionView = @"UICollectionView";
/// UIControl.
static NSString * const kUIControl = @"UIControl";
static NSString * const kUITextView = @"UITextView";
/// 上下拉.
static NSString * const kMJRefreshComponent = @"MJRefreshComponent";


#endif /* ALStatisticConst_h */
