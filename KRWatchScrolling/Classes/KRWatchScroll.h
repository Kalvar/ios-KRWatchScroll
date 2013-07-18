//
//  KRWatchScroll.h
//  V0.9.1 beta
//
//  Created by Kalvar on 13/6/15.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _KRWatchScrollType
{
	KRWatchScrollToTop = 0,
    KRWatchScrollToBottom,
    KRWatchScrollToLeft,
    KRWatchScrollToRight,
    KRWatchScrollNothing
} KRWatchScrollType;

@protocol KRWatchScrollDelegate;

@interface KRWatchScroll : NSObject<UIScrollViewDelegate>
{
    __weak id<KRWatchScrollDelegate> delegate;
    UIScrollView *watchScrollView;
    CGFloat offsetTop;
    CGFloat offsetBottom;
    /*
     * If you did set " watchHorizontally " is YES, it will be watching the UIScrollView for scrolling of horizontally.
     * If you did set it to NO, it will be watching Vertically.
     * YES 是監控橫向捲動的 UIScrollView 動作。
     * NO  是監控直向捲動的 UIScrollView 動作。
     */
    BOOL watchHorizontally;
}

@property (nonatomic, weak) id<KRWatchScrollDelegate> delegate;
@property (nonatomic, strong) UIScrollView *watchScrollView;
@property (nonatomic, assign) CGFloat offsetTop;
@property (nonatomic, assign) CGFloat offsetBottom;
@property (nonatomic, assign) BOOL watchHorizontally;

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
-(void)krWatchScrollDidScrollToLeft;
-(void)krWatchScrollDidScrollToRight;
-(void)krWatchScrollDidStopScroll;

@end


