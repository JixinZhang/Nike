//
//  ZAlgoList.m
//  ZAlgoDemo
//
//  Created by zjixin on 2019/7/19.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZAlgoList.h"
#import "stdlib.h"

#pragma mark -- ZAlgoListNode

BOOL hasCycle(struct ZAlgoListNode *head) {
    struct ZAlgoListNode *slow = head;
    struct ZAlgoListNode *fast = head;
    
    while (slow != NULL && fast != NULL && fast->next != NULL) {
        slow = slow->next;
        fast = fast->next->next;
        if (fast == slow) {
            return true;
        }
    }
    return false;
}

#pragma mark -- ZAlgoList

void appendToTail(struct ZAlgoList *list, int val) {
    if (list == NULL) {
        return;
    }
    
    if ((list->head) == NULL) {
        struct ZAlgoListNode *node = malloc(sizeof(struct ZAlgoListNode));
        node->val = val;
        node->next = nil;
        list->tail = node;
        list->head = node;
    } else {
        struct ZAlgoListNode *node = malloc(sizeof(struct ZAlgoListNode));
        node->val = val;
        node->next = nil;
        list->tail->next = node;
        list->tail = node;
    }
}

void appendNodeToTail(struct ZAlgoList *list, struct ZAlgoListNode *node) {
    if (list == NULL) {
        return;
    }
    
    if (list->head == NULL) {
        list->tail = node;
        list->head = node;
    } else {
        list->tail->next = node;
        list->tail = node;
    }
    list->tail->next = nil;
}

void displayAllNodeValue(struct ZAlgoListNode *head) {
    struct ZAlgoListNode *node = head;
    while (node != NULL) {
        printf("%d->", node->val);
        node = node->next;
    }
    printf("\n");
}

int _calculateLinkedListLength(struct ZAlgoListNode *head) {
    int count = 0;
    struct ZAlgoListNode *node = head;
    while (node != NULL) {
        count++;
        node = node->next;
    }
    return count;
}

struct ZAlgoListNode *getIntersectionNode(struct ZAlgoListNode *headA, struct ZAlgoListNode *headB) {
    int lengthA = _calculateLinkedListLength(headA);
    int lengthB = _calculateLinkedListLength(headB);
    
    int result = lengthA - lengthB;
    
    struct ZAlgoListNode * nodeA = headA;
    struct ZAlgoListNode * nodeB = headB;
    
    for (int i = 0; i < abs(result); i++) {
        if (result > 0) {
            nodeA = nodeA->next;
        } else {
            nodeB = nodeB->next;
        }
    }
    
    while (nodeA && nodeB) {
        if (nodeB == nodeA) {
            return nodeA;
        }
        
        nodeA = nodeA->next;
        nodeB = nodeB->next;
    }
    return NULL;
}

struct ZAlgoListNode *reverseList(struct ZAlgoListNode *head) {
    if (head == NULL) {
        return NULL;
    }
    
    struct ZAlgoListNode *preNode = NULL;
    struct ZAlgoListNode *curNode = head;
    
    while (curNode != NULL) {
        struct ZAlgoListNode * nextNode = curNode->next;
        
        curNode->next = preNode;
        preNode = curNode;
        curNode = nextNode;
    }
    return preNode;
}

struct ZAlgoListNode *mergeTwoLists(struct ZAlgoListNode *headA, struct ZAlgoListNode *headB){
    struct ZAlgoList *list = malloc(sizeof(struct ZAlgoList));
    
    struct ZAlgoListNode *curHeadA = headA;
    struct ZAlgoListNode *curHeadB = headB;
    
    while (curHeadA != NULL || curHeadB != NULL) {
        if (curHeadA != NULL && curHeadB == NULL) {
            appendNodeToTail(list, curHeadA);
            break;
            
        } else if (curHeadA == NULL && curHeadB != NULL) {
            appendNodeToTail(list, curHeadB);
            break;
            
        } else {
            if (curHeadA->val <= curHeadB->val) {
                appendToTail(list, curHeadA->val);
                curHeadA = curHeadA->next;
            } else {
                appendToTail(list, curHeadB->val);
                curHeadB = curHeadB->next;
            }
            
        }
    }
    return list->head;
}


struct ZAlgoListNode *mergeTwoListsWithRecursion(struct ZAlgoListNode *headA, struct ZAlgoListNode *headB) {
    if (headA == NULL) {
        return headB;
    }
    
    if (headB == NULL) {
        return headA;
    }
    
    struct ZAlgoListNode *resultHead = malloc(sizeof(struct ZAlgoListNode));
    
    if (headA->val <= headB->val) {
        resultHead->val = headA->val;
        resultHead->next = mergeTwoListsWithRecursion(headA->next, headB);
    } else {
        resultHead->val = headB->val;
        resultHead->next = mergeTwoListsWithRecursion(headA, headB->next);
    }
    return resultHead;
}

struct ZAlgoListNode *findKthNodeToTail(struct ZAlgoListNode *head, int k) {
    if (head == NULL) {
        return NULL;
    }
    
    struct ZAlgoListNode *pAhead = head;
    struct ZAlgoListNode *pBehind = NULL;
    
    for (int i = 0; i < k - 1; i++) {
        if (pAhead->next != NULL) {
            pAhead = pAhead->next;
        } else {
            return NULL;
        }
    }
    pBehind = head;
    while (pAhead->next != NULL) {
        pAhead = pAhead->next;
        pBehind = pBehind->next;
    }
    return pBehind;
}

struct ZAlgoListNode *removeNthFromEnd(struct ZAlgoListNode *head, int n) {
    if (head == NULL) {
        return NULL;
    }
    
    struct ZAlgoListNode *pAhead = head;
    struct ZAlgoListNode *pBehind = NULL;
    
    for (int i = 0; i < n; i++) {
        pAhead = pAhead->next;
    }
    
    if (pAhead == NULL) {
        return head->next;
    }
    
    pBehind = head;
    while (pAhead->next != NULL) {
        pAhead = pAhead->next;
        pBehind = pBehind->next;
    }
    pBehind->next = pBehind->next->next;
    return head;
}

void printListReversingly(struct ZAlgoListNode *head) {
    struct ZAlgoListNode *node = head;
    if (node != NULL) {
        printListReversingly(node->next);
        printf("%d->", node->val);
    }
}
