//
//  ZClassInfo.h
//  ZClassInternalImp
//
//  Created by zjixin on 2019/7/25.
//  Copyright © 2019 zjixin. All rights reserved.
//

#define FAST_DATA_MASK          0x00007ffffffffff8UL

#ifndef ZClassInfo_h
#define ZClassInfo_h

# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
# endif

#if __LP64__
#   define WORD_SHIFT 3UL
typedef uint32_t mask_t;  // x86_64 & arm64 asm are less efficient with 16-bits
#else
#   define WORD_SHIFT 2UL
typedef uint16_t mask_t;
#endif
typedef uintptr_t cache_key_t;

static inline void * memdup(const void *mem, size_t len)
{
    void *dup = malloc(len);
    memcpy(dup, mem, len);
    return dup;
}

typedef uintptr_t protocol_ref_t;
struct protocol_list_t {
    // count is 64-bit by accident.
    uintptr_t count;
    protocol_ref_t list[0]; // variable-size
    
    size_t byteSize() const {
        return sizeof(*this) + count*sizeof(list[0]);
    }
    
    protocol_list_t *duplicate() const {
        return (protocol_list_t *)memdup(this, this->byteSize());
    }
    
    typedef protocol_ref_t* iterator;
    typedef const protocol_ref_t* const_iterator;
    
    const_iterator begin() const {
        return list;
    }
    iterator begin() {
        return list;
    }
    const_iterator end() const {
        return list + count;
    }
    iterator end() {
        return list + count;
    }
};

struct method_t {
    SEL name;
    const char *types;
    IMP imp;
};

template <typename Element, typename List, uint32_t FlagMask>
struct entsize_list_tt {
    uint32_t entsizeAndFlags;
    uint32_t count;
    Element first;
public:
    uint32_t entsize() const {
        return entsizeAndFlags & ~FlagMask;
    }
    uint32_t flags() const {
        return entsizeAndFlags & FlagMask;
    }
    
    Element& getOrEnd(uint32_t i) const {
        assert(i <= count);
        return *(Element *)((uint8_t *)&first + i*entsize());
    }
    Element& get(uint32_t i) const {
        assert(i < count);
        return getOrEnd(i);
    }
};

struct property_t {
    const char *name;
    const char *attributes;
};

struct property_list_t : entsize_list_tt<property_t, property_list_t, 0> {
    
};

struct method_list_t : entsize_list_tt<method_t, method_list_t, 0x3> {
    
};

struct ivar_t {
#if __x86_64__
    // *offset was originally 64-bit on some x86_64 platforms.
    // We read and write only 32 bits of it.
    // Some metadata provides all 64 bits. This is harmless for unsigned
    // little-endian values.
    // Some code uses all 64 bits. class_addIvar() over-allocates the
    // offset for their benefit.
#endif
    int32_t *offset;
    const char *name;
    const char *type;
    // alignment is sometimes -1; use alignment() instead
    uint32_t alignment_raw;
    uint32_t size;
    
    uint32_t alignment() const {
        if (alignment_raw == ~(uint32_t)0) return 1U << WORD_SHIFT;
        return 1 << alignment_raw;
    }
};

struct ivar_list_t: entsize_list_tt<ivar_t, ivar_list_t, 0> {
    
};

struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;
#ifdef __LP64__
    uint32_t reserved;
#endif
    
    const uint8_t * ivarLayout;
    
    const char * name;
    method_list_t * baseMethodList;
    protocol_list_t * baseProtocols;
    const ivar_list_t * ivars;
    
    const uint8_t * weakIvarLayout;
    property_list_t *baseProperties;
    
    method_list_t *baseMethods() const {
        return baseMethodList;
    }
};
/*
 struct class_rw_t {
     uint32_t flags;
     uint32_t version;
 
     const class_ro_t *ro;
 
     method_array_t methods;
     property_array_t properties;
     protocol_array_t protocols;
 
     Class firstSubclass;
     Class nextSiblingClass;
 
     char *demangledName;
 }
 */

/**
 class read write table
 源码在上方
 */
struct class_rw_t {
    uint32_t flags;
    uint32_t version;
    
    const class_ro_t *ro;
    
    method_list_t * methods;        //源码中methods的类型为method_array_t，是对method_list_t的封装，这里简化
    property_list_t * properties;   //property_list_t是对property_array_t的简化
    protocol_list_t * protocols;    //protocol_list_t是对protocol_array_t的简化
    
    Class firstSubclass;
    Class nextSiblingClass;
    
    char *demangledName;
};

struct class_data_bits_t {
    uintptr_t bits;
    
public:
    class_rw_t* data() {
        return (class_rw_t *)(bits & FAST_DATA_MASK);
    }
};

struct bucket_t {
private:
    cache_key_t _key;
    IMP _imp;
};

struct cache_t {
    struct bucket_t *_buckets;
    mask_t _mask;
    mask_t _occupied;
};

struct z_objc_object {
    void *isa;
//    Class isa;
};

struct z_objc_class : z_objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
public:
    class_rw_t *data() {
        return bits.data();
    }
    
    z_objc_class *metaClass() {
        return (z_objc_class *)((long long)isa & ISA_MASK);
    }
};

#endif /* ZClassInfo_h */
