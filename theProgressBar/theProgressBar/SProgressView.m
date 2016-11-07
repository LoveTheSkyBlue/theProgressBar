//
//  AboutProgressBar.m
//  AboutProgressBar
//
//  Created by 曾绍鹏 on 2016/11/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SProgressView.h"

@interface SProgressView ()
@property (nonatomic, strong) UIView *progressBar;
@end

@implementation SProgressView

- (void)setProgress:(float)progress {
	_progress = (progress < 0) ? 0 :
				(progress > 1) ? 1 :
				progress;

	CGRect slice, remainder;
	CGRectDivide(self.bounds, &slice, &remainder, CGRectGetWidth(self.bounds) * _progress, CGRectMinXEdge);

	if (!CGRectEqualToRect(self.progressBar.frame, slice)) {
		self.progressBar.frame = slice;
	}
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.frame = frame;
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
		self.progressBar = [[UIView alloc] init];
		self.progressBar.backgroundColor = [UIColor greenColor];
		self.progress = 0;
		[self addSubview:self.progressBar];
	}
	return self;
}

- (void)setFrame:(CGRect)frame
{
	// 0.5 pt doesn't work well with autoresizingMask.
	frame.origin.y = ceilf(frame.origin.y);
	frame.size.height = floorf(frame.size.height);
	[super setFrame:frame];

	__weak typeof(self)weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		weakSelf.progress = weakSelf.progress;
	});
}

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	self.progressBar.backgroundColor = tintColor;
}

@end
