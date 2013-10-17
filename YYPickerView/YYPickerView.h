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