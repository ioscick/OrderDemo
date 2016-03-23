//
//  ViewController.m
//  dongtaiView
//
//  Created by shenliping on 16/1/20.
//  Copyright © 2016年 shenliping. All rights reserved.
//

#import "ViewController.h"

#define WIDTH self.view.frame.size.width
#define HIGHT self.view.frame.size.height

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    CGRect viewRect;
}
@property (strong, nonatomic) NSMutableArray *buttonArray;

@property (strong, nonatomic) UIView *scrollV;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bar_set];
    
    [self set_scrollView];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panItem:)]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)set_scrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 104.0f, WIDTH, HIGHT)];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(WIDTH * 3, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    for (int i = 0; i < 3; i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f + WIDTH * i, 0.0f, WIDTH, HIGHT) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.scrollView addSubview:tableView];
    }
}

#pragma mark ---- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"sssssss%f",point.x);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"%f",point.x);
}
#pragma mark --- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"cell";
    return cell;
}

- (void)panItem:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    CGFloat viewx = translatedPoint.x / 3;

    if (viewRect.origin.x + viewx < 0)
    {
        return;
    }
    else if (viewRect.origin.x + viewx + viewRect.size.width > WIDTH)
    {
        return;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        _scrollV.frame = CGRectMake(viewRect.origin.x + viewx, viewRect.origin.y, viewRect.size.width, viewRect.size.height);
    }];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (fabs(translatedPoint.x) > WIDTH / 2)
        {
            if (translatedPoint.x < 0)
            {
                [UIView animateWithDuration:0.1 animations:^{
                    _scrollV.frame = CGRectMake(viewRect.origin.x - WIDTH / 3, viewRect.origin.y, viewRect.size.width, viewRect.size.height);
                }];
                viewRect = _scrollV.frame;
            }
            else
            {
                [UIView animateWithDuration:0.1 animations:^{
                    _scrollV.frame = CGRectMake(viewRect.origin.x + WIDTH / 3,	 viewRect.origin.y, viewRect.size.width, viewRect.size.height);
                }];
                viewRect = _scrollV.frame;
            }
            for (UIButton *button in _buttonArray)
            {
                if (button.tag == viewRect.origin.x / WIDTH * 3)
                {
                    button.selected = YES;
                }
                else
                {
                    button.selected = NO;
                }
            }
        }
        else
        {
            [UIView animateWithDuration:0.1 animations:^{
                _scrollV.frame = viewRect;
            }];
        }
    }
}

- (void)bar_set
{
    _buttonArray = [[NSMutableArray alloc] init];
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, WIDTH, 40.0f)];
    barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barView];
    
    NSArray *titleArray = @[@"推介", @"最新", @"最热"];
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f + WIDTH / 3 * i, 0.0f, WIDTH / 3, 30.0f)];
        button.tag = i;
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            button.selected = YES;
        }
        [barView addSubview:button];
        [_buttonArray addObject:button];
    }
    
    _scrollV = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, WIDTH / 3, 3.0f)];
    _scrollV.backgroundColor = [UIColor greenColor];
    [barView addSubview:_scrollV];
    viewRect = _scrollV.frame;
}

- (void)buttonTouched:(UIButton *)sender
{
    CGFloat viewx = _scrollV.frame.origin.x;
    CGFloat x = sender.frame.origin.x;
    for (UIButton *button in _buttonArray)
    {
        if (sender == button)
        {
            button.selected = YES;
        }
        else
        {
            button.selected = NO;
        }
    }
    
    if (viewx == x)
    {
        return;
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollV.frame = CGRectMake(x, _scrollV.frame.origin.y, _scrollV.frame.size.width, _scrollV.frame.size.height);
        }];
        viewRect = _scrollV.frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
