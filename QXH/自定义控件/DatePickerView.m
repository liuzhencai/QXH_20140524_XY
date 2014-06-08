//
//  DataPickerView.m
//  
//
//  Created by xuey on 14-5-28.
//
//

#import "DatePickerView.h"

@interface DatePickerView ()
@property (nonatomic, strong) NSDate *selectDate;
@end

@implementation DatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT, UI_SCREEN_WIDTH, 260);
        self.backgroundColor = [UIColor whiteColor];
        self.selectDate = [NSDate date];
        UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        [self addSubview:bar];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//        datePicker.minuteInterval = 5;
        datePicker.minimumDate = [NSDate date];
        
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
        
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
        UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmPickView)];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerHide)];
        [items addObject:cancelBtn];
        [items addObject:flexibleSpaceItem];
        [items addObject:confirmBtn];
        bar.items = items;
    }
    return self;
}

- (void)confirmPickView{
    if (self.datePickerBlock) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:self.selectDate];
        
        self.datePickerBlock(dateStr);
    }
    [self pickerHide];
}

- (void)dateChanged:(UIDatePicker *)datePicker{
    self.selectDate = datePicker.date;
}

- (void)pickerShow
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - 260, self.frame.size.width, self.frame.size.height);
    }];
    
}
- (void)pickerHide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, UI_SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    }];
}


@end
