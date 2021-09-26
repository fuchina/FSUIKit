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

- (void)configurate:(NSString *)text textColor:(UIColor *)textColor font:(UIFont*)font {
    if (@available(iOS 15.0, *)) {
        UIListContentConfiguration *defaultContentConfiguration = self.defaultContentConfiguration;
        defaultContentConfiguration.text = text;
        if (!textColor) {
            textColor = UIColor.blackColor;
        }
        defaultContentConfiguration.textProperties.color = textColor;
        if (!font) {
            font = [UIFont systemFontOfSize:17];
        }
        defaultContentConfiguration.textProperties.font = font;
        self.contentConfiguration = defaultContentConfiguration;
    } else {
        self.textLabel.text = text;
        if (textColor) {
            self.textLabel.textColor = textColor;
        }
        if (font) {
            self.textLabel.font = font;
        }
    }
}

@end
