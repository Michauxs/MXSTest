//
//  SearchSegDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#ifndef SearchSegDelegate_h
#define SearchSegDelegate_h

//@class SearchSegView;
//@class SearchSegView2;
//
//@protocol SearchSegViewDelegate <NSObject>
//
//@optional
//- (void)segValueChanged:(SearchSegView*)seg;
//- (void)segValueChanged2:(SearchSegView2*)seg;
//@end

typedef enum : NSUInteger {
    AYSegViewItemTypeTitle,
    AYSegViewItemTypeTitleWithSubTitle,
    AYSegViewItemTypeTitleWithImage,
    AYSegViewItemTypeImage,
} AYSegViewItemType;

static NSString* const kAYSegViewTitleKey = @"dongda seg title key";
static NSString* const kAYSegViewSubTitleKey = @"dongda seg sub title key";

static NSString* const kAYSegViewNormalImageKey = @"dongda seg normal image key";
static NSString* const kAYSegViewSelectedImageKey = @"dongda seg selected image key";

static NSString* const kAYSegViewNormalFontColorKey = @"dongda seg normal font color key";
static NSString* const kAYSegViewSelectedFontColorKey = @"dongda seg selected font color key";
static NSString* const kAYSegViewSelectedFontSizeKey = @"dongda seg font size key";

static NSString* const kAYSegViewMarginToEdgeKey = @"dongda seg margin to edge key";
static NSString* const kAYSegViewMarginBetweenKey = @"dongda seg margin between items key";
static NSString* const kAYSegViewLineHiddenKey = @"dongda seg line hidden key";
static NSString* const kAYSegViewBackgroundColorKey = @"dongda seg background color";
static NSString* const kAYSegViewCornerRadiusKey = @"dongda seg corner radius";
static NSString* const kAYSegViewCurrentSelectKey = @"dongda seg current selected";

static NSString* const kAYSegViewItemTypeKey = @"dongda seg item type";
static NSString* const kAYSegViewIndexTypeKey = @"dongda seg item index";

#endif /* SearchSegDelegate_h */
