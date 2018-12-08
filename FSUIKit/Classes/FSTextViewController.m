//
//  FSTextViewController.m
//  myhome
//
//  Created by FudonFuchina on 2017/8/15.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSTextViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIViewExt.h"
#import "FuSoft.h"

@interface FSTextViewController ()

@property (nonatomic,strong) UITextView     *textView;

@end

@implementation FSTextViewController{
    BOOL    _canPop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textDeisgnViews];
}

- (void)doneAction{
    if (self.callback) {
        self.callback(self, _textView.text);
    }
}

- (void)textDeisgnViews{
    self.title = self.title?:(_text?NSLocalizedString(@"Please edit", nil):NSLocalizedString(@"Please fill in", nil));
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Confirm", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = bbi;
    [self addKeyboardNotificationWithBaseOn:0];

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64 + (HEIGHTFC > 800?24:0), WIDTHFC, 0)];
    _textView.font = FONTFC(16);
    _textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_textView];
    if (_text) {
        _textView.text = _text;
    }

    [_textView becomeFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_canPop = YES;
    });
}

- (void)keybaordActionInPropertyBase:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _textView.height = HEIGHTFC - 64 - keyboardSize.height;
}

- (BOOL)navigationShouldPopOnBackButton{
    if (_canPop) {
        return YES;
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
