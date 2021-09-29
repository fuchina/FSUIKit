//
//  FSTapCell.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/21.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSTapCell.h"

@implementation FSTapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction{
    if (_block) {
        _block(self);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0.28;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 animations:^{
            self.alpha = 1;
        }];
    }];
    // Configure the view for the selected state
}

- (void)configurate:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    [self configurate:text textColor:textColor font:font detailText:nil detailFont:nil detailColor:nil];
}

- (void)configurate:(NSString *)text textColor:(UIColor *)textColor font:(UIFont*)font detailText:(NSString *)detailText detailFont:(UIFont *)detailFont detailColor:(UIColor *)detailColor {
    if (!textColor) {
        textColor = UIColor.blackColor;
    }
    if (!font) {
        font = [UIFont systemFontOfSize:17];
    }
    
    if (!detailColor) {
        detailColor = [UIColor grayColor];
    }
    
    if (!detailFont) {
        detailFont = [UIFont systemFontOfSize:13];
    }
    
    if (@available(iOS 15.0, *)) {
        UIListContentConfiguration *defaultContentConfiguration = self.defaultContentConfiguration;
        defaultContentConfiguration.text = text;
        defaultContentConfiguration.textProperties.color = textColor;
        if (detailText) {
            defaultContentConfiguration.secondaryText = detailText;
        }

        defaultContentConfiguration.secondaryTextProperties.font = detailFont;
        defaultContentConfiguration.secondaryTextProperties.color = detailColor;
        defaultContentConfiguration.textProperties.font = font;
        self.contentConfiguration = defaultContentConfiguration;
    } else {
        self.textLabel.text = text;
        self.textLabel.textColor = textColor;
        self.textLabel.font = font;
        self.detailTextLabel.font = detailFont;
        self.detailTextLabel.text = detailText;
        self.detailTextLabel.textColor = detailColor;
    }
}



@end
