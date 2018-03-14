//
//  AYServiceArgsDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 2/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#ifndef AYServiceArgsDefines_h
#define AYServiceArgsDefines_h

//
static NSString* const kAYVCBackArgsKey =					@"dongda_vc_backargs_key";
static NSString* const kAYVCBackArgsKeyProfileUpdate =		@"dongda_vc_backargs_key_profileupdate";
static NSString* const kAYVCBackArgsKeyCollectChange =		@"dongda_vc_backargs_key_collectchange";


//defines args
static NSString* const kAYDefineArgsCellNames =				@"cell_class_name_arr";


//common args
static NSString* const kAYCommArgsCondition =				@"condition";
static NSString* const kAYCommArgsUserID =					@"user_id";
static NSString* const kAYCommArgsAuthToken =				@"auth_token";
static NSString* const kAYCommArgsToken =					@"token";
static NSString* const kAYCommArgsOwnerID =					@"owner_id";
static NSString* const kAYCommArgsTips =					@"args_tips";
/*
 *iOS计时单位：秒，服务器计时单位：毫秒；
 *所有秒->毫秒都在拼接请求参数是转换;
 */
static NSString* const kAYCommArgsRemoteDate =				@"date";
static NSString* const kAYCommArgsRemoteDataSkip =			@"skip";
static NSString* const kAYCommArgsRemoteTake =				@"take";

//user profile args
static NSString* const kAYProfileArgsSelf =					@"profile";
static NSString* const kAYProfileArgsScreenName =			@"screen_name";
static NSString* const kAYProfileArgsScreenPhoto =			@"screen_photo";
static NSString* const kAYProfileArgsContactNo =			@"contact_no";
static NSString* const kAYProfileArgsSocialId =				@"social_id";
static NSString* const kAYProfileArgsOwnerName =			@"owner_name";
static NSString* const kAYProfileArgsPhone =				@"phone";

static NSString* const kAYProfileArgsIsProvider =			@"is_service_provider";
static NSString* const kAYProfileArgsIsValidtRealName =		@"is_real_name_cert";
static NSString* const kAYProfileArgsDescription =			@"description";
static NSString* const kAYProfileArgsRegistDate =			@"date";
static NSString* const kAYProfileArgsIsHasPhone =			@"has_auth_phone";

//brand args
static NSString* const kAYBrandArgsSelf =					@"brand";
static NSString* const kAYBrandArgsID =						@"brand_id";
static NSString* const kAYBrandArgsName =					@"brand_name";
static NSString* const kAYBrandArgsTag =					@"brand_tag";
static NSString* const kAYBrandArgsAbout =					@"about_brand";

//service args
static NSString* const kAYServiceArgsType =					@"service_type";
static NSString* const kAYServiceArgsOperation =			@"operation";
static NSString* const kAYServiceArgsTags =					@"service_tags";
static NSString* const kAYServiceArgsLeaf =					@"service_leaf";
static NSString* const kAYServiceArgsLocationID =			@"location_id";
static NSString* const kAYServiceArgsPunchline =			@"punchline";
static NSString* const kAYServiceArgsLocationImages =		@"location_images";
static NSString* const kAYServiceArgsAlbum =				@"album";

static NSString* const kAYServiceArgsSelf =					@"service";
static NSString* const kAYServiceArgsInfo =					@"service_info";
static NSString* const kAYServiceArgsID =					@"service_id";

static NSString* const kAYServiceArgsIsChoice =				@"isSelected";
static NSString* const kAYServiceArgsIsTopCateg =			@"isHotCat";
static NSString* const kAYServiceArgsChoiced =				@"selected";
static NSString* const kAYServiceArgsTopCateg =				@"hotcate";

static NSString* const kAYServiceArgsCategoryInfo =			@"category";
static NSString* const kAYServiceArgsServiceTypeInfo =      @"service_type";
static NSString* const kAYServiceArgsAlbumInfo =            @"album";
static NSString* const kAYServiceArgsCat =					@"category";
static NSString* const kAYServiceArgsCatSecondary =			@"cans_cat";
static NSString* const kAYServiceArgsCatThirdly =			@"cans";
static NSString* const kAYServiceArgsConcert =				@"concert";
static NSString* const kAYServiceArgsCourseCoustom =		@"concert";
//static NSString* const kAYServiceArgsCourseCoustom =		@"reserve1";

static NSString* const kAYServiceArgsImages =				@"service_images";
static NSString* const kAYServiceArgsImage =				@"service_image";
static NSString* const kAYServiceArgsTitle =				@"title";
static NSString* const kAYServiceArgsDescription =			@"description";
static NSString* const kAYServiceArgsCharact =				@"characteristics";

static NSString* const kAYServiceArgsTimes =				@"tms";
static NSString* const kAYServiceArgsStartDate =			@"startdate";
static NSString* const kAYServiceArgsEndDate =				@"enddate";
static NSString* const kAYServiceArgsPattern =				@"pattern";
static NSString* const kAYServiceArgsTPHandle =				@"timePointHandle";
static NSString* const kAYServiceArgsStartHours =			@"starthours";
static NSString* const kAYServiceArgsEndHours =				@"endhours";

static NSString* const kAYServiceArgsOfferDate =			@"offer_date";
static NSString* const kAYServiceArgsWeekday =				@"day";
static NSString* const kAYServiceArgsOccurance =			@"occurance";
static NSString* const kAYServiceArgsStart =				@"start";
static NSString* const kAYServiceArgsEnd =					@"end";

static NSString* const kAYServiceArgsNotice =				@"other_words";
static NSString* const kAYServiceArgsAllowLeave =			@"allow_leaves";
static NSString* const kAYServiceArgsIsHealth =				@"health";
static NSString* const kAYServiceArgsIsCollect =			@"is_collected";
static NSString* const kAYServiceArgsPoints =				@"points";

static NSString* const kAYServiceArgsDetailInfo =			@"detail";
static NSString* const kAYServiceArgsPriceArr =				@"price_arr";
static NSString* const kAYServiceArgsPrice =				@"price";
static NSString* const kAYServiceArgsPriceType =			@"price_type";
static NSString* const kAYServiceArgsClassCount =			@"count_classes";
static NSString* const kAYServiceArgsCourseduration =		@"lecture_length";
static NSString* const kAYServiceArgsLeastHours =			@"least_hours";
static NSString* const kAYServiceArgsLeastTimes =			@"least_times";

static NSString* const kAYServiceArgsFacility =				@"facility";

static NSString* const kAYServiceArgsLocationInfo =			@"location";
static NSString* const kAYServiceArgsYardType =				@"location_type";
static NSString* const kAYServiceArgsProvince =				@"province";
static NSString* const kAYServiceArgsCity =					@"city";
static NSString* const kAYServiceArgsDistrict =				@"district";
static NSString* const kAYServiceArgsAddress =				@"address";
static NSString* const kAYServiceArgsAdjustAddress =		@"adjust";
static NSString* const kAYServiceArgsPin =					@"pin";
static NSString* const kAYServiceArgsLatitude =				@"latitude";
static NSString* const kAYServiceArgsLongtitude =			@"longitude";
static NSString* const kAYServiceArgsYardImages =			@"loc_images";
static NSString* const kAYServiceArgsPic =					@"pic";
static NSString* const kAYServiceArgsTag =					@"tag";

static NSString* const kAYServiceArgsAgeBoundary =			@"age_boundary";
static NSString* const kAYServiceArgsAgeBoundaryUp =		@"usl";
static NSString* const kAYServiceArgsAgeBoundaryLow =		@"lsl";
static NSString* const kAYServiceArgsCapacity =				@"capacity";
static NSString* const kAYServiceArgsServantNumb =			@"servant_no";

static NSString* const kAYServiceArgsIsAdjustSKU =			@"is_adjust_SKU";
//static NSString* const kAYServiceArgs =               @"screen_name";

//timemanager args
static NSString* const kAYTimeManagerArgsSelf =				@"timemanager";
static NSString* const kAYTimeManagerArgsTMs =				@"tms";
static NSString* const kAYTimeManagerArgsPattern =			@"pattern";
static NSString* const kAYTimeManagerArgsStartDate =		@"startdate";
static NSString* const kAYTimeManagerArgsEndDate =			@"enddate";
static NSString* const kAYTimeManagerArgsStartHours =		@"starthours";
static NSString* const kAYTimeManagerArgsEndHours =			@"endhours";
static NSString* const kAYTimeManagerArgsStart =			@"start";
static NSString* const kAYTimeManagerArgsEnd =				@"end";

//order args
static NSString* const kAYOrderArgsSelf =					@"order";
static NSString* const kAYOrderArgsID =						@"order_id";
static NSString* const kAYOrderArgsTotalFee =				@"total_fee";
static NSString* const kAYOrderArgsThumbs =					@"order_thumbs";
static NSString* const kAYOrderArgsTitle =					@"order_title";
static NSString* const kAYOrderArgsDate =					@"order_date";
static NSString* const kAYOrderArgsStatus =					@"status";
static NSString* const kAYOrderArgsFurtherMessage =			@"further_message";
static NSString* const kAYOrderArgsPayMethod =				@"pay_method";
static NSString* const kAYOrderArgsPrepayId =               @"prepay_id";




#endif /* AYServiceArgsDefines_h */
