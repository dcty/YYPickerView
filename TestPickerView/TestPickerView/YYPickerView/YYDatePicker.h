//
// Created by ivan on 13-7-26.
//
//


#import <Foundation/Foundation.h>
#import "YYPickerView.h"

@class YYDatePicker;

typedef void(^DateSelectedRowDidChangedBlock)(YYDatePicker *pickerView, int row, int component);

/**
*   只实现项目需求的样式，并且不处理无限循环滚动
*/
@interface YYDatePicker : YYPickerView
@property(nonatomic) int minYear;
@property(nonatomic) int maxYear;
@property(strong, nonatomic) NSDate *date;
@property(copy, nonatomic) DateSelectedRowDidChangedBlock selectedRowChanged;

/**
*   看起来貌似是要写单例的样子，其实不是
*/
+ (id)datePicker:(CGRect)rect;

@end