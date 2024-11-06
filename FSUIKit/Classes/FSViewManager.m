//
//  FSViewManager.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSViewManager.h"

@implementation FSViewManager

+ (UIView *)viewWithFrame:(CGRect)frame backColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if (color) {
        view.backgroundColor = color;
    }
    return view;
}

+ (UIView *)seprateViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    CGFloat rgb = 230 / 255.0;
    view.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
    return view;
}

+ (UIBarButtonItem *)bbiWithTitle:(NSString *)title target:(id)target action:(SEL)selector
{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    return bbi;
}

+ (UIBarButtonItem *)bbiWithSystemType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)selector
{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:selector];
    return bbi;
}

+ (UISegmentedControl *)segmentedControlWithTitles:(NSArray<NSString *> *)titles target:(id)target action:(SEL)selector
{
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:titles];
    [control addTarget:target action:selector forControlEvents:UIControlEventValueChanged];
    return control;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color backColor:(UIColor *)backColor font:(UIFont *)font tag:(NSInteger)tag target:(id)target selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (backColor) {
        button.backgroundColor = backColor;
    }
    if (target && selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    if (font) {
        button.titleLabel.font =  font;
    }
    if (tag) {
        button.tag = tag;
    }
    button.layer.cornerRadius = 3;
    return button;
}

+ (UIButton *)submitButtonWithTop:(CGFloat)top tag:(NSInteger)tag target:(id)target selector:(SEL)selector {
    UIColor *color = [UIColor colorWithRed:18/255.0 green:152/255.0 blue:233/255.0 alpha:1];
    UIButton *button = [self buttonWithFrame:CGRectMake(20, top, UIScreen.mainScreen.bounds.size.width - 40, 44) title:@"提交" titleColor:[UIColor whiteColor] backColor:color font:nil tag:tag target:target selector:selector];
    button.layer.cornerRadius = 3;
    return button;
}

+ (UIBarButtonItem *)barButtonItemWithCustomButton:(UIButton *)button
{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:button];
    return bbi;
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector tintColor:(UIColor *)tintColor
{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    if (tintColor) {
        bbi.tintColor = tintColor;
    }
    return bbi;
}

+ (UITableView *)tableViewWithFrame:(CGRect)frame delegate:(id)delegate style:(UITableViewStyle)style footerView:(UIView *)footerView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    if (footerView) {
        tableView.tableFooterView = footerView;
    }
    return tableView;
}

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                  backColor:(UIColor *)backColor
                       font:(UIFont *)font
              textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (backColor) {
        label.backgroundColor = backColor;
    }
    if (font) {
        label.font = font;
    }
    label.textAlignment = textAlignment;
    return label;
}

+ (UILabel *)suojinLabelWithSpace:(CGFloat)space frame:(CGRect)rect textColor:(UIColor *)textColor text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text?text:@""];
    if ([textColor isKindOfClass:UIColor.class]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attributedString.length)];
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //    style.headIndent = MAX(space, 0);//整体缩进
    style.firstLineHeadIndent = space;  // 首行缩进
    //    style.lineSpacing = 10;//行距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.length)];
    label.attributedText = attributedString;
    return label;
}

+ (FSTapLabel *)tapLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                     backColor:(UIColor *)backColor
                          font:(UIFont *)font
                 textAlignment:(NSTextAlignment)textAlignment
                         block:(FSTapLabelBlock)block
{
    FSTapLabel *label = [[FSTapLabel alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (backColor) {
        label.backgroundColor = backColor;
    }
    if (font) {
        label.font = font;
    }
    if (block) {
        label.block = block;
    }
    label.textAlignment = textAlignment;
    return label;
}

+ (FSTapCell *)tapCellWithText:(NSString *)text
                      textColor:(UIColor *)textColor
                          font:(UIFont *)font
                    detailText:(NSString *)detailText
                   detailColor:(UIColor *)detailColor
                    detailFont:(UIFont *)detailFont
                          block:(TapCellBlock)block {
    return [self tapCellWithText: text textColor: textColor font: font detailText: detailText detailColor: detailColor detailFont: detailFont frame: CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44) block: block];
}

+ (FSTapCell *)tapCellWithText:(NSString *)text
                      textColor:(UIColor *)textColor
                          font:(UIFont *)font
                    detailText:(NSString *)detailText
                   detailColor:(UIColor *)detailColor
                    detailFont:(UIFont *)detailFont
                         frame:(CGRect)frame
                          block:(TapCellBlock)block {
    FSTapCell *cell = [[FSTapCell alloc] initWithFrame: frame];
    if (text) {
        cell.textLabel.text = text;
    }
    if (textColor) {
        cell.textLabel.textColor = textColor;
    }
    if (font) {
        cell.textLabel.font = font;
    }
    if (detailText) {
        cell.detailTextLabel.text = detailText;
    }
    if (detailColor) {
        cell.detailTextLabel.textColor = detailColor;
    }
    if (detailFont) {
        cell.detailTextLabel.font = detailFont;
    }
    if (block) {
        cell.click = block;
    }
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, UIScreen.mainScreen.bounds.size.width, cell.frame.size.height);
    return cell;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)holder textColor:(UIColor *)textColor backColor:(UIColor *)backColor {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (holder) {
        textField.placeholder = holder;
    }
    if (textColor) {
        textField.textColor = textColor;
    }
    if (backColor) {
        textField.backgroundColor = backColor;
    }
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)holder textColor:(UIColor *)textColor onlyChars:(BOOL)only
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (holder) {
        textField.placeholder = holder;
    }
    if (textColor) {
        textField.textColor = textColor;
    }
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if (only) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return textField;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            imageView.image = image;
        }
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
