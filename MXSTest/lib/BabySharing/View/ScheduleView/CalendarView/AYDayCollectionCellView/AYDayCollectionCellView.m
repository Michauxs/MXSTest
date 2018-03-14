//
//  AYDayCollectionCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYDayCollectionCellView.h"
#import "Tools.h"

@interface AYDayCollectionCellView ()
@property (strong, nonatomic) UILabel *gregoiainDaylabel;
@property (strong, nonatomic) UILabel *lunarDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayDateLabel;

@end

@implementation AYDayCollectionCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _dayDateLabel.textColor = [Tools black];
    self.backgroundColor = [UIColor clearColor];
}

-(void)setGregoiainDay:(NSString *)gregoiainDay {
    
    _gregoiainDay = gregoiainDay;
    _dayDay = gregoiainDay;
//    self.gregoiainDaylabel.text = gregoiainDay;
    
    self.dayDateLabel.text = gregoiainDay;
    self.dayDateLabel.textColor = [Tools black];
    if (self.isGone) {
        self.dayDateLabel.textColor = [Tools lightGaryColor];
    }
}

- (void)setIsLightColor:(BOOL)isLightColor {
	_isLightColor = isLightColor;
	if (isLightColor) {
		self.dayDateLabel.textColor = [Tools theme];
	} else {
		self.dayDateLabel.textColor = [Tools black];
	}
}

//-(void)setLunarDay:(NSString *)lunarDay {
//    _lunarDay = lunarDay;
//    self.lunarDayLabel.text = lunarDay;
//}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AYDayCollectionCellView" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if(arrayOfViews.count < 1){
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

@end
