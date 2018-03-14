//
//  Readme.h
//  BabySharing
//
//  Created by Alfred Yang on 27/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#ifndef Readme_h
#define Readme_h

/*
上传服务时间Push-：
1.1：看顾服务：pattern以Daily（0）为主干（每日重复），以once（3）记录特殊日期，休息日为空（每多一休息日，多一条时间线(截断主线)）
1.2：课程服务：pattern以weekly（1）为主干（每周重复）
 */

/*
解析服务时间Parse-：
1.1：看顾服务：pattern以Daily（0）为主干（每日重复），以once（3）记录特殊日期，休息日为空（每多一休息日，多一条时间线）
1.2：课程服务：pattern以weekly（1）为主干（每周重复）
 */


/*--------------------------------update unified mode by:2017-10-19--------------------------------*/

//UnifiedManagement
/* 上传服务时间Push-／解析服务时间Parse- */

static NSString* const kSpecial =				@"special";
static NSString* const kOpenDay =				@"openday";
static NSString* const kBasic =					@"basic";

#endif /* Readme_h */
