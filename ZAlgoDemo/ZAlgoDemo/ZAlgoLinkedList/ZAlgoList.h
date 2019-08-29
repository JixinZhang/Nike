//
//  ZAlgoList.h
//  ZAlgoDemo
//
//  Created by zjixin on 2019/7/19.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stdio.h"
#import "stdlib.h"
#import <malloc/malloc.h>


#pragma mark -- ZAlgoListNode

/**
 单向链表节点
 */
struct ZAlgoListNode {
    int val;
    struct ZAlgoListNode *next;
};

/**
 是否包含环

 @param head 链表的头结点
 @return true 包含环，否则，不包含
 */
BOOL hasCycle(struct ZAlgoListNode *head);

#pragma mark -- ZAlgoList

/**
 单向链表
 */
struct ZAlgoList {
    struct ZAlgoListNode *head;
    struct ZAlgoListNode *tail;
};

/**
 向链表增加数据

 @param list 链表的头结点
 @param val 增加的值
 */
void appendToTail(struct ZAlgoList *list, int val);

/**
 向链表追加节点

 @param list 链表的头结点
 @param node 追加的节点
 */
void appendNodeToTail(struct ZAlgoList *list, struct ZAlgoListNode *node);

/**
 展示链表的所有值

 @param head 链表的头结点
 */
void displayAllNodeValue(struct ZAlgoListNode *head);

/**
 判断两个单向链表是否有相交的节点

 @param headA 链表A的头结点
 @param headB 链表B的头结点
 @return struct ZAlgoListNode *非空表示链表相交；否则不相交
 */
struct ZAlgoListNode *getIntersectionNode(struct ZAlgoListNode *headA, struct ZAlgoListNode *headB);

/**
 单向链表反转

 @param head 链表的头结点
 @return 翻转后的链表的头结点
 */
struct ZAlgoListNode *reverseList(struct ZAlgoListNode *head);

struct ZAlgoListNode *mergeTwoLists(struct ZAlgoListNode *headA, struct ZAlgoListNode *headB);

/**
 链表有序合并，通过递归的形式

 @param headA 链表A的头结点
 @param headB 链表B的头结点
 @return 合并后的链表的头结点
 */
struct ZAlgoListNode *mergeTwoListsWithRecursion(struct ZAlgoListNode *headA, struct ZAlgoListNode *headB);

/**
 查找链表倒数第k个节点

 @param head 链表的头结点
 @param k k
 @return 倒数第k个节点
 */
struct ZAlgoListNode *findKthNodeToTail(struct ZAlgoListNode *head, int k);

struct ZAlgoListNode *removeNthFromEnd(struct ZAlgoListNode *head, int n);

void printListReversingly(struct ZAlgoListNode *head);

/**
 删除有序链表中的重复节点，保留单个节点

 @param head 头节点
 @return 去重的链表的头节点
 */
struct ZAlgoListNode *deleteDuplicates(struct ZAlgoListNode *head);

/**
 删除有序链表中的重复节点
 
 @param head 头节点
 @return 去重的链表的头节点
 */
struct ZAlgoListNode *deleteDuplicatesII(struct ZAlgoListNode *head);
