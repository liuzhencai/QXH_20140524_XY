//
//  ChatInput.m
//  ChatInput
//
//  Created by Logan Wright on 2/6/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "ChatInput.h"
#import "MyMacros.h"



#define KtextViewWidh  200
#define KSendWidh  40
#define KPicWidh  40

@interface ChatInput ()

// The main views


// Background
@property (strong, nonatomic) UIToolbar * bgToolbar;
@property (strong, nonatomic) CAGradientLayer *shadow;

@end

@implementation ChatInput {
    int currentKeyboardHeight;
    BOOL isAnimatingRotation;
    BOOL isKeyboardVisible;
}

@synthesize stopAutoClose;
@synthesize textView,sendBtn,AddBtn;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        // Set Up Main Frame
        UIInterfaceOrientation myOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(myOrientation)) {
            self.frame = CGRectMake(0, ScreenHeight() - frame.origin.y - 40 - 64 + _chatOffset, ScreenWidth(), 40);
        }
        else {
            self.frame = CGRectMake(0, ScreenWidth() - frame.origin.y - 40 - 64 + _chatOffset, ScreenHeight(), 40);
        }
        
        NSLog(@"frame:%@",[NSValue valueWithCGRect:frame]);
        
        // Other Properties
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        // Set Defaults
        _maxY = [NSNumber numberWithInt:60]; // A frame origin y of 60 will prevent further expansion
        
        // Expanding Text View
        if (!textView) textView = [[UITextView alloc]init];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textView.frame = CGRectMake(5, 6, KtextViewWidh, 28);
        textView.delegate = self;
        textView.layer.cornerRadius = 4;
        textView.font = [UIFont systemFontOfSize:16];
        textView.layer.borderWidth = .5;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.textColor = [UIColor darkTextColor];
        textView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
        [self addSubview:textView];
        
        // Send Button
        sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _sendBtnActiveColor = [UIColor colorWithRed:0.142954 green:0.60323 blue:0.862548 alpha:1];
        _sendBtnInactiveColor = [UIColor lightGrayColor];
        [self deactivateSendBtn];
        
        sendBtn.frame = CGRectMake(KtextViewWidh+15, 0, KSendWidh, 40);
        sendBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [sendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        sendBtn.userInteractionEnabled = YES;
        [self addSubview:sendBtn];
        
        
        AddBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        AddBtn.backgroundColor = [UIColor redColor];
        
//        _sendBtnActiveColor = [UIColor colorWithRed:0.142954 green:0.60323 blue:0.862548 alpha:1];
//        _sendBtnInactiveColor = [UIColor lightGrayColor];
//        [self deactivateSendBtn];
        
        AddBtn.frame = CGRectMake(KtextViewWidh+65, 0, KSendWidh, 40);
        AddBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [AddBtn setTitle:@"图片" forState:UIControlStateNormal];
        AddBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
//        [AddBtn addTarget:self action:@selector(AddPressed:) forControlEvents:UIControlEventTouchUpInside];
        AddBtn.userInteractionEnabled = YES;
        [self addSubview:AddBtn];
        
        //AddButon
//        _AddBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        
//        _sendBtnActiveColor = [UIColor colorWithRed:0.142954 green:0.60323 blue:0.862548 alpha:1];
//        _sendBtnInactiveColor = [UIColor lightGrayColor];
//        [self deactivateSendBtn];
//        
//        _sendBtn.frame = CGRectMake(self.bounds.size.width - 60, 0, 50, 40);
//        _sendBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//        [_sendBtn setTitle:@"Send" forState:UIControlStateNormal];
//        _sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
//        [_sendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        _sendBtn.userInteractionEnabled = YES;
//        [self addSubview:_sendBtn];
        
        // Background
        _bgToolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        _bgToolbar.barStyle = UIBarStyleDefault;
        _bgToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_bgToolbar belowSubview:textView];
        
        // Shadow Line
        _shadow = [CAGradientLayer layer];
        _shadow.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
        _shadow.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        _shadow.opacity = .6;
        [self.layer addSublayer:_shadow];
        
        // Get Keyboard Notes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    
    }
    
    return self;
}

#pragma mark LAYOUT SUBVIEWS

- (void) layoutSubviews {
    _bgToolbar.frame = self.bounds;
    _shadow.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
}

#pragma mark DESTROYING VIEW

- (void) removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_shadow removeFromSuperlayer];
    _shadow = nil;
    
    [_placeholderLabel removeFromSuperview];
    _placeholderLabel = nil;
    
    [textView removeFromSuperview];
    textView.text = nil;
    textView.delegate = nil;
    textView = nil;
    
    [sendBtn removeTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn removeFromSuperview];
    sendBtn = nil;
    
    [_bgToolbar removeFromSuperview];;
    _bgToolbar = nil;
    
    _delegate = nil;
    _maxY = nil;
    _maxCharacters = nil;
    _sendBtnActiveColor = nil;
    _sendBtnInactiveColor = nil;
    
    [super removeFromSuperview];
}

#pragma mark SEND MESSAGE

- (void)sendBtnPressed:(id)sender {
    
    if (textView.text.length > 0) {
        
        // start - finishes autocorrects
        _shouldIgnoreKeyboardNotifications = YES;
        [textView endEditing:YES];
        [textView setKeyboardType:UIKeyboardTypeDefault];
        [textView becomeFirstResponder];
        _shouldIgnoreKeyboardNotifications = NO; // implemented lower?
        // end - finishes autocorrects
        
        NSString * string = textView.text;
        
        [UIView animateWithDuration:.2 animations:^{
            
            // update placeholder
            _placeholderLabel.hidden = NO;
            
            // Reset Text
            textView.text = @"";
            
            // Reset Send
            [self deactivateSendBtn];
            
            // Reset Frame
            self.frame = CGRectMake(0, self.frame.origin.y + self.bounds.size.height, self.bounds.size.width, -40);
            
        } completion:^(BOOL finished) {
            
            // Resize & Alyne
            [self resizeView];
            [self alignTextViewWithAnimation:NO];
            
            // Pass Off The Message
            [_delegate chatInputNewMessageSent:string];
        }];
    }
}

- (void)AddPressed:(id)sender
{
     NSString * string = @"fanfan.jpeg";
     [_delegate chatInputPicMessageSent:string];
}


#pragma mark ACTIVATE | DEACTIVATE - SEND BTN

- (void) activateSendBtn {
    [sendBtn setTitleColor:_sendBtnActiveColor forState:UIControlStateNormal];
}

- (void) deactivateSendBtn {
    [sendBtn setTitleColor:_sendBtnInactiveColor forState:UIControlStateNormal];
}

#pragma mark OPEN | CLOSE

- (void) close {
    [textView resignFirstResponder];
}

- (void) open {
    [textView becomeFirstResponder];
}

#pragma mark TEXT VIEW DELEGATE

- (void) textViewDidBeginEditing:(UITextView *)textView {
    if (![textView.text isEqualToString:@""]) {
        _placeholderLabel.hidden = YES;
    }
    
    [self resizeView];
    [self alignTextViewWithAnimation:NO];
}

- (void) textViewDidChange:(UITextView *)textView {
    
    if (![textView.text isEqualToString:@""]) {
        _placeholderLabel.hidden = YES;
    }
    else {
        _placeholderLabel.hidden = NO;
    }
    
    [self resizeView];
    [self alignTextViewWithAnimation:NO];
}

- (void) textViewDidChangeSelection:(UITextView *)textView {
    [self resizeView];
    [self alignTextViewWithAnimation:NO];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (_maxCharacters) {
        return textView.text.length + (text.length - range.length) <= _maxCharacters.intValue;
    }
    else return YES;
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        _placeholderLabel.hidden = NO;
    }
}

#pragma mark TEXT VIEW RESIZE | ALIGN

- (void) resizeView {
    CGFloat inputStartingPoint;
    CGFloat maxHeight;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        if (isKeyboardVisible) {
            inputStartingPoint = ScreenWidth() - currentKeyboardHeight;
            
        }
        else inputStartingPoint = ScreenWidth();
    }
    else {
        if (isKeyboardVisible) {
            inputStartingPoint = ScreenHeight() - currentKeyboardHeight;
            
        }
        else inputStartingPoint = ScreenHeight();
    }
    
    if (isKeyboardVisible) maxHeight = inputStartingPoint - _maxY.intValue;
    else {
        
        // I'd rather not use constants (162, 216) but it seems to be necessary in case a hardware keyboard is active
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            int adjustment = 162; // landscape keyboard height
            maxHeight = ScreenWidth() - adjustment - _maxY.intValue;
        }
        else {
            int adjustment = 216; // portrait keyboard height
            maxHeight = ScreenHeight() - adjustment - _maxY.intValue;
        }
    }
    
    
    NSString * content = textView.text;
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:content attributes:@{ NSFontAttributeName : textView.font, NSStrokeColorAttributeName : [UIColor darkTextColor]}];
    
    CGFloat width = textView.bounds.size.width - 10; // whatever your desired width is
    // 10 less than our target because it seems to frame better
    
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat height = rect.size.height;
    
    if ([textView.text hasSuffix:@"\n"]) {
        height = height + textView.font.lineHeight;
    }
    
    int originalHeight = 30; // starting chat input height
    int offset = originalHeight - textView.font.lineHeight;
    int targetHeight = height + offset + 6; // should this be plus 12? it works with 6 but I don't know why
    // when we format the text, we use width 235.  Then we put it back onto here at 245 px.  This is then compensated here.  It seems to work.
    
    // adding this to help with rotation animations.  When target height is greater than max height, it doesn't orietn properly
    if (targetHeight > maxHeight) targetHeight = maxHeight;
    else if (targetHeight < 40) targetHeight = 40;
    
    self.frame = CGRectMake(0, inputStartingPoint -60, self.bounds.size.width, -targetHeight);
//    NSLog(@"chatInputFrame:%@",[NSValue valueWithCGRect:self.frame]);
    
    // in case they backspaced and we need to block send
    if (textView.text.length > 0) {
        [self activateSendBtn];
    }
    else {
        [self deactivateSendBtn];
    }
}

- (void) alignTextViewWithAnimation:(BOOL)shouldAnimate {
    
    // where the blinky caret is
    UITextPosition* astarte = textView.selectedTextRange.start;
    if (!astarte) {
        return;
    }
    CGRect line = [textView caretRectForPosition:astarte];
    CGFloat overflow = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top);
    
    CGPoint offsetP = textView.contentOffset;
    offsetP.y += overflow + 3; // 3 px margin
    
    if (offsetP.y >= 0) {
        if (shouldAnimate) {
            [UIView animateWithDuration:0.2 animations:^{
                [textView setContentOffset:offsetP];
            }];
        }
        else {
            [textView setContentOffset:offsetP];
        }
    }
}

#pragma mark KEYBOARD NOTIFICATIONS

- (void) keyboardWillShow:(NSNotification *)note {
    
    // Parse Keyboard Animation Details
    NSDictionary *keyboardAnimationDetail = [note userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // Get Keyboard Height
    NSValue* keyboardFrameBegin = [keyboardAnimationDetail valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    UIInterfaceOrientation myOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(myOrientation)) currentKeyboardHeight = keyboardFrameBeginRect.size.height;
    else currentKeyboardHeight = keyboardFrameBeginRect.size.width;
    // keyboard height seems to always be portrait height so, when in landscape, it returns screen size
    // width will return what we want to consider as height
    
    // because this gets called on send button & rotation due to autocorrect fix, need to catch
    if (_shouldIgnoreKeyboardNotifications != YES && isAnimatingRotation != YES) {
        
        // Keyboard Is Visible
        isKeyboardVisible = YES;
        
        UIViewAnimationOptions options = (animationCurve << 16);
        
        // working for hardware keyboard
        // UIViewAnimationOptions options = (UIViewAnimationOptions)animationCurve;
        
        [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
            [self resizeView];
        } completion:^(BOOL finished) {
            [self alignTextViewWithAnimation:YES];
        }];
    }
    else if (isAnimatingRotation == YES) {
        UIInterfaceOrientation myOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(myOrientation)) {
            self.frame = CGRectMake(0, ScreenHeight() - currentKeyboardHeight, ScreenWidth(), -self.bounds.size.height);
        }
        else {
            self.frame = CGRectMake(0, ScreenWidth() - currentKeyboardHeight, self.bounds.size.width, -self.bounds.size.height);
        }
        
        // necessary to call here in order to adjust final height
        [self resizeView];
    }
}

- (void) keyboardWillHide:(NSNotification *)note {
    
    // because this gets called on send button due to autocorrect fix
    // &&
    // during rotation animation
    if (isAnimatingRotation != YES && _shouldIgnoreKeyboardNotifications != YES) {
        isKeyboardVisible = NO;
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        
        UIViewAnimationOptions options = (animationCurve << 16);
        
        // working for hardware keyboard
        // UIViewAnimationOptions options = (UIViewAnimationOptions)animationCurve;
        
        [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
            [self resizeView];
        } completion:^(BOOL finished) {
            [self alignTextViewWithAnimation:YES];
        }];
    }
}

#pragma mark ROTATION METHODSf
/*
 
 I'm not quite sure why this area needs so much reinforcement, but it tends to animate sloppily without it.
 
 */
- (void) willRotate {
    isAnimatingRotation = YES;
}
- (void) isRotating {
    if (!isKeyboardVisible) [self resizeView];
}
- (void) didRotate {
    isAnimatingRotation = NO;
    // clean it up now that we're done!
    [self alignTextViewWithAnimation:YES];
}

#pragma mark GETTERS | SETTERS

- (void) setSendBtnActiveColor:(UIColor *)sendBtnActiveColor {
    _sendBtnActiveColor = sendBtnActiveColor;
    if (textView.text.length > 0) [sendBtn setTitleColor:sendBtnActiveColor forState:UIControlStateNormal];
}

- (void) setSendBtnInactiveColor:(UIColor *)sendBtnInactiveColor {
    _sendBtnInactiveColor = sendBtnInactiveColor;
    if (textView.text.length == 0) [sendBtn setTitleColor:sendBtnInactiveColor forState:UIControlStateNormal];
}

- (UILabel *) placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]initWithFrame:textView.frame];
        _placeholderLabel.userInteractionEnabled = NO;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
         [self insertSubview:_placeholderLabel aboveSubview:textView];
    }

    return _placeholderLabel;
}

- (NSNumber *) maxY {
    if (!_maxY) {
        _maxY = [NSNumber numberWithInt:60];
    }
    return _maxY;
}

#pragma mark HIT TESTS -- AUTO CLOSE

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.bounds, point)) {
        if (CGRectContainsPoint(textView.frame, point)) {
            [self open];
        }
        
        return YES;
    }
    else {
        if (isKeyboardVisible && !stopAutoClose && textView.text.length == 0) {
            [self close];
        }
        return NO;
    }
}

@end
