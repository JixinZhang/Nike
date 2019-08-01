//
//  main.m
//  ZClassInternalImp
//
//  Created by zjixin on 2019/7/25.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "ZClassInfo.h"

#pragma mark - ZPerson

@interface ZPerson : NSObject {
    @public
    NSString *_name;
}
- (void)personInstanceMethod;
+ (void)personClassMethod;

@end

@implementation ZPerson

- (void)personInstanceMethod {
    printf("personInstanceMethod - %p\n", &self);
}

+ (void)personClassMethod {
    printf("personClassMethod - %p\n", &self);
}

@end

#pragma mark - ZStudent

@interface ZStudent : ZPerson<NSCopying> {
    @public
    NSInteger _number;
}

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat weight;

@end

@implementation ZStudent

- (void)studentInstanceMethod {
    printf("studentInstanceMethod - %p\n", &self);
}

- (void)studentInstanceMethodTest {
    printf("studentInstanceMethodTest - %p\n", &self);
}

- (instancetype)copyWithZone:(NSZone *)zone {
    ZStudent *student = [[ZStudent alloc] init];
    student.height = self.height;
    student.weight = self.weight;
    student->_number = self->_number;
    return student;
}

@end

#pragma mark - main

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        ZStudent *student = [[ZStudent alloc] init];
        student->_name = @"Alex";
        student->_number = 1;
        student.weight = 110;
        student.height = 5;
        [student studentInstanceMethod];
        [student personInstanceMethod];
        
        [ZPerson personClassMethod];
        
        //Student类对象
        Class studentClass = [ZStudent class];
        //Person类对象
        Class personClass = [ZPerson class];
        //Person的meta-class
        Class personMetaClass = object_getClass(personClass);
        //NSObject的类对象和元类对象
        Class nsobjectClass = [NSObject class];
        Class nsobjectMetaClass = object_getClass(nsobjectClass);
        
        //对NSObject的元类对象取元类对象得到的还是NSObject，即nsobjectMetaClass和rootClass的内存地址一样
        Class rootClass = object_getClass(nsobjectMetaClass);
        
        printf("studentClass = %p\n", studentClass);
        printf("personClass = %p\n", personClass);
        printf("personMetaClass = %p\n\n", personMetaClass);
        printf("NSObjectClass = %p\n", nsobjectClass);
        printf("NSObjectMetaClass = %p\n", nsobjectMetaClass);
        printf("rootClass = %p\n", rootClass);

        //将OC的Class强制转换为源码中的objc_class * `typedef struct objc_class *Class;`
        struct z_objc_class *z_studentClass = (__bridge struct z_objc_class *)studentClass;
        struct z_objc_class *z_psersonClass = (__bridge struct z_objc_class *)personClass;
        
        /*
         ZStudent
         有一个属性：height, 两个成员变量：_number、_height，一个实例方法studentInstanceMethod;
         z_objc_class关于自身数据在class_data_bits_t bits中，数据的类型为class_rw_t，通过bits.data()方法获得；
         属性存放在的class_rw_t->properties中；
         成员变量存放在class_rw_t->ro(const class_ro_t *)->ivars(const ivar_list_t *)
         实例方法放在class_rw_t->ro(const class_ro_t *)->baseMethodList(method_list_t *) 和 实例方法放在methods(method_list_t *) 这两个地方都有值
         */
        
        struct class_rw_t *z_studentClassData = z_studentClass->data();
        printf("\nz_studentClassData ---:\n");
        printf("properties:");
        uint32_t propertiesCount = z_studentClassData->properties->count;
        for (uint32_t i = 0; i < propertiesCount; i++) {
            property_t property = z_studentClassData->properties->get(i);
            printf("%s, ", property.name);
        }
        
        uintptr_t protocolsCount = z_studentClassData->protocols->count;
        printf("\nprotocols count = %lu", protocolsCount);
        
        printf("\nivars count = %u\n", z_studentClassData->ro->ivars->count);
        printf("ivars: ");
        uint32_t count = z_studentClassData->ro->ivars->count;
        for (uint32_t i = 0; i < count; i++) {
            ivar_t ivar = z_studentClassData->ro->ivars->get(i);
            printf("%s, ", ivar.name);
        }
        
        printf("\nmethods: ");
        uint32_t methodsCount = z_studentClassData->methods->count;
        for (uint32_t i = 0; i < methodsCount; i++) {
            method_t method = z_studentClassData->methods->get(i);
            printf("%s, ", NSStringFromSelector(method.name).UTF8String);
        }

        printf("\nro->baseMethodList's first = %s\n", NSStringFromSelector(z_studentClassData->ro->baseMethodList->first.name).UTF8String);

        /*
         ZPerson
         有一个成员变量：_name，一个实例方法personInstanceMethod和一个类方法personClassMethod
         实例方法放在methods(method_list_t *)
         */
        struct class_rw_t *z_psersonClassData = z_psersonClass->data();
        printf("\nz_psersonClassData ---:\n");
        printf("ivars count = %u\n", z_psersonClassData->ro->ivars->count);
        printf("ivars first = %s\n", z_psersonClassData->ro->ivars->first.name);
        printf("methods = %s\n", NSStringFromSelector(z_psersonClassData->methods->first.name).UTF8String);

        /*
         ZPerson的类方法放在ZPerson的meta-class中
         而meta-class和class的数据结构一样，所以
         类方法放在meta-class的class_rw_t->ro(const class_ro_t *)->baseMethodList(method_list_t *) 和
         类方法放在methods(method_list_t *) 这两个地方都有值
         */
        struct z_objc_class *z_personMetaClass = z_psersonClass->metaClass();
        struct class_rw_t *z_personMetaClassData = z_personMetaClass->data();
        printf("\nz_personMetaClassData ---:\n");
        printf("methods = %s\n", NSStringFromSelector(z_personMetaClassData->methods->first.name).UTF8String);
        
        printf("\n\nend");
    }
    return 0;
}


/*
 以下为验证instance， class， meta-class 和 NSObject之间的isa指针指向
 注意：从64bit开始，isa需要进行一次位运算，才能计算出真实地址 运算方式为：isa的内存地址 & 0x0000000ffffffff8ULL
 源码下载地址：https://opensource.apple.com/tarballs/objc4/
 列表中，数组越大表示代码越新
 
 详情查看源码 objc-object.h
 
 #   define ISA_MASK        0x0000000ffffffff8ULL
 
 inline Class
 objc_object::ISA()
 {
 assert(!isTaggedPointer());
 return (Class)(isa.bits & ISA_MASK);
 }
 
 //1. 验证student实例的isa指向ZStudent类对象
 (lldb) p/x student->isa
 (Class) $0 = 0x001d8001000024bd ZStudent
 (lldb) p/x 0x0000000ffffffff8 & 0x001d8001000024bd
 (long) $1 = 0x00000001000024b8
 (lldb) p/x studentClass
 (Class) $2 = 0x00000001000024b8 ZStudent
 
 //2. 验证ZPerson类对象的isa指向ZPerson的元类对象（meta-class）
 (lldb) p/x personClass
 (Class) $6 = 0x0000000100002490 ZPerson
 (lldb) p/x z_psersonClass
 (z_objc_class *) $9 = 0x0000000100002490
 (lldb) p/x z_psersonClass->isa
 (Class) $10 = 0x001d800100002469
 (lldb) p/x 0x001d800100002469 & 0x0000000ffffffff8
 (long) $11 = 0x0000000100002468
 (lldb) p/x personMetaClass
 (Class) $12 = 0x0000000100002468
 
 (lldb) p/x z_psersonClass->superclass
 (Class) $13 = 0x00007fffb5086140 NSObject
 
 //3. 验证NSObject的元类对象的元类对象仍然指向NSObject
 (lldb) p/x nsobjectClass
 (Class) $1 = 0x00007fffb5086140 NSObject
 (lldb) p/x nsobjectMetaClass
 (Class) $2 = 0x00007fffb50860f0
 (lldb) p/x rootClass
 (Class) $3 = 0x00007fffb50860f0
 */
