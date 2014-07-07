//
//  DataPickerView.h
//
//
//  Created by xuey on 14-5-28.
//
//

#import <UIKit/UIKit.h>

#define DATE_STRING @"dateString"
#define DATE  @"date"
typedef void (^DatePickerBlock) (NSDictionary *dateDict);

@interface DatePickerView : UIView
@property (nonatomic, copy) DatePickerBlock datePickerBlock;
- (void)pickerShow;
@end
