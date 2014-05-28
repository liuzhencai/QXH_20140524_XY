//
//  DataPickerView.h
//
//
//  Created by xuey on 14-5-28.
//
//

#import <UIKit/UIKit.h>

typedef void (^DatePickerBlock) (NSString *dateString);

@interface DatePickerView : UIView
@property (nonatomic, copy) DatePickerBlock datePickerBlock;
- (void)pickerShow;
@end
