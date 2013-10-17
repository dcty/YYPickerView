//
//  YYViewController.m
//  TestPickerView
//
//  Created by Ivan on 13-10-16.
//  Copyright (c) 2013年 灵感方舟. All rights reserved.
//

#import "YYViewController.h"
#import "YYDatePicker.h"
#import "UIView+YY.h"
#import "YYAvatarView.h"

@interface YYViewController () <YYPickerViewDataSource, YYPickerViewDelegate>

@end

@implementation YYViewController

- (void)loadView
{
	[super loadView];
	YYDatePicker *datePicker = [YYDatePicker datePicker:CGRectMake(0, 0, 320, 216)];
	[self.view addSubview:datePicker];

	YYPickerView *pickerView = [YYPickerView pickerView:CGRectMake(0, datePicker.bottom + 5, 320, 216)];
	pickerView.delegate		= self;
	pickerView.dataSource	= self;
	[self.view addSubview:pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(YYPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(YYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return component == 0 ? 10 : 20;
}

- (NSString *)pickerView:(YYPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"comp:%d:row:%d", component, row];
}

- (UIView *)pickerView:(YYPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view adviceWidth:(CGFloat)width
{
	if (component == 1) {
		YYAvatarView *avatarView = (YYAvatarView *)view;

		if (!avatarView) {
			avatarView = [[YYAvatarView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
			avatarView.avatarImageView.image = [UIImage imageNamed:@"avatar"];
		}

		avatarView.nameLabel.text = [NSString stringWithFormat:@"comp:%d:row:%d", component, row];
		return avatarView;
	} else {
		return nil;
	}
}

- (void)pickerView:(YYPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelectRow:%d inComponent:%d",row,component);
}

@end

