//  
//  HNArray.h
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
#ifndef Hezelnut_HNArray_h
#define Hezelnut_HNArray_h

#import <hezelnut/HNArrayedCollection.h>


/*!
 * \interface HNArray HNArray.h
 * \since 2011-11-27
 */
@interface HNArray : HNArrayedCollection
/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) from: (HNArrayedCollection *)an_array;
/*! @} */


/*! \name built ins
  
 */
/*! @{ */
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
- (id) at: (int)an_index ifAbsent: a_block;
#else
- (id) at: (int)an_index ifAbsent: (hn_action0_functor)a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


#ifdef HEZELNUT_HAVE_BYTE_ARRAY
/*!
 * 
 */
- (id) replaceFrom: (int)start_index to: (int)stop_index with: (HNByteArray *)byte_array startingAt: (int)replace_start_index;
#endif  /* def HEZELNUT_HAVE_BYTE_ARRAY */
/*! @} */


/*! \name printing
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_STREAM
/*!
 *
 */
- (id) printOn (HNStream *)a_stream;


/*!
 *
 */
- (id) storeLiteralOn: (HNStream *)a_stream;


/*!
 *
 */
- (id) storeOn: (HNStream *)a_stream;
#endif  /* def HEZELNUT_HAVE_STREAM */


/*!
 * 
 */
- (BOOL) isLiteralObject;
/*! @} */


/*! \name mutating objects
  
 */
/*! @{ */
/*!
 * 
 */
- (id) multiBecome: (HNArrayedCollection *)an_array;
/*! @} */


/*! \name testing
  
 */
/*! @{ */
/*!
 * 真を返します。
 */
- (BOOL) isArray;
/*! @} */
@end


#define    HEZELNUT_HAVE_ARRAY    1


#endif  /* Hezelnut_HNArray_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
