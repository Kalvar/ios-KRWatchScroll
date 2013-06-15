//
//  ViewController.m
//  KRWatchScroll
//
//  Created by Kalvar on 13/6/15.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "ViewController.h"
#import "KRWatchScroll.h"

@interface ViewController ()<KRWatchScrollDelegate>

@property (nonatomic, strong) KRWatchScroll *_krWatchScroll;
@property (nonatomic, strong) NSMutableArray *_datas;

@end

@implementation ViewController

@synthesize outTableView;
//
@synthesize _krWatchScroll;
@synthesize _datas;

/*
 * @ This sample is to watch UITableView.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	_krWatchScroll = [[KRWatchScroll alloc] init];
    _datas         = [[NSMutableArray alloc] initWithCapacity:0];
    for( int i=1; i<=20; ++i )
    {
        [_datas addObject:[NSString stringWithFormat:@"%i", i]];
    }
    self.outTableView.dataSource = self;
    self.outTableView.delegate   = self;
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
        case KRWatchScrollNothing:
        default:
            //Nothing
            NSLog(@"Scrolling Nothing.");
            break;
    }
}

@end
