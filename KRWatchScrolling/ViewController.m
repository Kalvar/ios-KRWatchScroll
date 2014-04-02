//
//  ViewController.m
//  KRWatchScroll
//
//  Created by Kalvar on 13/6/15.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "ViewController.h"
#import "KRWatchScroll.h"

@interface ViewController ()

@property (nonatomic, strong) KRWatchScroll *_krWatchScroll;
@property (nonatomic, strong) NSMutableArray *_datas;

@end

@implementation ViewController (fixPrivate)

-(void)_makeSubviewsInScrollView
{
    CGFloat _x       = 0.0f;
    CGFloat _y       = 0.0f;
    CGFloat _width   = 80.0f;
    CGFloat _height  = 160.0f;
    CGFloat _offsetX = 10.0f;
    for( int _index=1; _index<20; _index++ )
    {
        UIImageView *_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample.png"]];
        [_imageView setFrame:CGRectMake(_x, _y, _width, _height)];
        [self.outScrollView addSubview:_imageView];
        _x += _width + _offsetX;
    }
    [self.outScrollView setContentSize:CGSizeMake(_x, self.outScrollView.frame.size.height)];
    self.outScrollView.scrollEnabled                  = YES;
    self.outScrollView.showsVerticalScrollIndicator   = NO;
    self.outScrollView.showsHorizontalScrollIndicator = NO;
    self.outScrollView.backgroundColor                = [UIColor clearColor];
    self.outScrollView.delegate                       = self;
}

-(void)_watchScrollView
{
    /*
     * If you did set " watchHorizontally " is YES, it will be watching the UIScrollView for scrolling of horizontally.
     * If you did set it to NO, it will be watching Vertically.
     * YES 是監控橫向捲動的 UIScrollView 動作。
     * NO  是監控直向捲動的 UIScrollView 動作。
     */
    self._krWatchScroll.watchHorizontally = YES;
    [self _makeSubviewsInScrollView];
}

-(void)_watchTableView
{
    self._krWatchScroll.watchHorizontally = NO;
    for( int i=1; i<=20; ++i )
    {
        [self._datas addObject:[NSString stringWithFormat:@"%i", i]];
    }
    self.outTableView.dataSource = self;
    self.outTableView.delegate   = self;
}

@end

@implementation ViewController

@synthesize outTableView;
@synthesize outScrollView;

@synthesize _krWatchScroll;
@synthesize _datas;

/*
 * @ This sample is to watch UITableView and UIScrollView.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	_krWatchScroll = [KRWatchScroll sharedWatcher];
    _datas         = [[NSMutableArray alloc] initWithCapacity:0];
    
    //Choose either one.
    //1. If you wanna watch UIScrollView that you can follow this.
    [self _watchScrollView];
    
    //2. If you wanna watch UITableView that you can follow this.
    [self _watchTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._datas count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier     = @"_someCell";
    static NSString *tempCellIdentifier = @"_tempCell";
    NSInteger row = [indexPath row];
    int dataCount = [self._datas count];
	if (dataCount == 0 && row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempCellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:tempCellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		cell.detailTextLabel.text = @"Loading ...";
		return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if( [self._datas count] > 0 )
    {
        cell.textLabel.text = [self._datas objectAtIndex:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //...
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}

#pragma --mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    KRWatchScrollType _krWatchScrollType = [self._krWatchScroll findScrollingToWhereWithScrollView:scrollView];
    switch (_krWatchScrollType)
    {
        case KRWatchScrollToTop:
            //捲到頂
            NSLog(@"Scrolling to Top.");
            break;
        case KRWatchScrollToBottom:
            //捲到底
            NSLog(@"Scrolling to Bottom.");
            break;
        case KRWatchScrollToLeft:
            //捲到左邊
            NSLog(@"Scrolling to Left.");
            break;
        case KRWatchScrollToRight:
            //捲到右邊
            NSLog(@"Scrolling to Right.");
            break;
        case KRWatchScrollNothing:
        default:
            //Nothing
            NSLog(@"Scrolling Nothing.");
            break;
    }
}

@end
