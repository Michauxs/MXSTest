//
//  InfoCell.m
//  tableViewCellHeightAnimation
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "InfoCell.h"

@interface InfoCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak)   Model    *model;
@property (nonatomic, strong) UIView   *lineView;
@property (nonatomic, strong) UILabel  *infoLabel;

@end

@implementation InfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [self.button addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, 320, 0.5f)];
    self.lineView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    [self addSubview:self.lineView];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
    self.infoLabel.text = @"Demo";
    [self addSubview:self.infoLabel];
}

- (void)buttonEvent {
    
    if (self.model.expend == YES) {
        self.model.expend = NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self normalStateWithAnimated:YES];
        
    } else {
        self.model.expend = YES;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self expendStateWithAnimated:YES];
    }
}

- (void)loadData:(id)data {
    self.model = data;
    if (self.model.expend == YES) {
        self.lineView.frame  = CGRectMake(0, 99.5f, 320, 0.5f);
        self.infoLabel.frame = CGRectMake(30, 0, 100, 50);
        
    } else {
        self.lineView.frame  = CGRectMake(0, 49.5, 320, 0.5f);
        self.infoLabel.frame = CGRectMake(10, 0, 100, 50);
    }
}

- (void)normalStateWithAnimated:(BOOL)animated {
    if (animated == YES) {
        [UIView animateWithDuration:0.35f animations:^{
            self.lineView.frame  = CGRectMake(0, 49.5, 320, 0.5f);
            self.infoLabel.frame = CGRectMake(10, 0, 100, 50);
        }];
        
    } else {
        self.lineView.frame  = CGRectMake(0, 49.5, 320, 0.5f);
        self.infoLabel.frame = CGRectMake(10, 0, 100, 50);
    }
}

- (void)expendStateWithAnimated:(BOOL)animated {
    if (animated == YES) {
        [UIView animateWithDuration:0.35f animations:^{
            self.lineView.frame  = CGRectMake(0, 99.5f, 320, 0.5f);
            self.infoLabel.frame = CGRectMake(30, 0, 100, 50);
        }];
        
    } else {
        self.lineView.frame  = CGRectMake(0, 99.5f, 320, 0.5f);
        self.infoLabel.frame = CGRectMake(30, 0, 100, 50);
    }
}

@end
