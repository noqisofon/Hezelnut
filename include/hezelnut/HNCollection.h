//  
//  HNCollection.h
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
#ifndef Hezelnut_HNCollection_h
#define Hezelnut_HNCollection_h

#import <hezelnut/HNIteratable.h>


@class HNArray;


/*!
 * \interface HNCollection HNCollection.h
 * \since 2011-12-01
 */
@interface HNCollection : HNIteratable
/*! \name instance creation
 */
/*! @{ */
/*!
 * 
 */
+ (id) from: (HNArray *)an_array;


/*!
 * 
 */
+ (id) with: (id)an_object;
/*!
 * 
 */
+ (id) with: (id)first_object with: (id)second_object;
/*!
 * 
 */
+ (id) with: (id)first_object with: (id)second_object with: (id)third_object;
/*!
 * 
 */
+ (id) with: (id)first_object with: (id)second_object with: (id)third_object with: (id)fourth_object;
/*!
 * 
 */
+ (id) with: (id)first_object with: (id)second_object with: (id)third_object with: (id)fourth_object with: (id)fifth_object;


/*!
 * 
 */
+ (id) withAll: (HNCollection *)a_collection;
/*! @} */


/*! \name multibyte encodings
 */
/*! @{ */
/*!
 * 
 */
+ (BOOL) isUnicode;
/*! @} */


/*! \name copying SequenceableCollections
 */
/*! @{ */
/*!
 * 
 */
- (id) concat: (HNIteratable *)an_iteratable;
/*! @} */


/*! \name adding
 */
/*! @{ */
/*!
 * 
 */
- (id) add: (id)new_object;


/*!
 * 
 */
- (id) addAll: (HNCollection *)a_collection;
/*! @} */


/*! \name removing
 */
/*! @{ */
/*!
 * レシーバを空にします。self を返します。
 */
- (id) empty;


/*!
 * 
 */
- (id) remove: (id)old_object;
/*!
 * 
 */
- (id) remove: (id)old_object ifAbsent: (hn_filter0_functor)an_exception_block;


/*!
 * 
 */
- (id) removeAll: (HNCollection *)a_collection;
/*!
 * 
 */
- (id) removeAll: (HNCollection *)a_collection ifAbsent: (hn_filter0_functor)an_exception_block;


/*!
 * 
 */
- (id) removeAllSuchThat: (hn_enumeration1_functor)a_block;
/*! @} */


/*! \name testing collections
 */
/*! @{ */
/*!
 * 
 */
- (BOOL) isSequenceable;
/*! @} */
@end



#define    HEZELNUT_HAVE_COLLECTION    1


#endif  /* Hezelnut_HNCollection_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
