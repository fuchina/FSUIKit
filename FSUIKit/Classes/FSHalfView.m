//
//  FSHalfView.m
//  myhome
//
//  Created by Fudongdong on 2017/8/17.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSHalfView.h"

@interface FSHalfView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    *tableView;

@end

@implementation FSHalfView

- (void)showHalfView:(BOOL)show{
    if (show) {
        self.frame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        [UIView animateWithDuration:.3 animations:^{
            self.tableView.frame = CGRectMake(60, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.tableView.frame = CGRectMake(self.frame.size.width, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
        } completion:^(BOOL finished) {
            self.frame = CGRectMake([self basedOnController].view.bounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }];
    }
}

- (UIViewController *)basedOnController{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:UIViewController.class]) {
            __weak UIViewController *vc = (UIViewController *)next;
            return vc;
        }
        next = next.nextResponder;
    }
    return nil;
}

- (void)tapAction{
    [self showHalfView:NO];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self halfDesignViews];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    [_tableView reloadData];
}

- (void)halfDesignViews{
    UIView *tapView = [[UIView alloc] initWithFrame:self.bounds];
    tapView.backgroundColor = [UIColor blackColor];
    tapView.alpha = .28;
    [self addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [tapView addGestureRecognizer:tap];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, size.width - 60, size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
    
    [self showHalfView:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (_configCell) {
        _configCell(tableView,indexPath,cell);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectCell) {
        _selectCell(tableView,indexPath);
        [self showHalfView:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
