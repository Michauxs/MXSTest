//
//  AYPServsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPServsCellView.h"
#import "AYCommandDefines.h"

@implementation AYPServsCellView {
	UIImageView *coverImage;
	UILabel *titleLabel;
	
	UILabel *timeLine00;
	UILabel *timeLine01;
	
	UILabel *moreTips;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
//		self.backgroundColor = [Tools randomColor];
		
		coverImage = [[UIImageView alloc]init];
		coverImage.image = IMGRESOURCE(@"default_image");
		[self addSubview:coverImage];
		[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(68, 45));
		}];
		
		titleLabel = [Tools creatLabelWithText:@"服务妈妈的主题服务" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self);
			make.top.equalTo(self).offset(5);
		}];
		
		timeLine00 = [Tools creatLabelWithText:@"周日，00:00 - 00:00" textColor:[Tools garyColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:timeLine00];
		[timeLine00 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(5);
		}];
		
		timeLine01 = [Tools creatLabelWithText:@"周一，00:00 - 00:00" textColor:[Tools garyColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:timeLine01];
		[timeLine01 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(timeLine00.mas_bottom).offset(2);
		}];
		
		moreTips = [Tools creatLabelWithText:@"点击详情" textColor:[Tools theme] fontSize:12.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:moreTips];
		[moreTips mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(timeLine00.mas_right).offset(15);
			make.centerY.equalTo(timeLine01);
		}];
	}
	return self;
}

- (void)setService_info:(NSDictionary *)service_info {
	
}

@end
