//
//  FSViewManager.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTapLabel.h"
#import "FSTapCell.h"
#import "PHTextView.h"

#define FS_LineThickness        0.5

@interface FSViewManager : UIView

+ (UIView *)viewWithFrame:(CGRect)frame backColor:(UIColor *)color;

+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

+ (UIView *)seprateViewWithFrame:(CGRect)frame;

+ (UIBarButtonItem *)bbiWithTitle:(NSString *)title target:(id)target action:(SEL)selector;
+ (UIBarButtonItem *)bbiWithSystemType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)selector;
+ (UISegmentedControl *)segmentedControlWithTitles:(NSArray<NSString *> *)titles target:(id)target action:(SEL)selector;

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color backColor:(UIColor *)backColor fontInt:(NSInteger)fontInt tag:(NSInteger)tag target:(id)target selector:(SEL)selector;
+ (UIButton *)submitButtonWithTop:(CGFloat)top tag:(NSInteger)tag target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)barButtonItemWithCustomButton:(UIButton *)button;
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector tintColor:(UIColor *)tintColor;

+ (UITableView *)tableViewWithFrame:(CGRect)frame delegate:(id)delegate style:(UITableViewStyle)style footerView:(UIView *)footerView;

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                  backColor:(UIColor *)backColor
                       font:(UIFont *)font
              textAlignment:(NSTextAlignment)textAlignment;

+ (UILabel *)suojinLabelWithSpace:(CGFloat)space frame:(CGRect)rect textColor:(UIColor *)textColor text:(NSString *)text;

+ (FSTapLabel *)tapLabelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                  backColor:(UIColor *)backColor
                       font:(UIFont *)font
              textAlignment:(NSTextAlignment)textAlignment
                      block:(FSTapLabelBlock)block;

+ (FSTapCell *)tapCellWithText:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
                    detailText:(NSString *)detailText
                   detailColor:(UIColor *)detailColor
                    detailFont:(UIFont *)detailFont
                         block:(TapCellBlock)block;

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)holder textColor:(UIColor *)textColor backColor:(UIColor *)backColor;

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        placeholder:(NSString *)holder
                          textColor:(UIColor *)textColor
                          onlyChars:(BOOL)only;

+ (PHTextView *)phTextViewWithFrame:(CGRect)frame placeholder:(NSString *)ph;

@end
