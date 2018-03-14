//
//  AYSetServicePriceController.m
//  BabySharing
//
//  Created by Alfred Yang on 10/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetServicePriceController.h"
#import "AYFacadeBase.h"

#import "AYServicePriceCatBtn.h"
#import "AYShadowRadiusView.h"
#import "AYSetPriceInputView.h"

#define kInputGroupHeight			80
#define kScreenMarginBottom			45
#define SEG_MIN_Y					SCREEN_HEIGHT*(kStatusAndNavBarH+90)/667
#define SEG_CONT_MARGIN_TOP			(SEG_MIN_Y+40+15)

@implementation AYSetServicePriceController {
	
	NSMutableDictionary *push_service_info;
	
	UILabel *titleLabel;
	UIView *shadowView;
	
	AYServicePriceCatBtn *handleBtn;
	NSMutableArray *priceCatBtnArr;
	NSMutableArray *radiusViewArr;
	NSMutableArray *inputViewArr;
	
	AYSetPriceInputView *timesPriceInput;
	AYSetPriceInputView *stagePriceInput;
	AYSetPriceInputView *timesCountInput;
	
	BOOL isAlreadyEnable;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.clipsToBounds = YES;
	
	CGFloat marginScreen = 40.f;
	CGFloat itemBtnHeight = 40;
	
	titleLabel = [Tools creatLabelWithText:@"价格设定" textColor:[Tools black] fontSize:630.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(marginScreen);
		make.top.equalTo(self.view).offset(kStatusAndNavBarH+20);
	}];
	
	priceCatBtnArr = [NSMutableArray array];
	radiusViewArr = [NSMutableArray array];
	
	CGFloat segWidth = SCREEN_WIDTH - marginScreen*2;
	int itemCount = 0;
	NSArray *itemTitles;
	NSArray *itemTips;
	NSString *catStr = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	NSArray *info_price_arr = [[push_service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsPriceArr];
	
	if ([catStr isEqualToString:kAYStringCourse]) {
		itemCount = 2;
		itemTitles = @[@"单次", @"学期"];
		itemTips = @[@"次", @"学期"];
		CGFloat itemBtnWith = segWidth / itemCount;
		
		for (int i = 0; i < itemCount; ++i) {
			
			AYServicePriceCatBtn *btn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(marginScreen+itemBtnWith*i, SEG_MIN_Y, itemBtnWith, itemBtnHeight) andTitle:[itemTitles objectAtIndex:i]];
			btn.tag = i;
			[self.view addSubview:btn];
			btn.selected = i == 0;
			[btn addTarget:self action:@selector(didCatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			[priceCatBtnArr addObject:btn];
			
			UIView *radiusBG= [[UIView alloc] init];
			[self.view addSubview:radiusBG];
			[radiusBG mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(i==0?0:SCREEN_WIDTH);
				make.width.mas_equalTo(segWidth);
				make.top.equalTo(self.view).offset(SEG_MIN_Y+itemBtnHeight+15);
				make.bottom.equalTo(self.view).offset(-45);
			}];
			[radiusViewArr addObject:radiusBG];
			
			AYShadowRadiusView *radiusView= [[AYShadowRadiusView alloc] initWithRadius:4.f];
			[radiusBG addSubview:radiusView];
			if (i==0) {
				[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.edges.equalTo(radiusBG);
				}];
				timesPriceInput = [[AYSetPriceInputView alloc] initWithSign:[NSString stringWithFormat:@"／%@",[itemTips objectAtIndex:i]]];
				timesPriceInput.inputField.delegate = self;
				[radiusView addSubview:timesPriceInput];
				[timesPriceInput mas_makeConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(radiusView).offset(90);
					make.centerX.equalTo(radiusView);
					make.size.mas_equalTo(CGSizeMake(segWidth - marginScreen*2, kInputGroupHeight));
				}];
				[self setInputViewTitle:timesPriceInput andPriceNumb:[self predPriceWithType:AYPriceTypeTimes inPriceArr:info_price_arr]];
				
			} else {
				[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.centerX.equalTo(radiusBG);
					make.width.mas_equalTo(segWidth);
					make.top.equalTo(radiusBG);
					make.bottom.equalTo(radiusBG.mas_centerY).offset(-5);
				}];
				stagePriceInput = [[AYSetPriceInputView alloc] initWithSign:[NSString stringWithFormat:@"／%@",[itemTips objectAtIndex:i]]];
				stagePriceInput.inputField.delegate = self;
				[radiusView addSubview:stagePriceInput];
				[stagePriceInput mas_makeConstraints:^(MASConstraintMaker *make) {
					make.centerY.equalTo(radiusView);
					make.centerX.equalTo(radiusView);
					make.size.mas_equalTo(CGSizeMake(segWidth - marginScreen*2, kInputGroupHeight));
				}];
				[self setInputViewTitle:stagePriceInput andPriceNumb:[self predPriceWithType:AYPriceTypeStage inPriceArr:info_price_arr]];
				
				AYShadowRadiusView *countRadiusView= [[AYShadowRadiusView alloc] initWithRadius:4.f];
				[radiusBG addSubview:countRadiusView];
				[countRadiusView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(radiusBG.mas_centerY).offset(5);
					make.centerX.equalTo(radiusBG);
					make.bottom.equalTo(radiusBG);
					make.width.mas_equalTo(segWidth);
				}];
				timesCountInput = [[AYSetPriceInputView alloc] initWithSign:@"阶段授课次数"];
				timesCountInput.inputField.delegate = self;
				[countRadiusView addSubview:timesCountInput];
				[timesCountInput mas_makeConstraints:^(MASConstraintMaker *make) {
					make.centerY.equalTo(countRadiusView);
					make.centerX.equalTo(countRadiusView);
					make.size.equalTo(stagePriceInput);
				}];
				
				NSNumber *count = [[push_service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsClassCount];
				if (count) {
					timesCountInput.inputField.text = count.stringValue;
				}
			}
			
			UILabel *tipLabel = [Tools creatLabelWithText:[NSString stringWithFormat:@"设置%@价格该服务可按%@预定", [itemTitles objectAtIndex:i], [itemTips objectAtIndex:i]] textColor:[Tools garyColor] fontSize:311 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
			[radiusView addSubview:tipLabel];
			[tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(radiusView.mas_bottom).offset(-10);
				make.centerX.equalTo(radiusView);
			}];
		}
		
	} else if([catStr isEqualToString:kAYStringNursery]) {
		itemCount = 3;
		itemTitles = @[@"时托", @"日托", @"月托"];
		itemTips = @[@"小时", @"天", @"月"];
//		itemTips = @[@"设置时托价格该服务可按小时预定", @"设置日托价格该服务可按日预定", @"设置月托价格该服务可按月预定"];
		CGFloat itemBtnWith = segWidth / itemCount;
		
		inputViewArr = [NSMutableArray array];
		
		for (int i = 0; i < itemCount; ++i) {
			
			AYServicePriceCatBtn *btn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(marginScreen+itemBtnWith*i, SEG_MIN_Y, itemBtnWith, itemBtnHeight) andTitle:[itemTitles objectAtIndex:i]];
			btn.tag = i;
			[self.view addSubview:btn];
			btn.selected = i == 0;
			[btn addTarget:self action:@selector(didCatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			[priceCatBtnArr addObject:btn];
			
			AYShadowRadiusView *radiusView= [[AYShadowRadiusView alloc] initWithRadius:4.f];
			[self.view addSubview:radiusView];
			[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(i==0?0:SCREEN_WIDTH);
				make.width.mas_equalTo(segWidth);
				make.top.equalTo(self.view).offset(SEG_MIN_Y+itemBtnHeight+15);
				make.bottom.equalTo(self.view).offset(-45);
			}];
			[radiusViewArr addObject:radiusView];
			
			AYSetPriceInputView *inputView = [[AYSetPriceInputView alloc] initWithSign:[NSString stringWithFormat:@"／%@",[itemTips objectAtIndex:i]]];
			inputView.inputField.delegate = self;
			[radiusView addSubview:inputView];
			[inputView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(radiusView).offset(90);
				make.centerX.equalTo(radiusView);
				make.size.mas_equalTo(CGSizeMake(segWidth - marginScreen*2, 80));
			}];
			[inputViewArr addObject:inputView];
			
			[self setInputViewTitle:inputView andPriceNumb:[self predPriceWithType:i inPriceArr:info_price_arr]];
			
			UILabel *tipLabel = [Tools creatLabelWithText:[NSString stringWithFormat:@"设置%@价格该服务可按%@预定", [itemTitles objectAtIndex:i], [itemTips objectAtIndex:i]] textColor:[Tools garyColor] fontSize:311 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
			[radiusView addSubview:tipLabel];
			[tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(radiusView.mas_bottom).offset(-10);
				make.centerX.equalTo(radiusView);
			}];
		}
		
	} else {
		
	}
	[[priceCatBtnArr objectAtIndex:0] setSelected:YES];
	handleBtn = [priceCatBtnArr objectAtIndex:0];
	
	shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SEG_MIN_Y+itemBtnHeight)];
	shadowView.backgroundColor = [Tools whiteColor];
	[self.view addSubview:shadowView];
	shadowView.layer.shadowColor = [Tools garyColor].CGColor;
	shadowView.layer.shadowRadius = 5.f;
	shadowView.layer.shadowOpacity = 0.5f;
	shadowView.layer.shadowOffset = CGSizeMake(0, 2);
	shadowView.hidden = YES;
	
	[self.view bringSubviewToFront:titleLabel];
	for (AYServicePriceCatBtn *btn in priceCatBtnArr) {
		[self.view bringSubviewToFront:btn];
	}
	
	self.view.userInteractionEnabled = YES;
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapElse)]];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	//	NSString *title = @"服务类型";
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

#pragma mark -- actions
- (void)setNavRightBtnEnableStatus {
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}

- (void)setInputViewTitle:(AYSetPriceInputView*)inputView andPriceNumb:(NSNumber*)p {
	if (p) {
		inputView.inputField.text = [NSString stringWithFormat:@"¥%d", p.intValue/100];
	}
}

- (NSNumber*)predPriceWithType:(AYPriceType)type inPriceArr:(NSArray*)priceArr {
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.%@=%d", kAYServiceArgsPriceType, type];
	NSArray *result = [priceArr filteredArrayUsingPredicate:pred];
	if (result.count == 1) {
		return [[result firstObject] objectForKey:kAYServiceArgsPrice];
	} else {
		return nil;
	}
}

- (void)didTapElse {
	[self.view endEditing:YES];
}

- (void)didCatBtnClick:(AYServicePriceCatBtn*)btn {
	
	if (handleBtn == btn) {
		return;
	}
	
	CGFloat duration = 0;
	NSInteger currentIndex = handleBtn.tag;
	for (AYSetPriceInputView *inView in inputViewArr) {
		if ([inView.inputField isFirstResponder]) {
			duration = 0.25;
			[inView.inputField resignFirstResponder];
			break;
		}
	}
	if ([timesPriceInput.inputField isFirstResponder] || [stagePriceInput.inputField isFirstResponder] || [timesCountInput.inputField isFirstResponder]) {
		duration = 0.25;
		[timesPriceInput.inputField resignFirstResponder];
		[stagePriceInput.inputField resignFirstResponder];
		[timesCountInput.inputField resignFirstResponder];
	}
//	[[[inputViewArr objectAtIndex:currentIndex] inputField] resignFirstResponder];
	
	handleBtn.selected = NO;
	btn.selected = !btn.selected;
	NSInteger changeIndex = btn.tag;
	handleBtn = btn;
	
	AYShadowRadiusView *currentView = [radiusViewArr objectAtIndex:currentIndex];
	AYShadowRadiusView *changeView = [radiusViewArr objectAtIndex:changeIndex];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		NSInteger comp = changeIndex - currentIndex;
		if (comp > 0) {
			[UIView animateWithDuration:0.25 animations:^{
				//			currentView.center = CGPointMake(self.view.center.x - SCREEN_WIDTH, currentView.center.y);
				//			changeView.center = CGPointMake(self.view.center.x, currentView.center.y);
				[currentView mas_updateConstraints:^(MASConstraintMaker *make) {
					make.centerX.equalTo(self.view).offset(-SCREEN_WIDTH);
				}];
				[changeView mas_updateConstraints:^(MASConstraintMaker *make) {
					make.centerX.equalTo(self.view).offset(0);
				}];
				[self.view layoutIfNeeded];
			}];
			
		} else if (comp < 0) {
			[UIView animateWithDuration:0.25 animations:^{
				//			currentView.center = CGPointMake(self.view.center.x + SCREEN_WIDTH, currentView.center.y);
				//			changeView.center = CGPointMake(self.view.center.x, currentView.center.y);
				[currentView mas_updateConstraints:^(MASConstraintMaker *make) {
					make.centerX.equalTo(self.view).offset(SCREEN_WIDTH);
				}];
				[changeView mas_updateConstraints:^(MASConstraintMaker *make) {
					make.centerX.equalTo(self.view).offset(0);
				}];
				[self.view layoutIfNeeded];
			}];
		}
	});
	
}

#pragma mark -- textfiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if ([string isEqualToString:kAYStringLineFeed]) {
		[textField resignFirstResponder];
		return NO;
	}
	[self setNavRightBtnEnableStatus];
	
	if (textField == timesCountInput.inputField) {
		return YES;
	} else {
		
		if (string.length != 0) {
			if (textField.text.length == 0) {
				textField.text = @"¥";
			}
			textField.text = [textField.text stringByAppendingString:string];
		} else {
			textField.text = [textField.text substringToIndex:textField.text.length - 1];
			if (textField.text.length == 1) {
				textField.text = @"";
			}
		}
		
		for (AYSetPriceInputView *input in inputViewArr) {
			if (textField == input.inputField) {
				input.isHideSep = textField.text.length != 0;
			}
		}
		return NO;
	}
}


#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	NSMutableArray *priceArr = [[NSMutableArray alloc] init];
	NSString *catStr = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([catStr isEqualToString:kAYStringCourse]) {
		
		if(stagePriceInput.inputField.text.length != 0) {
			if (timesCountInput.inputField.text.length == 0) {
				NSString *tip = @"请设置阶段课时数！";
				AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
				return nil;
			} else{
				int p = [[stagePriceInput.inputField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""] intValue] * 100;
				NSDictionary *dic = @{kAYServiceArgsPrice:[NSNumber numberWithInt:p], kAYServiceArgsPriceType:[NSNumber numberWithInt:AYPriceTypeStage]};
				[priceArr addObject:dic];
				
				[tmp setValue:[NSNumber numberWithInt:[timesCountInput.inputField.text intValue]] forKey:kAYServiceArgsClassCount];
			}
		}
		if(timesPriceInput.inputField.text.length != 0) {
			int p = [[timesPriceInput.inputField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""] intValue] * 100;
			NSDictionary *dic = @{kAYServiceArgsPrice:[NSNumber numberWithInt:p], kAYServiceArgsPriceType:[NSNumber numberWithInt:AYPriceTypeTimes]};
			[priceArr addObject:dic];
		}
		
	} else if([catStr isEqualToString:kAYStringNursery]) {
		for (int i = 0; i < inputViewArr.count; ++i) {
			NSString *inputStr= [[[inputViewArr objectAtIndex:i] inputField] text];
			if (inputStr.length != 0) {
				
				NSMutableDictionary *dic_price = [[NSMutableDictionary alloc] init];
				int p = [[inputStr stringByReplacingOccurrencesOfString:@"¥" withString:@""] intValue] * 100;
				if (p == 0) {
					NSString *tip = @"价格不能设置为0";
					AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
					return nil;
				}
				[dic_price setValue:[NSNumber numberWithInt:p] forKey:kAYServiceArgsPrice];
				[dic_price setValue:[NSNumber numberWithInt:i] forKey:kAYServiceArgsPriceType];
				[priceArr addObject:dic_price];
			}
		}
	} else {
		
	}
	
	[tmp setValue:priceArr forKey:kAYServiceArgsPriceArr];
	[tmp setValue:@"part_price" forKey:@"key"];
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {

    NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	
	NSString *catStr = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([catStr isEqualToString:kAYStringCourse]) {
		
		if ([timesCountInput.inputField isFirstResponder]) {
//			UIView *referView = [radiusViewArr objectAtIndex:0];
			CGFloat toBtm = (timesCountInput.superview.bounds.size.height - timesCountInput.bounds.size.height)*0.5+kScreenMarginBottom;
			shadowView.hidden = NO;
			[UIView animateWithDuration:0.25 animations:^{
				[(UIView*)[radiusViewArr objectAtIndex:1] mas_updateConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(self.view).offset(SEG_CONT_MARGIN_TOP-(step.floatValue-toBtm));
					make.bottom.equalTo(self.view).offset(-kScreenMarginBottom-(step.floatValue-toBtm));
//					make.centerY.equalTo(referView).offset(-(step.floatValue-toBtm)-10);
				}];
				[self.view layoutIfNeeded];
			}];
		}
	} else if ([catStr isEqualToString:kAYStringNursery]) {
		
	}
    return nil;
}

- (id)KeyboardHideKeyboard:(id)args {

	NSString *catStr = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([catStr isEqualToString:kAYStringCourse]) {
		
		if ([timesCountInput.inputField isFirstResponder]) {
			[UIView animateWithDuration:0.25 animations:^{
				[(UIView*)[radiusViewArr objectAtIndex:0] mas_updateConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(self.view).offset(SEG_CONT_MARGIN_TOP);
					make.bottom.equalTo(self.view).offset(-kScreenMarginBottom);
				}];
				[(UIView*)[radiusViewArr objectAtIndex:1] mas_updateConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(self.view).offset(SEG_CONT_MARGIN_TOP);
					make.bottom.equalTo(self.view).offset(-kScreenMarginBottom);
				}];
				[self.view layoutIfNeeded];
			} completion:^(BOOL finished) {
				shadowView.hidden = YES;
			}];
		}
	} else if ([catStr isEqualToString:kAYStringNursery]) {
		
	}
    return nil;
}

@end
