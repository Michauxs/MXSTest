//
//  MXSStudent.m
//  MXSTest
//
//  Created by Sunfei on 2018/5/14.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSStudent.h"

@implementation MXSStudent


#pragma mark - common
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    NSLog(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.infoData forKey:@"infoData"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    NSLog(@"调用了initWithCoder:方法");
    //注意：在构造方法中需要先初始化父类的方法
    if (self=[super init]) {
        self.infoData=[aDecoder decodeObjectForKey:@"infoData"];
    }
    return self;
}

#pragma mark - dictionary
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    NSLog(@"调用了encodeWithCoder:归档方法");
//    [aCoder encodeObject:self.keys forKey:@"keys"];
//    for (NSString *key in self.keys) {
//        id value = [_infoData valueForKey:key];
//        [aCoder encodeObject:value forKey:key];
//    }
//}
//
//- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
//    NSLog(@"调用了initWithCoder:解档方法");
//
//    if (self=[super init]) {
//        self.keys = [aDecoder decodeObjectForKey:@"keys"];
//        for (NSString *key in self.keys) {
//            id value = [aDecoder decodeObjectForKey:key];
//            [self setValue:value forKey:key];
//        }
//    }
//
//    return self;
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"key = %@, value = %@", key, value);
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}




+ (id)getPropertyValueWithTarget:(id)target withPropertyName:(NSString *)propertyName {
    //先判断有没有这个属性，没有就添加，有就直接赋值
    Ivar ivar = class_getInstanceVariable([target class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
    if (ivar) {
        return object_getIvar(target, ivar);
    }
    
    ivar = class_getInstanceVariable([target class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
    NSMutableDictionary *dict = object_getIvar(target, ivar);
    if (dict && [dict objectForKey:propertyName]) {
        return [dict objectForKey:propertyName];
    } else {
        return nil;
    }
}




- (void)encodeDictWithCoder:(NSCoder *)aCoder {
    
}

- (void)encodeArrWithCoder:(NSCoder *)aCoder {
    
}

#pragma mark - runtime
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    unsigned int count = 0;
//    //1.取出所有的属性
//    objc_property_t *propertes = class_copyPropertyList([self class], &count);
//    //2.遍历的属性
//    for (int i=0; i<count; i++) {
//        //获取当前遍历的属性的名称
//        const char *propertyName = property_getName(propertes[i]);
//        NSString *name = [NSString stringWithUTF8String:propertyName];
//        //利用KVC取出对应属性的值
//        id value = [self valueForKey:name];
//        //归档到文件中
//        [aCoder encodeObject:value forKey:name];
//
//    }
//}
//
//-(id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        unsigned int count =0;
//        //1.取出所有的属性
//        objc_property_t *propertes = class_copyPropertyList([self class], &count);
//        //2.遍历所有的属性
//        for (int i = 0; i < count; i++) {
//            //获取当前遍历到的属性名称
//            const char *propertyName = property_getName(propertes[i]);
//            NSString *name = [NSString stringWithUTF8String:propertyName];
//            //解归档前遍历得到的属性的值
//            id value = [aDecoder decodeObjectForKey:name];
////             self.className = [decoder decodeObjectForKey:@"className"];
//            [self setValue:value forKey:name];
//        }
//
//    }
//    return self;
//}

@end
