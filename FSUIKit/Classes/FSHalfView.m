//
//  FSHalfView.m
//  myhome
//
//  Created by Fudongdong on 2017/8/17.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSHalfView.h"
#import "FSApp.h"

@interface FSHalfView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView    *tableView;

@end

@implementation FSHalfView {
    CGFloat     _leftWidth;
    UIView      *_tapView;
}

#if TARGET_IPHONE_SIMULATOR
- (void)dealloc {
    NSString *title = [[NSString alloc] initWithFormat:@"%@ dealloc",NSStringFromClass(self.class)];
    NSLog(@"%@",title);
}
#else
#endif

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _tapView.frame = self.bounds;
}

+ (FSHalfView *)showHalfViewInView:(UIView *)view frame:(CGRect)frame leftWidth:(CGFloat)leftWidth {
    FSHalfView *halfView = [[FSHalfView alloc] initWithFrame: frame];
    dispatch_async(dispatch_get_main_queue(), ^{
        [halfView showHalfView:YES leftWidth:leftWidth];
    });
    [view addSubview:halfView];
    return halfView;
}

- (void)showHalfView:(BOOL)show leftWidth:(CGFloat)leftWidth {
    if (show) {
        _leftWidth = leftWidth;
        
        [UIView animateWithDuration:.3 animations:^{
            self -> _tapView.alpha = .28;
            self.tableView.frame = CGRectMake(leftWidth, 0, self.bounds.size.width - leftWidth, self.bounds.size.height);
        }];
    } else {
        [UIView animateWithDuration:.3 animations: ^{
            self.tableView.frame = CGRectMake(self.bounds.size.width, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)tapAction {
    [self showHalfView:NO leftWidth:0];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self halfDesignViews];
    }
    return self;
}

- (void)halfDesignViews {
    _tapView = [[UIView alloc] initWithFrame:self.bounds];
    _tapView.backgroundColor = [UIColor blackColor];
    _tapView.alpha = 0;
    [self addSubview:_tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_tapView addGestureRecognizer:tap];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, size.width - _leftWidth, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.tableFooterView = UIView.new;
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(tableView);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"c";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectCell) {
        _selectCell(tableView,indexPath);
        [self showHalfView:NO leftWidth:0];
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
