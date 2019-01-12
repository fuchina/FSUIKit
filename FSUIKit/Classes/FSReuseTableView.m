//
//  FSReuseTableView.m
//  myhome
//
//  Created by FudonFuchina on 2018/4/5.
//  Copyright © 2018年 fuhope. All rights reserved.
//

#import "FSReuseTableView.h"
#import "MJRefresh.h"

@interface FSReuseTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSReuseTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self bestCellDesignViews];
    }
    return self;
}

- (void)bestCellDesignViews{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self addSubview:_tableView];
        
    }
}

- (void)setRefresh_header:(void (^)(void))refresh_header{
    _refresh_header = refresh_header;
    
    if (refresh_header) {
        __weak typeof(self)this = self;
        _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (this.refresh_header) {
                this.refresh_header();
            }
        }];
    }
}

- (void)setRefresh_footer:(void (^)(void))refresh_footer{
    _refresh_footer = refresh_footer;
    
    if (refresh_footer) {
        __weak typeof(self)this = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (this.refresh_footer) {
                this.refresh_footer();
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.numberOfSections) {
        NSInteger count = self.numberOfSections(tableView);
        return count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.numberOfRowsInSection) {
        NSInteger count = self.numberOfRowsInSection(tableView, section);
        return count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellForRowAtIndexPath) {
        return self.cellForRowAtIndexPath(tableView, indexPath);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.willDisplayCell) {
        self.willDisplayCell(cell,indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.heightForRowAtIndexPath) {
        return self.heightForRowAtIndexPath(tableView,indexPath);
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.heightForHeaderInSection) {
        return self.heightForHeaderInSection(tableView,section);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.heightForFooterInSection) {
        return self.heightForFooterInSection(tableView, section);
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(tableView, indexPath);
    }
}

- (void)endRefresh{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

- (void)deleteRefresh{
    [_tableView.mj_header removeFromSuperview];
    [_tableView.mj_footer removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
