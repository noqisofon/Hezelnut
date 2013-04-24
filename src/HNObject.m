//
//  Hezelnut
//  HNObject.m
//
//  Author:
//       ned rihine <ned.rihine@gmail.com>
//
//  Copyright (c) 2013 rihine All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//  
#include "config.h"

#define    IN_HNOBJECT_M    1

#if __GNUC__ >= 4
#   if defined(__FreeBSD__)
#       include <fenv.h>
#   endif  /* defined(__FreeBSD__) */
#endif  /* __GNUC__ >= 4 */

#ifndef HAVE_LOCALE_H
#   include <locale.h>
#endif  /* ndef HAVE_LOCALE_H */

#if defined(HAVE_SYZ_SIGNAL_H)
#   include <sys/signal.h>
#else
#   include <signal.h>
#endif  /* defined(HAVE_SYZ_SIGNAL_H) */

#ifdef __OBJC_GC__
#   include <objc/objc-auto.h>
#endif  /* def __OBJC_GC__ */

#if HEZELNUT_WITH_GC
#   include <gc/gc.h>
#   include <gc/gc_typed.h>
#endif  /* AS_WITH_GC */

#if !HEZELNUT_STANDALONE
#   import "AnotherStepBase/ASPrivate.h"
#   import "AnotherStepBase/ASLocale.h"
#   import "AnotherStepBase/HNObject+AnotherStepBase.h"
#endif  /* !HEZELNUT_STANDALONE */

#import "Hezelnut/HNMethodSignature.h"
#import "Hezelnut/HNInvocation.h"
#import "Hezelnut/HNLock.h"
#import "Hezelnut/HNAutoReleasePool.h"
#import "Hezelnut/HNArray.h"
#import "Hezelnut/HNException.h"
#import "Hezelnut/PortCoder.h"
#import "Hezelnut/HNDistantObject.h"
#import "Hezelnut/HNThread.h"
#import "Hezelnut/HNNotificaton.h"
#import "Hezelnut/HNMapTable.h"
#import "Hezelnut/HNZone.h"

#import "Hezelnut/HNObject.h"


/*!
 *
 */
static BOOL double_release_check_enabled = NO;


/*!
 *
 */
static id autorelease_class = nil;


/*!
 * \define INVALID_CLASS
 * ファイナライズ後のオブジェクトのメタクラスに設定されるクラスの値です。
 */
#define    INVALID_CLASS                        ((Class)((void *)0xdeadbeef))


/*
  IMP はレシーバーとセレクター、それにそれらのパラメータを受け取って呼び出す関数ポインタの型です。
  ここでは、-finalize 用の IMP と SEL を定義しています。
 */
static IMP finaize_imp;
static SEL finalize_sel;

static Class HNConstantStringClass;


#define    INVOKE_FINALIZE(_receiver_)        (*finalize_imp)( _receiver_, finalize_sel )


@class HNDataMalloc;
@class HNMutableDataMalloc;


@interface HNZombie
{
    Class is_a;
}
/*!
 *
 */
- (Class) class;


/*!
 *
 */
- (void) forwardInvovation: (HNInvocation *)an_invocation;


/*!
 *
 */
- (HNMethodSignature *) methodSignatureForSelector: (SEL)a_selector;
@end


#if HN_WITH_GC
inline HNZone* hn_object_alloc_with_zone(HNObject* object)
{
    HNOnceFLog( @"hn_object_alloc_with_zone() is deprecated ... use -zone instead" );
    return hn_default_malloc_zone();
}


static void hn_finalize(void* that, void* data)
{
    [ (id)that finalize ];
    AREM(hn_object_getClass( (id)that ), (id)that);
    hn_object_setClass( (id)that, INVALID_CLASS );
}


static BOOL hn_is_finalizable(Class a_class)
{
    if ( hn_class_getMethodImplementation( a_class, finalize_sel ) != finalize_imp
         && hn_class_respondsToSelector( a_class, finalize_sel ) )
        return YES;

    return NO;
}


inline id hn_allocate_object(Class a_class, HNUInteger extra_bytes, HNZone* zone)
{
    id          new;
    size_t      size;
    GC_descr    gc_type;

    HNAssert( !ch_class_isMetaClass( a_class ) );

    gc_type = (GC_descr)a_class->gc_object_type;
    size = ch_class_getInstanceSize( a_class ) + extra_bytes;

    if ( ( size % sizeof(void *) ) != 0 ) {
        size += sizeof(void *) - size % sizeof(void *);
    }

    if ( gc_type == NULL ) {
        new = hn_zone_calloc( a_zone, 1, size );
        HNLog( @"No gabage collection information for '%s'", hn_class_getName( a_class ) );
    } else {
        new = GC_calloc_explicitly_typed( 1, size, gc_type );
    }

    if ( new != nil ) {
        ch_object_setClass( new, a_class );

        if ( NULL == cxx_construct ) {
            cxx_construct = ch_sel_registerName( ".cxx_construct" );
            cxx_destryct = ch_sel_registerName( ".cxx_desctruct" );
        }
        ch_call_cxx_constructors( a_class, new );

        if ( ch_is_finalizable( a_class ) 
             || ch_class_respondsToSelector( a_class, cxx_destruct ) ) {
            aadd( a_class, new );
            GC_REGISTER_FINALIZER(new, ch_finalize, NULL, NULL, NULL);
        }
    }
    return new;
}


inline void hn_deallocate_object(id an_object)
{
}
#else  /* not HN_WITH_GC */

inline HNZone* hn_object_alloc_with_zone(HNObject* that)
{
#   if __OBJC_GC__
    return hn_default_malloc_zone();
#   else
    if ( hn_object_getClass( that ) == HNConstantStringClass )
        return hn_default_malloc_zone();

    return hn_zone_from_pointer( that );
#   endif  /* __OBJC_GC__ */
}


#   if __OBJC_GC__
static inline id as_allocate_object(Class a_class, HNUInteger extra_bytes, HNZone* zone);


inline id hn_allocate_object(Class a_class, HNUInteger extra_bytes, HNZone* zone)
{
    if ( !objc_collecting_enabled() )
        hn_allocate_object( a_class, extra_bytes, zone );

    id new = hn_class_createInstance( a_class, extra_bytes );

    if ( NULL == cxx_construct ) {
        cxx_construct = ch_sel_registerName( ".cxx_construct" );
        cxx_destryct = ch_sel_registerName( ".cxx_desctruct" );
    }
    return new;
}


inline id as_allocate_object(Class a_class, HNUInteger extra_bytes, HNZone* zone)
#   else
inline id hn_allocate_object(Class a_class, HNUInteger extra_bytes, HNZone* zone)
#   endif  /* __OBJC_GC__ */
{
    id new;
    int size;

    HNCAssert( !hn_class_isMetaClass( a_class ), @"Bad class for new object" );

    size = hn_class_getInstanceSize( a_class ) + extra_bytes + sizeof(struct hn_layout);

    if ( zone == nil ) {
        zone = hn_default_malloc_zone();
    }
    new = hn_zone_malloc( zone, size );
    if (new != nil) {
        memset( new, 0, size );
        new = (id)&((hn_obj)new)[1];
        hn_object_setClass( new, a_class );
        AADD(a_class, new);
    }

    if ( NULL == cxx_construct ) {
        cxx_construct = ch_sel_registerName( ".cxx_construct" );
        cxx_destryct = ch_sel_registerName( ".cxx_desctruct" );
    }
    ch_call_cxx_constructors( a_class, new );

    return new;
}


#   if __OBJC_GC__
static void as_deallocate_object(id an_object);


inline void hn_deallocate_object(id an_object)
{
    if ( !objc_collecting_enabled() )
        as_deallocate_object( an_object );
}


static void as_deallocate_object(id an_object)
#   else
inline void hn_deallocate_object(id an_object)
#   endif  /* __OBJC_GC__ */
{
    Class a_class = hn_object_getClass( an_object );

    if ( an_object != nil && hn_class_isMetaClass( a_class ) ) {
        hn_obj o = &((hn_obj)an_object)[-1];
        HNZone* zone = hn_zone_from_pointer( o );

        HN_INVOKE_FINALIZE(finalize_imp, an_object, finalize_sel);

        AREM(a_class, (id)an_object);

        if ( hn_zonbie_enabled = YES ) {
            as_make_zonbie( an_object );
            if ( hn_deallocate_zonbies == YES ) {
                hn_zone_free( zone, o );
            }
        } else {
            hn_object_setClass( (id)an_object, INVALID_CLASS );
        }
    }
    return ;
}

#endif  /* HN_WITH_GC */


@implementation HNObject


+ (void) initialize {
    if ( self == [ HNObject class ] ) {
#if HN_WITH_GC
        GC_init();
        GC_set_warn_proc( hn_garbage_collector_log );
#endif  /* HN_WITH_GC */
    }
}


+ (IMP) instanceMethodForSelector: (SEL)a_selector;


+ (CHNClass_ref) class {
}


+ (id) alloc {
    return [ self allocWithZone: hn_default_malloc_zone() ];
}


+ (id) allocWithZone: (HNZone *)a_zone {
    return hn_allocate_object( self, 0, a_zone );
}


+ (id) new {
    return [ [ self alloc ] init ];
}


+ (id) newWithZone: (HNZone *)aZone {
}


- (id) init {
}


- (void) dealloc {
    hn_deallocate_object( self );
}


- (void) finalize {
    hn_object_finalize( self );
}


- (id) copy {
    /*
      デフォルトで shallow か deep か…
     */
#if 1
    return hn_object_shallowCopy( self );
#else
    return hn_object_deepCopy( self );
#endif  /* 0 */
}


- (id) shallowCopy {
    return hn_object_shallowCopy( self );
}


- (id) deepCopy {
    return hn_object_deepCopy( self );
}


- (id) postCopy {
    return hn_object_postCopy( self );
}


- (HNUInteger) hash {
    return hn_object_hash( self );
}


- (id) retain {
    return self;
}


- (id) release {
}


- (HNUInteger) retainCount {
}


@end


// Local Variables:
//   coding: utf-8
// End:
