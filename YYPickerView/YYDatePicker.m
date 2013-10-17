//
// Created by ivan on 13-7-26.
//
//


#import "YYDatePicker.h"

@interface YYDatePicker () <YYPickerViewDataSource, YYPickerViewDelegate>
@property(strong, nonatomic) NSMutableArray *lists;
@end

@implementation YYDatePicker
@synthesize maxYear = _maxYear;
@synthesize minYear = _minYear;
@synthesize date = _date;

- (void)setDate:(NSDate *)date
{
    _date = date;
    if (date)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self selectRow:components.year - self.minYear inComponent:0 animated:YES callDelegate:NO];
            [self selectRow:components.month - 1 inComponent:1 animated:YES callDelegate:NO];
            [self selectRow:components.day - 1 inComponent:2 animated:YES callDelegate:YES];
        });
    }
    else
    {
        self.date = [NSDate date];
    }
}

- (NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    components.year = [self selectedRowInComponent:0] + self.minYear;
    components.month = [self selectedRowInComponent:1] + 1;
    components.day = [self selectedRowInComponent:2] + 1;
    return [calendar dateFromComponents:components];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return dateFormatter;
}

+ (id)datePicker:(CGRect)rect
{
    YYDatePicker *yyDatePicker = [YYDatePicker pickerView:rect];
    yyDatePicker.delegate = yyDatePicker;
    yyDatePicker.dataSource = yyDatePicker;
    [yyDatePicker initList];
    return yyDatePicker;
}

- (void)initList
{
    self.lists = [[NSMutableArray alloc] init];
    NSMutableArray *list0 = [[NSMutableArray alloc] init];
    for (int i = self.minYear; i <= self.maxYear; i++)
    {
        [list0 addObject:[NSString stringWithFormat:@"%d年", i]];
    }
    [_lists addObject:list0];
    NSMutableArray *list1 = [[NSMutableArray alloc] init];
    for (int j = 1; j <= 12; j++)
    {
        [list1 addObject:[NSString stringWithFormat:@"%d月", j]];
    }
    [_lists addObject:list1];
    NSMutableArray *list2 = [[NSMutableArray alloc] init];
    for (int k = 1; k <= 31; k++)
    {
        [list2 addObject:[NSString stringWithFormat:@"%d日", k]];
    }
    [_lists addObject:list2];
    self.date = nil;
}

- (NSInteger)numberOfComponentsInPickerView:(YYPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(YYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.maxYear - self.minYear + 1;
    }
    else if (component == 1)
    {
        return 12;
    }
    else if (component == 2)
    {
        int year = [self selectedRowInComponent:0] + self.minYear;
        int month = [self selectedRowInComponent:1] + 1;
        return [self daysInMonth:month onYear:year];
    }
    return 0;
}


- (NSString *)pickerView:(YYPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _lists[component][row];
}

- (void)pickerView:(YYPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0 || component == 1)
    {
        [self reloadComponent:2];
        int selectedRow0 = [self selectedRowInComponent:0];
        int selectedRow1 = [self selectedRowInComponent:1];
        int selectedRow2 = [self selectedRowInComponent:2];
        int year = _minYear + selectedRow0;
        int month = selectedRow1 + 1;
        int day = selectedRow2 + 1;
        int row = selectedRow2;
        int days = [self daysInMonth:month onYear:YES];
        if (day > days)
        {
            row = days - 1;
        }
        [self selectRow:row inComponent:2 animated:NO callDelegate:NO];
    }
    if (_selectedRowChanged)
    {
        _selectedRowChanged(self,row,component);
    }

}


- (int)maxYear
{
    return _maxYear ? _maxYear : 2100;
}

- (int)minYear
{
    return _minYear ? _minYear : 1900;
}

- (void)setMinYear:(int)minYear
{
    _minYear = minYear;
    [self initList];
}

- (void)setMaxYear:(int)maxYear
{
    _maxYear = maxYear;
    [self initList];
}

- (int)daysInMonth:(int)month onYear:(int)year
{
    if (month == 4 || month == 6 || month == 9 || month == 11)
    {
        return 30;
    }
    else if (month == 2)
    {
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
        {
            return 29;
        }
        else
        {
            return 28;
        }
    }
    else
    {
        return 31;
    }
}

@end