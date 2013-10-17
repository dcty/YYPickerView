//
//  YYAvatarView.m
//  TestPickerView
//
//  Created by Ivan on 13-10-17.
//  Copyright (c) 2013年 灵感方舟. All rights reserved.
//

#import "YYAvatarView.h"
#import "UIView+YY.h"
#import <QuartzCore/QuartzCore.h>

@implementation YYAvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:_avatarImageView];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, frame.size.width,20)];
        _nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _nameLabel.font = [UIFont systemFontOfSize:14];
//        [self addSubview:_nameLabel];
    }
    return self;
}


@end
