//  
//  HNRandom.h
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
#ifndef Hezelnut_HNRandom_h
#define Hezelnut_HNRandom_h

#import <hezelnut/HNStream.h>


/*!
 * \interface HNRandom  HNRandom.h
 */
@interface HNRandom : HNStream
{
 @private
    id state_;
}
/*!
 * 
 */
+ (int) mtSize;


/*! \name instance creation
  
 */
/*! @{ */
/*!
 *
 */
+ (id) seed: (int)an_integer;


/*!
 *
 */
+ (id) new;
/*! @} */


/*! \name shortcuts
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) source;


/*!
 * 
 */
+ (double) next;


/*!
 * 
 */
+ (int) between: (int)low and: (int)high;
/*! @} */


/*! \name testing
  
 */
/*! @{ */
/*!
 * 
 */
- (double) chiSquare;
/*!
 * 
 */
- (double) chiSquare: (int)n range: (int)r;
/*! @} */


/*! \name basic
  
 */
/*! @{ */
/*!
 * このストリームは終わりがありません。偽を返します。
 */
- (BOOL) atEnd;


/*!
 * low から high までの整数の乱数を返します。
 */
- (int) between: (int)low and: (int)high;


/*!
 * 最大 32 bit の乱数を返します。
 */
- (double) next;
/*! @} */
@end


#endif  /* Hezelnut_HNRandom_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
