YYPickerView
=
***
>
>iOS7升级后，有好几个人问我，怎么日期选择控件变成了一片透明 
 
>刚好我在几个月前写了一个自定义的PickerView，勉强能用，就开源出来吧。  

>接口基本是仿UIPickerView写的，不过因为项目需求，只实现了部分。

>YYDatePicker就是继承YYPickerView写的一个自定义UIDatePicker


<img src='screenshot.png'>
--
<pre>
//
// Created by ivan on 13-7-25.
//
//


#import <Foundation/Foundation.h>

@protocol YYPickerViewDelegate;
@protocol YYPickerViewDataSource;


@interface YYPickerView : UIView

@property(weak, nonatomic) id <YYPickerViewDelegate> delegate;
@property(weak, nonatomic) id <YYPickerViewDataSource> dataSource;
@property(nonatomic, readonly) NSInteger numberOfComponents;
@property(nonatomic) BOOL soundDisable;

+ (id)pickerView:(CGRect)rect;

- (NSInteger)numberOfRowsInComponent:(NSInteger)component;

- (CGSize)rowSizeForComponent:(NSInteger)component;

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)reloadAllComponents;

- (void)reloadComponent:(NSInteger)component;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated callDelegate:(BOOL)flag;

- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end

@protocol YYPickerViewDataSource <NSObject>
@required

- (NSInteger)numberOfComponentsInPickerView:(YYPickerView *)pickerView;

- (NSInteger)pickerView:(YYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end


@protocol YYPickerViewDelegate <NSObject>
@optional

- (CGFloat)pickerView:(YYPickerView *)pickerView widthForComponent:(NSInteger)component;

- (CGFloat)pickerView:(YYPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (NSString *)pickerView:(YYPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (UIView *)pickerView:(YYPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (UIView *)pickerView:(YYPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view adviceWidth:(CGFloat)width;

- (void)pickerView:(YYPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
</pre>
--