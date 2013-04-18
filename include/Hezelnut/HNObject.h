//
//  Hezelnut
//  HNObject.h
//
//  Author:
//       ned rihine <ned.rihine@gmail.com>
//
//  Copyright (c) 2013 rihine All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//  
#import "Hezelnut/HNVersionMacros.h"



@protocol HNObject

/*!
 * レシーバのクラスを返します。
 */
- (Class) class;


/*!
 * レシーバのスーパークラスを返します。
 */
- (Class) superclass;


/*!
 * レシーバの注釈文字列を返します。
 */
- (HNString *) description;


/*!
 * レシーバを返します。
 */
- (id) self;


/*!
 * レシーバと an_object が等しければ真を返します。
 * 
 * \param an_object 比較したい別のオブジェクト。
 */
- (BOOL) equals: (id)an_object;


/*!
 * レシーバと an_object が等しければ真を返します。
 */
- (BOOL) identityEquals: (id)an_object;


/*!
 *
 */
- (BOOL) isKindOf: (Class)a_class;


/*!
 *
 */
- (BOOL) isMemberOf: (Class)a_class;


/*!
 *
 */
- (BOOL) isNil;


/*!
 *
 */
- (BOOL) notNil;


/*!
 *
 */
- (BOOL) respondsToSelector: (SEL)aSelector;

@end



@protocol HNReleaseable
/*!
 *
 */
- (id) retain;


/*!
 *
 */
- (id) release;


/*!
 *
 */
- (unsigned int) retainCount;
@end



@protocol HNCopyable

/*!
 * レシーバのコピーを返します。
 */
- (id) copy;


/*!
 * レシーバの浅いコピーを返します。
 */
- (id) shallowCopy;


/*!
 * レシーバの深いコピーを返します。
 */
- (id) deepCopy;


/*!
 * コピー元を返します。
 */
- (id) postCopy;

@end



/*!
 * Hezelnut のクラスの全ての基本クラスです。
 */
@interface HNObject <HNObject>
{
    Class prototype_;
}


/*!
 * 
 */
+ (void) initialize;


/*!
 *
 */
+ (IMP) instanceMethodForSelector: (SEL)a_selector;


/*!
 * 
 */
+ (Class) class;


/*!
 * オブジェクトを生成して返します。
 */
+ (id) alloc;


/*!
 *
 */
+ (id) allocWithZone: (HNZone *)aZone;


/*!
 *
 */
+ (id) new;


/*!
 *
 */
+ (id) newWithZone: (HNZone *)aZone;


/*!
 *
 */
- (id) init;


/*!
 *
 */
- (void) dealloc;


/*!
 * これまでに使用されていた全てのリソースを開放します。
 */
- (void) finalize;


/*!
 * レシーバのコピーを返します。
 */
- (id) copy;


/*!
 * レシーバの浅いコピーを返します。
 */
- (id) shallowCopy;


/*!
 * レシーバの深いコピーを返します。
 */
- (id) deepCopy;


/*!
 * コピー元を返します。
 */
- (id) postCopy;


/*!
 *
 */
- (HNUInteger) hash;


/*!
 * レシーバと an_object が等しければ真を返します。
 * 
 * \param an_object 比較したい別のオブジェクト。
 */
- (BOOL) equals: (id)an_object;


/*!
 * レシーバと an_object が等しければ真を返します。
 */
- (BOOL) identityEquals: (id)an_object;


/*!
 *
 */
- (BOOL) isKindOf: (Class)a_class;


/*!
 *
 */
- (BOOL) isMemberOf: (Class)a_class;


/*!
 *
 */
- (BOOL) isNil;


/*!
 *
 */
- (BOOL) notNil;


/*!
 *
 */
- (BOOL) respondsToSelector: (SEL)aSelector;


/*!
 *
 */
- (id) retain;


/*!
 *
 */
- (id) release;


/*!
 *
 */
- (HNUInteger) retainCount;


@end


/*!
 *
 */
HN_API id hn_allocate_object(Class a_class, HNUInteger extra_bytes, HNZone* zone);


/*!
 *
 */
HN_API void hn_deallocate_object(id an_object);


#if !NO_ANOTHERSTEP && !defined(ANOTHERSTEP_BASE_INTERNAL)
#   import <AnotherStepBase/HNObject+AnotherStepBase.h>
#endif  /* NO_ANOTHERSTEP && !defined(ANOTHERSTEP_BASE_INTERNAL) */


// Local Variables:
//   mode: objc
//   coding: utf-8
// End:
