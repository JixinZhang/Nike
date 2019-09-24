//
//  main.m
//  ZRuntimeDemo
//
//  Created by zjixin on 2019/6/5.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Man.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        Persion *persion = [[Persion alloc] init];
        
        [Persion test];
        
        imp_implementationWithBlock(^{
            
        });
        
//        method_exchangeImplementations()
        
    }
    return 0;
}
