//
//  KRWatchScroll.m
//  V0.9.1 beta
//
//  Created by Kalvar on 13/6/15.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "KRWatchScroll.h"

@interface KRWatchScroll ()

@end

@interface KRWatchScroll (fixPrivate)

-(void)_initWithVars;

@end

@implementation KRWatchScroll (fixPrivate)

-(void)_initWithVars
{
    self.offsetTop         = 0.0f;
    self.offsetBottom      = 0.0f;
    self.watchHorizontally = NO;
}

@end

@implementation KRWatchScroll

@synthesize delegate = _delegate;
@synthesize watchScrollView;
@synthesize offsetTop;
@synthesize offsetBottom;
@synthesize watchHorizontally;

+(instancetype)sharedWatcher
{
    static dispatch_once_t pred;
    static KRWatchScroll *_singleton = nil;
    dispatch_once(&pred, ^{
        _singleton = [[KRWatchScroll alloc] init];
    });
    return _singleton;
}

-(id)init
{
    self = [super init];
    if( self )
    {
        [self _initWithVars];
    }
    return self;
}

-(id)initWithDelegate:(id<KRWatchScrollDelegate>)_theDelegate
{
    self = [super init];
    if( self )
    {
        self.delegate = _theDelegate;
        [self _initWithVars];
    }
    return self;
}

#pragma --mark
-(void)startWatch
{
    self.watchScrollView.delegate = self;
}

-(void)startWatchScrollView:(UIScrollView *)_scrollView
{
    self.watchScrollView = _scrollView;
    [self startWatch];
}

-(KRWatchScrollType)findScrollingToWhereWithScrollView:(UIScrollView *)_scrollView
{
    if( !_scrollView )
    {
        return KRWatchScrollNothing;
    }
    KRWatchScrollType _krWatchScrollType = KRWatchScrollNothing;
    CGPoint _scrollViewContentOffset     = _scrollView.contentOffset;
    CGRect _scrollViewBounds             = _scrollView.bounds;
    CGSize _scrollViewContentSize        = _scrollView.contentSize;
    UIEdgeInsets _scrollViewContentInset = _scrollView.contentInset;
    if( self.watchHorizontally )
    {
        /*
         * @ Calculate the Left ( also top ) and Right ( also bottom ).
         */
        float x = _scrollViewContentOffset.x + _scrollViewBounds.size.width - _scrollViewContentInset.left;
        float w = _scrollViewContentSize.width;
        //捲動到了最左邊( Top )
        if( _scrollViewContentOffset.x <= self.offsetTop )
        {
            _krWatchScrollType = KRWatchScrollToLeft;
        }
        //捲動到了最右邊( Bottom )
        if( x >= w + self.offsetBottom && _scrollViewContentOffset.x > 0.0f )
        {
            _krWatchScrollType = KRWatchScrollToRight;
        }
    }
    else
    {
        /*
         * @ Calculate the Top and Bottom.
         */
        float y = _scrollViewContentOffset.y + _scrollViewBounds.size.height - _scrollViewContentInset.top;
        float h = _scrollViewContentSize.height;
        //捲動到了頂端
        if( _scrollViewContentOffset.y <= self.offsetTop )
        {
            _krWatchScrollType = KRWatchScrollToTop;
        }
        //捲動到了底部
        if( y >= h + self.offsetBottom && _scrollViewContentOffset.y > 0.0f )
        {
            _krWatchScrollType = KRWatchScrollToBottom;
        }
    }
    return _krWatchScrollType;
}

#pragma UIScrollViewDelegate
/*
 * @ 只要有在捲動( 滾動 )就會觸發
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@" scrollViewDidScroll");
    //NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}

/*
 * @ 拖曳就是「點擊並拖動，而手指未離開的狀態」
 *
 * @ 將要開始拖曳時
 *
 *   - 拖曳的執行順序是 :
 *
 *     //將要開始拖曳
 *     scrollViewWillBeginDragging     ->
 *     //完成拖曳
 *     scrollViewDidEndDragging        ->
 *     //滾動將開始減速
 *     scrollViewWillBeginDecelerating ->
 *     //滾動完全停止
 *     scrollViewDidEndDecelerating
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
}

/*
 * @ 完成拖曳時
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    if( _delegate )
    {
        if( [_delegate respondsToSelector:@selector(krWatchScrollDidEndDragging)] )
        {
            [_delegate krWatchScrollDidEndDragging];
        }
    }
    
}

/*
 * @ 滾動將開始減速
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDecelerating");
}

/*
 * @ 滾動完全停止
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    KRWatchScrollType _krWatchScrollType = [self findScrollingToWhereWithScrollView:scrollView];
    switch (_krWatchScrollType)
    {
        case KRWatchScrollToTop:
            if( [_delegate respondsToSelector:@selector(krWatchScrollDidScrollToTop)] )
            {
                [_delegate krWatchScrollDidScrollToTop];
            }
            break;
        case KRWatchScrollToBottom:
            if( [_delegate respondsToSelector:@selector(krWatchScrollDidScrollToBottom)] )
            {
                [_delegate krWatchScrollDidScrollToBottom];
            }
            break;
        case KRWatchScrollToLeft:
            if( [_delegate respondsToSelector:@selector(krWatchScrollDidScrollToLeft)] )
            {
                [_delegate krWatchScrollDidScrollToLeft];
            }
            break;
        case KRWatchScrollToRight:
            if( [_delegate respondsToSelector:@selector(krWatchScrollDidScrollToRight)] )
            {
                [_delegate krWatchScrollDidScrollToRight];
            }
            break;
        case KRWatchScrollNothing:
        default:
            if( [_delegate respondsToSelector:@selector(krWatchScrollDidStopScroll)] )
            {
                [_delegate krWatchScrollDidStopScroll];
            }
            break;
    }
}

/*
 * @ 滾動的動畫停止時
 *   - 即 setContentOffset 改變時，這裡會觸發
 *   - 但大多數情況都不需要用到這裡
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndScrollingAnimation");
}

/*
 * @ 是否允許點擊「狀態列」時，直接捲到最頂端
 *   - 預設為 YES
 */
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewShouldScrollToTop");
    return YES;
}

/*
 * @ 當點擊狀態列後，滾動到頂端時觸發
 */
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScrollToTop");
}

@end
