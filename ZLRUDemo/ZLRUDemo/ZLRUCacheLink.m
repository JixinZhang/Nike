//
//  ZLRUCacheLink.m
//  ZLRUDemo
//
//  Created by zjixin on 2019/6/11.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZLRUCacheLink.h"
#import <pthread.h>

#pragma mark - ZLinkedMapNode

@interface ZLinkedMapNode : NSObject {
    @package
    __unsafe_unretained ZLinkedMapNode *_prev;
    __unsafe_unretained ZLinkedMapNode *_next;
    id _key;
    id _value;
}
@end

@implementation ZLinkedMapNode

@end

#pragma mark - ZLinkedMap

@interface ZLinkedMap : NSObject {
    @package
    CFMutableDictionaryRef _dic;
    ZLinkedMapNode *_head;
    ZLinkedMapNode *_tail;
    BOOL _releaseOnMainThread;
    BOOL _releaseAsynchronously;
    NSUInteger _totalCount;
}

- (void)insertNodeAtHead:(ZLinkedMapNode *)node;

- (void)bringNodeToHead:(ZLinkedMapNode *)node;

- (void)removeNode:(ZLinkedMapNode *)node;

- (ZLinkedMapNode *)removeTailNode;

- (void)removeAll;

@end

@implementation ZLinkedMap

- (instancetype)init {
    self = [super init];
    if (self) {
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _releaseOnMainThread = NO;
        _releaseAsynchronously = YES;
    }
    return self;
}

- (void)dealloc {
    CFRelease(_dic);
}

- (void)insertNodeAtHead:(ZLinkedMapNode *)node {
    CFDictionarySetValue(_dic, (__bridge const void *)(node->_key), (__bridge const void *)(node));
    _totalCount++;
    if (_head) {
        node->_next = _head;
        _head->_prev = node;
        _head = node;
        _head->_prev = nil;
    } else {
        _head = node;
        _tail = node;
    }
}

- (void)bringNodeToHead:(ZLinkedMapNode *)node {
    if (_head == node) {
        return;
    }
    
    if (_tail == node) {
        _tail = node->_prev;
        _tail->_next = nil;
    } else {
        node->_next->_prev = node->_prev;
        node->_prev->_next = node->_next;
    }
    
    node->_next = _head;
    node->_prev = nil;
    _head->_prev = node;
    _head = node;
}

- (void)removeNode:(ZLinkedMapNode *)node {
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(node->_key));
    _totalCount--;
    if (node->_next) {
        node->_next->_prev = node->_prev;
    }
    
    if (node->_prev) {
        node->_prev->_next = node->_next;
    }
    
    if (_tail == node) {
        _tail = node->_prev;
    }
    
    if (_head == node) {
        _head = node->_next;
    }
}

- (ZLinkedMapNode *)removeTailNode {
    if (!_tail) {
        return nil;
    }
    _totalCount--;
    ZLinkedMapNode *tail = _tail;
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(_tail->_key));
    if (_head == _tail) {
        _head = _tail = nil;
    } else {
        _tail = _tail->_prev;
        _tail->_next = nil;
    }
    return tail;
}

- (void)removeAll {
    _head = nil;
    _tail = nil;
    _totalCount = 0;
    if (CFDictionaryGetCount(_dic) > 0) {
        CFMutableDictionaryRef holder = _dic;
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        if (_releaseAsynchronously) {
            dispatch_queue_t queue = _releaseOnMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                CFRelease(holder);
            });
        } else if (_releaseOnMainThread && !pthread_main_np()) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CFRelease(holder);
            });
        } else {
            CFRelease(holder);
        }
    }
}

@end

#pragma mark - ZLRUCacheLink

@interface ZLRUCacheLink() {
    pthread_mutex_t _lock;
    ZLinkedMap *_lru;
    dispatch_queue_t _queue;
}

@end

@implementation ZLRUCacheLink

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _lru = [ZLinkedMap new];
        _queue = dispatch_queue_create("app.jixin.cache.lru", DISPATCH_QUEUE_SERIAL);
        
        
    }
    return self;
}

- (void)dealloc {
    [_lru removeAll];
    pthread_mutex_destroy(&_lock);
}

- (void)setReleaseOnMainThread:(BOOL)releaseOnMainThread {
    pthread_mutex_lock(&_lock);
    _lru->_releaseOnMainThread = releaseOnMainThread;
    pthread_mutex_unlock(&_lock);
}

- (BOOL)releaseOnMainThread {
    pthread_mutex_lock(&_lock);
    BOOL releaseOnMainThread = _lru->_releaseOnMainThread;
    pthread_mutex_unlock(&_lock);
    return releaseOnMainThread;
}

- (void)setReleaseAsynchronously:(BOOL)releaseAsynchronously {
    pthread_mutex_lock(&_lock);
    _lru->_releaseAsynchronously = releaseAsynchronously;
    pthread_mutex_unlock(&_lock);
}

- (BOOL)releaseAsynchronously {
    pthread_mutex_lock(&_lock);
    BOOL releaseAsynchronously = _lru->_releaseAsynchronously;
    pthread_mutex_unlock(&_lock);
    return releaseAsynchronously;
}

- (BOOL)containsObjectForKey:(id)key {
    if (!key) {
        return NO;
    }
    pthread_mutex_lock(&_lock);
    BOOL contains = CFDictionaryContainsKey(_lru->_dic, (__bridge const void *)(key));
    pthread_mutex_unlock(&_lock);
    return contains;
}

- (id)objectForKey:(id)key {
    if (!key) {
        return nil;
    }
    pthread_mutex_lock(&_lock);
    ZLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void *)(key));
    if (node) {
        [_lru bringNodeToHead:node];
    }
    pthread_mutex_unlock(&_lock);
    return node ? node->_value : nil;
}

- (void)setObject:(id)object forKey:(id)key {
    if (!key) {
        return;
    }
    
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    pthread_mutex_lock(&_lock);
    ZLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void *)(key));
    if (node) {
        [_lru bringNodeToHead:node];
    } else {
        node = [ZLinkedMapNode new];
        node->_key = key;
        node->_value = object;
        [_lru insertNodeAtHead:node];
    }
    pthread_mutex_unlock(&_lock);

}

- (void)removeObjectForKey:(id)key {
    if (!key) {
        return;
    }
    
    pthread_mutex_lock(&_lock);
    ZLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void *)(key));
    if (node) {
        [_lru removeNode:node];
        if (_lru->_releaseAsynchronously) {
            dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                [node class];
            });
        } else if (_lru->_releaseOnMainThread && !pthread_main_np()) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [node class];
            });
        }
    }
    pthread_mutex_unlock(&_lock);
}

- (void)removeAllObjects {
    pthread_mutex_lock(&_lock);
    [_lru removeAll];
    pthread_mutex_unlock(&_lock);
}

- (void)trimToCount:(NSUInteger)count {
    if (count == 0) {
        [self removeAllObjects];
        return;
    }
    [self _trimToCount:count];
}

- (void)_trimToCount:(NSUInteger)countLimit {
    BOOL finish = NO;
    pthread_mutex_lock(&_lock);
    if (countLimit == 0) {
        [_lru removeAll];
        finish = YES;
    } else if (_lru->_totalCount <= countLimit) {
        finish = YES;
    }
    pthread_mutex_unlock(&_lock);
    
    if (finish) {
        return;
    }
    
    NSMutableArray *holder = [NSMutableArray array];
    while (!finish) {
        if (pthread_mutex_lock(&_lock) == 0) {
            if (_lru->_totalCount > countLimit) {
                ZLinkedMapNode *node = [_lru removeTailNode];
                if (node) {
                    [holder addObject:node];
                }
            } else {
                finish = YES;
            }
            pthread_mutex_unlock(&_lock);
        } else {
            usleep(10 * 1000);
        }
    }
    if (holder.count) {
        dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [holder count]; // release in queue
            /*原因：当把将要删除的对象添加到array中，此时array不会释放，array中的对象也不会释放，因为在另外的线程中又调用了count方法，持有了array。
             当block执行完，就会释放持有的array，也达到了释放删除对象的目的，即在指定的queue中子线程释放对象。*/
        });
    }
}

- (NSArray *)cacheList {
    NSMutableArray *array = [NSMutableArray array];
    pthread_mutex_lock(&_lock);
    ZLinkedMapNode *node = _lru->_head;
    while (node) {
        id value = node->_value;
        if (value) {
            [array addObject:value];
        }
        node = node->_next;
    }
    pthread_mutex_unlock(&_lock);
    return [array copy];

}

@end
