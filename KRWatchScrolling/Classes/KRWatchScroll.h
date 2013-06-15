//
//  KRWatchScroll.h
//  V0.9 beta
//
//  Created by Kalvar on 13/6/15.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _KRWatchScrollType
{
	KRWatchScrollToTop = 0,
    KRWatchScrollToBottom,
    KRWatchScrollNothing
} KRWatchScrollType;

@protocol KRWatchScrollDelegate;

@interface KRWatchScroll : NSObject<UIScrollViewDelegate>
{
    __weak id<KRWatchScrollDelegate> delegate;
    UIScrollView *watchScrollView;
    CGFloat offsetTop;
    CGFloat offsetBottom;
}

@property (nonatomic, weak) id<KRWatchScrollDelegate> delegate;
@property (nonatomic, strong) UIScrollView *watchScrollView;
@property (nonatomic, assign) CGFloat offsetTop;
@property (nonatomic, assign) CGFloat offsetBottom;

-(id)initWithDelegate:(id<KRWatchScrollDelegate>)_theDelegate;
-(void)startWatch;
-(void)startWatchScrollView:(UIScrollView *)_scrollView;
-(KRWatchScrollType)findScrollingToWhereWithScrollView:(UIScrollView *)_scrollView;

@end

@protocol KRWatchScrollDelegate <NSObject>

@optional

-(void)krWatchScrollDidEndDragging;
-(void)krWatchScrollDidScrollToTop;
-(void)krWatchScrollDidScrollToBottom;
-(void)krWatchScrollDidStopScroll;

@end


