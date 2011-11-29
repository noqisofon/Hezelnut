//  
//  HNSequenceableCollection.h
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
#ifndef Hezelnut_HNSequenceableCollection_h
#define Hezelnut_HNSequenceableCollection_h

#import <hezelnut/HNCollection.h>


/*!
 * \interface HNSequenceableCollection HNSequenceableCollection.h
 * \since 2011-11-28
 */
@interface HNSequenceableCollection : HNCollection
/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 
 */
- (id) join: (HNCollection *)a_collection separatedBy: (HNSequenceableCollection *)seq_collection;
/*! @} */


/*! \name testing
  
 */
/*! @{ */
/*!
 * 
 */
- (id) examineOn: (id <HNPStreamable>)a_stream;


/*!
 * 真を返します。
 */
- (BOOL) isSequenceable;


/*!
 * 
 */
- (BOOL) equals: (id <HNCollectable>)a_collection;


/*!
 * 
 */
- (int) hash;
/*! @} */


/*! \name comparing
  
 */
/*! @{ */
/*!
 * 
 */
- (BOOL) endsWith: (id <HNPSequenceable>)a_sequenceable_collection;


/*!
 * 
 */
- (BOOL) startsWith: (id <HNPSequenceable>)a_sequenceable_collection;
/*! @} */


/*! \name basic
  
 */
/*! @{ */
#ifndef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (id) at: (int)an_index ifAbsent: a_block;
#else
/*!
 * 
 */
- (id) at: (int)an_index ifAbsent: (HNFilterBlock *)a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */

/*! @} */
@end


#endif  /* Hezelnut_HNSequenceableCollection_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
