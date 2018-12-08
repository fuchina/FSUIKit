//
//  FSShopClassView.m
//  myhome
//
//  Created by FudonFuchina on 2016/12/4.
//  Copyright © 2016年 fuhope. All rights reserved.
//

#import "FSShopClassView.h"

@interface FSShopClassView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView        *tableView;
@property (nonatomic,strong) UITableViewCell    *frontCell;

@end

@implementation FSShopClassView{
    UIColor     *_normalColor;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat rgb = 88/ 255.0;
        _normalColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
        [self shopClassDesignViews];
    }
    return self;
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        [_tableView reloadData];
    }
}

- (void)shopClassDesignViews{
    CGFloat rgb = 250 / 255.0;
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor =  [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"c";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    if (indexPath.row == _selectIndex) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = _normalColor;
    }
    
    if (self.dataSource.count > indexPath.row) {
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectIndex = indexPath.row;
    
    if (self.selectedBlock && self.frontCell != cell) {
        self.selectedBlock(self,indexPath.row);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    
    [_tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
