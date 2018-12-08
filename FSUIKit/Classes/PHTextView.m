//
//  PHTextView.m
//  Daiyida
//
//  Created by fudon on 15/1/30.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import "PHTextView.h"

@interface PHTextView ()<UITextViewDelegate>

@property (nonatomic, copy) NSString* tmpText;

@end

@implementation PHTextView

#pragma mark -
#pragma mark Initialisation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerNotification];
        _contentTextColor = [UIColor blackColor];
    }
    return self;
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditingCustom:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingCustom:) name:UITextViewTextDidEndEditingNotification object:self];
}

#pragma mark -
#pragma mark Setter/Getters
- (NSString *)text{
    if (self.tmpText) {
        return @"";
    }
    else
        return super.text;
}
- (void)setContentText:(NSString *)contentText
{
    self.tmpText = nil;
    self.text = contentText;
    self.textColor = _contentTextColor;
}
- (NSString *)contentText{
    if (self.tmpText) {
        return nil;
    }
    return self.text;
}
- (void) setPlaceholder:(NSString *)aPlaceholder
{
    _placeholder = aPlaceholder;
    self.tmpText = _placeholder;
    self.text = self.tmpText;
    self.textColor = [UIColor lightGrayColor];

}

- (void)beginEditingCustom:(NSNotification *)notification
{
    if (self.tmpText) {
        self.tmpText = nil;
        self.text = nil;
        self.textColor = _contentTextColor;
    }
    else
    {
        if (self.text) {
            self.textColor = _contentTextColor;
        }
        else
        {
            self.tmpText = _placeholder;
            self.text = self.tmpText;
            self.textColor = [UIColor lightGrayColor];
        }
    }
}
- (void)endEditingCustom:(NSNotification*)notification
{
    if (self.text.length == 0) {
        self.tmpText = _placeholder;
        self.text = self.tmpText;
        self.textColor = [UIColor lightGrayColor];
    }
    else
        self.textColor = _contentTextColor;
    
}


#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
