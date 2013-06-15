//
//  ViewController.h
//  KRWatchScroll
//
//  Created by Kalvar on 13/6/15.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, weak) IBOutlet UITableView *outTableView;

@end
