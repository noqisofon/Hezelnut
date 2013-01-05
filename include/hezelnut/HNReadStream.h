//  
//  HNReadStream.h
//  
//  Auther:
//       Ned Rihine <ned.rihine@gmail.com>
// 
//  Copyright (c) 2011-2012 rihine All rights reserved.
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
#ifndef Hezelnut_HNReadStream_h
#define Hezelnut_HNReadStream_h

#import <hezelnut/HNStream.h>

@class HNCollection;
@class HNString;


@interface HNReadStream : HNStream
/*! \name instance creation
  
 */
/*!
 *
 */
+ (id) on: (HNCollection *)a_collection;
/*!
 *
 */
+ (id) on: (HNCollection *)a_collection from: (int)first_index to: (int)last_index;
/*! @} */
@end


#endif  /* Hezelnut_HNReadStream_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
