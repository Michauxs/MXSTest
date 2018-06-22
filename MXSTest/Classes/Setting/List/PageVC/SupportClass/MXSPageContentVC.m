//
//  MXSPageContentVC.m
//  MXSTest
//
//  Created by Sunfei on 2018/6/21.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSPageContentVC.h"

@interface MXSPageContentVC ()

@end

@implementation MXSPageContentVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.NavBar.titleLabel.text = @"PageContentView";
    
    self.view.backgroundColor = [Tools randomColor];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_NAV_HEIGHT, self.view.bounds.size.width, 100)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.backgroundColor = [Tools randomColor];
    [self.view addSubview:_contentLabel];
}

- (void) viewWillAppear:(BOOL)paramAnimated{
    [super viewWillAppear:paramAnimated];
    _contentLabel.text = _content;
}

@end
