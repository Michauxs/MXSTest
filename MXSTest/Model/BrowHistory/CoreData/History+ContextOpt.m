//
//  History+ContextOpt.m
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "History+ContextOpt.h"

static NSString *const ENTITY_NAME = @"History";

@implementation History (ContextOpt)

+ (void)appendDataInContext:(NSManagedObjectContext*)context withData:(NSDictionary*)args {
	
	History *new = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
	new.sender = [args objectForKey:kMXSHistoryModelArgsSender];
	new.receiver = [args objectForKey:kMXSHistoryModelArgsReceiver];
	new.message_text = [args objectForKey:kMXSHistoryModelArgsMessageText];
	new.date_send = [[args objectForKey:kMXSHistoryModelArgsDateSend] doubleValue];
	new.is_read = [[args objectForKey:kMXSHistoryModelArgsIsRead] boolValue];
	
	[context save:nil];
	
	NSLog(@"save complete");
}

+ (NSArray*)enumAllDataInContext:(NSManagedObjectContext*)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	
	NSError *err = nil;
	NSArray *matches = [context executeFetchRequest:request error:&err];
	
	if (!err) {
		return [self parseModeWithMatches:matches];
	} else
		return nil;
}

+ (NSArray*)searchDataInContext:(NSManagedObjectContext*)context withKV:(NSDictionary*)args {
	NSString *k = [args objectForKey:@"key"];
	NSString *v = [args objectForKey:@"value"];
	
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	request.predicate = [NSPredicate predicateWithFormat:@"%@ = %@", k, v];
	
	NSError* err = nil;
	NSArray* matches = [context executeFetchRequest:request error:&err];
	if (!err) {
		return [self parseModeWithMatches:matches];
	} else
		return nil;
}

+ (void)removeDataInContext:(NSManagedObjectContext*)context withKV:(NSDictionary*)args {
	NSString *k = [args objectForKey:@"key"];
	NSString *v = [args objectForKey:@"value"];
	
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	request.predicate = [NSPredicate predicateWithFormat:@"%@ = %@", k, v];
	
	NSError *err = nil;
	NSArray *matches = [context executeFetchRequest:request error:&err];
	for (History *his in matches) {
		[context deleteObject:his];
	}
	
	NSLog(@"remove complete");
}

+ (void)removeAllDataInContext:(NSManagedObjectContext*)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	
	NSError *err = nil;
	NSArray *matches = [context executeFetchRequest:request error:&err];
	for (History *his in matches) {
		[context deleteObject:his];
	}
	
	NSLog(@"remove complete");
}

#pragma mark - common actions
+ (NSArray*)parseModeWithMatches:(NSArray*)matches {
	
	NSMutableArray *back = [NSMutableArray array];
	for (History *his in matches) {
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		[tmp setValue:his.sender forKey:kMXSHistoryModelArgsSender];
		[tmp setValue:his.receiver forKey:kMXSHistoryModelArgsReceiver];
		[tmp setValue:his.message_text forKey:kMXSHistoryModelArgsMessageText];
		[tmp setValue:[NSNumber numberWithBool:his.is_read] forKey:kMXSHistoryModelArgsIsRead];
		[tmp setValue:[NSNumber numberWithDouble:his.date_send] forKey:kMXSHistoryModelArgsDateSend];
		[back addObject:tmp];
	}
	return [back copy];
}

/*
从应用程序包中加载模型文件 NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil]; // 传入模型对象，初始化NSPersistentStoreCoordinator NSPersistentStoreCoordinator *psc = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] autorelease]; // 构建SQLite数据库文件的路径 NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]]; // 添加持久化存储库，这里使用SQLite作为存储库 NSError *error = nil; NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]; if (store == nil) { // 直接抛异常 [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]]; } // 初始化上下文，设置persistentStoreCoordinator属性 NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init]; context.persistentStoreCoordinator = psc; // 用完之后，记得要[context release];

　　2.添加数据到数据库

　　// 传入上下文，创建一个Person实体对象 NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context]; // 设置Person的简单属性 [person setValue:@"MJ" forKey:@"name"]; [person setValue:[NSNumber numberWithInt:27] forKey:@"age"]; // 传入上下文，创建一个Card实体对象 NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context]; [card setValue:@"4414241933432" forKey:@"no"]; // 设置Person和Card之间的关联关系 [person setValue:card forKey:@"card"]; // 利用上下文对象，将数据同步到持久化存储库 NSError *error = nil; BOOL success = [context save:&error]; if (!success) { [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]]; } // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库

　　3.从数据库中查询数据

　　// 初始化一个查询请求 NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease]; // 设置要查询的实体 request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context]; // 设置排序（按照age降序） NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO]; request.sortDescriptors = [NSArray arrayWithObject:sort]; // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*) NSPRedicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Itcast-1*"]; request.predicate = predicate; // 执行请求 NSError *error = nil; NSArray *objs = [context executeFetchRequest:request error:&error]; if (error) { [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]]; } // 遍历数据 for (NSManagedObject *obj in objs) { NSLog(@"name=%@", [obj valueForKey:@"name"] }

　　注：Core Data不会根据实体中的关联关系立即获取相应的关联对象，比如通过Core Data取出Person实体时，并不会立即查询相关联的Card实体；当应用真的需要使用Card时，才会再次查询数据库，加载Card实体的信息。这个就是Core Data的延迟加载机制

　　4.删除数据库中的数据

　　// 传入需要删除的实体对象 [context deleteObject:managedObject]; // 将结果同步到数据库 NSError *error = nil; [context save:&error]; if (error) { [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]]; }

　　打开CoreData的SQL语句输出开关1.打开Product，点击EditScheme...

　　2.点击Arguments，在ArgumentsPassed On Launch中添加2项

　　1> -com.apple.CoreData.SQLDebug

　　2> 1

　　创建NSManagedObject的子类默认情况下，利用Core Data取出的实体都是NSManagedObject类型的，能够利用键-值对来存取数据。但是一般情况下，实体在存取数据的基础上，有时还需要添加一些业务方法来完成一些其他任务，那么就必须创建NSManagedObject的子类

　　选择模型文件

　　选择需要创建子类的实体

　　创建完毕后，多了2个子类

　　文件内容展示：
　　Person.h

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Card;
@interface Person : NSManagedObject @property (nonatomic, retain)
NSString * name; @property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) Card *card; @end

Person.m
#import "Person.h"
@implementation Person
@dynamic name;
@dynamic age;
@dynamic card;
@end


　　Card.h
 #import <Foundation/Foundation.h>
 #import <CoreData/CoreData.h>
 @class Person;
 @interface Card : NSManagedObject
 @property (nonatomic, retain) NSString * no;
 @property (nonatomic, retain) Person *person; @end
Card.m
#import "Card.h"
 #import "Person.h"
 @implementation Card
 @dynamic no;
 @dynamic person;
 @end

那么往数据库中添加数据的时候就应该写了：

Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
 person.name = @"MJ"; person.age = [NSNumber numberWithInt:27];
 Card *card = [NSEntityDescription insertNewObjectForEntityForName:@”Card" inManagedObjectContext:context];
 card.no = @”4414245465656";
 person.card = card;
 // 最后调用[context save&error];保存数据
 
CoreData 从iOS 3.0 开始 (orm的原理)
用coreData 来操作sqlite 对象 -> 调用插入方法
CoreData 是Mac OS X中Cocoa API的一部分, 首次出现在Mac OS 10.4 和iOS 3.0 中. 它提供了 对象- 关系映射 (ORM) 功能. 可以将OC对象转化为数据, 保存在SQLite数据库文件中, 也能够将数据库的文件还原成OC对象. 在此期间, 我们不需要编写任何SQL语句.
可以简单的理解为Cocoa对SQLite的一层封装.
CocoaData 好处:
一: 极大的减少Model层的代码量.
二: 优化了使用SQLite时候的性能.
三: 提供了可视化设计.
NO.1managedObjectContext 上下文对象负责将我们要保存的对象存入到数据库中, 或者从数据库中取出数据
NO.2 managedObjectModel管理对象模型负责把我们在 CoreDataDemo.xcdatamodeld文件中添加的entity(实体)转化为sqlite数据库中的表.
NO.3 persistentStoreCoordinator持久化存储协调器负责把要保存的数据(sqlite文件)存储到沙盒中某个位置.

@synthesize property让系统帮我们生成set get方法
@dynamicname;
 //不让系统生成get和set方法 需要我们自己去实现
插入数据:
// 插入操作

- (void)insertData

{

// 获取到上下文对象

AppDelegate *delegate = [UIapplicationsharedApplication].delegate;

NSManagedObjectContext *context = delegate.managedObjectContext;

// 创建一个要插入的对象

NSManagedObject*people = [NSEntityDescriptioninsertNewObjectForEntityForName:@"People"inManagedObjectContext:context];

[peoplesetValue:@"王红五" forKey:@"name"];

[peoplesetValue:@(28)forKey:@"age"];

NSError *error =nil;

// 执行保存的方法, 就会把刚才创建的对象保存到数据库中

BOOL isSave = [contextsave:&error];

if (isSave) {

NSLog(@"insert success");

}else

{

NSLog(@"insert failed %@",error);

}

//方法二

People*people1 = [NSEntityDescriptioninsertNewObjectForEntityForName:@"People"inManagedObjectContext:context];
people1.name =@"马六六";
people1.age =@21;
NSError *error1 =nil;
[contextsave:&error1];

}

查询操作:

- (void)queryData

{

// 获取到上下文对象

AppDelegate *delegate = [UIApplicationsharedApplication].delegate;

NSManagedObjectContext *context = delegate.managedObjectContext;

// 创建一个查询的请求

NSFetchRequest*request = [[NSFetchRequestalloc]init];

// 设置要查询哪一个实体(表)

request.entity= [NSEntityDescriptionentityForName:@"People"inManagedObjectContext:context];

//排序对象

NSSortDescriptor*sort = [NSSortDescriptorsortDescriptorWithKey:@"age"ascending:YES];

request.sortDescriptors =@[sort];

//查询条件

request.predicate= [NSPredicatepredicateWithFormat:@"name like %@",@"马*"];

//调用查询的方法

NSError *error =nil;

NSArray *array = [contextexecuteFetchRequest:requesterror:&error];

for (People *p in array) {

NSLog(@"name %@ age %@",p.name,p.age);

// [self updateData:p];

[self deleteData:p];

}

}

修改(更新操作):
- (void)updateData: (People *)people

{

//修改具体的值

people.age =@40;

// 获取到上下文对象

AppDelegate *delegate = [UIApplicationsharedApplication].delegate;

NSManagedObjectContext *context = delegate.managedObjectContext;

NSError *error =nil;

BOOL isOk = [contextsave:&error];

NSLog(@"%@",isOk ==YES?@"保存成功":@"保存失败");

}

删除操作:

- (void)deleteData: (People *)people

{

// 获取到上下文对象

AppDelegate *delegate = [UIApplicationsharedApplication].delegate;

NSManagedObjectContext *context = delegate.managedObjectContext;

[contextdeleteObject:people];

BOOL isOK = [contextsave:nil];

NSLog(@"%@",isOK ==YES?@"删除成功":@"删除失败");

}*/

@end
