//  
//  HNArrayedCollection.h
//  
//  Auther:
//       Ned Rihine <ned.rihine@gmail.com>
// 
//  Copyright (c) 2011 rihine All rights reserved.
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
#ifndef Hezelnut_HNArrayedCollection_h
#define Hezelnut_HNArrayedCollection_h

#import <hezelnut/HNSequenceableCollection.h>


/*!
 * \interface HNArrayedCollection HNArrayedCollection.h
 * \since 2011-11-27
 */
@interface HNArrayedCollection : HNSequenceableCollection
/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) new: (unsigned int)size withAll: (id)an_object;


#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
+ (id) streamContents: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
+ (id) with: (id)element1;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4 with: (id)element5;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4 with: (id)element5 with: (id)element6;


/*!
 * 
 */
+ (id) withAll: (id <HNPCollectable>)a_collection;


/*!
 * 
 */
+ (id) join: (id <HNPCollectable>)a_collection;
/*!
 * 
 */
+ (id) join: (id <HNPCollectable>)a_collection separatedBy: (id <HNPCollectable>)sep_collection;
/*! @} */


/*! \name basic
  
 */
/*! @{ */
/*!
 * 定義されていません。
 */
- (id) add: (id)value;


/*!
 * レシーバと a_seqeuenceable_collection を結合した HNArrayedCollection オブジェクトを返します。
 */
- (id) concat: (id <HNPSeqeuenceable>)a_seqeuenceable_collection;


/*!
 * 
 */
- (id) atAll: (id <HNPCollection>)key_collection;
/*! @} */
@end


#endif  /* Hezelnut_HNArrayedCollection_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
