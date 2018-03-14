//
//  AYAlbumDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYAlbumDefines_h
#define AYAlbumDefines_h
typedef NS_ENUM(NSInteger, AlbumControllerType) {
    AlbumControllerTypePhoto,
    AlbumControllerTypeMovie,
    AlbumControllerTypeCompire,
};

typedef NS_ENUM(NSInteger, AlbumTableCellType) {
    AlbumTableCellTypeImage,
    AlbumTableCellTypeUrl,
};

static NSString* const kAYAlbumTableCellName = @"AlbumTableCell";

static NSString* const kAYAlbumTableCellMarginLeftKey = @"AlbumTableCellMarginLeft";
static NSString* const kAYAlbumTableCellMarginRightKey = @"AlbumTableCellMarginRight";
static NSString* const kAYAlbumTableCellMarginBetweenKey = @"AlbumTableCellMarginBetween";
static NSString* const kAYAlbumTableCellCornerRadiusKey = @"AlbumTableCellCornerRadius";
static NSString* const kAYAlbumTableCellCanSelectedKey = @"AlbumTableCellCanSelected";
static NSString* const kAYAlbumTableCellGridBorderColorKey = @"AlbumTableCellGridBorderColor";
static NSString* const kAYAlbumTableCellLineViewCountKey = @"AlbumTableCellLineViewCount";

static NSString* const kAYAlbumTableCellTypeKey = @"AlbumTableCellType";
static NSString* const kAYAlbumTableCellItemKey = @"AlbumTableCellItems";
static NSString* const kAYAlbumTableCellSelfKey = @"AlbumTableCellSelf";
static NSString* const kAYAlbumTableCellRowKey = @"AlbumTableCellRow";
static NSString* const kAYAlbumTableCellControllerTypeKey = @"AlbumTableCellControllerType";

static NSString* const kAYAlbumTableCellSelectedIndexKey = @"AlbumTableCellSelectedIndexKey";
static NSString* const kAYAlbumTableCellUnSelectedIndexKey = @"AlbumTableCellUnSelectedIndexKey";

#endif /* AYAlbumDefines_h */
