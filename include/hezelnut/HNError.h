//  
//  HNError.h
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
#ifndef Hezelnut_HNError_h
#define Hezelnut_HNError_h

#import <hezelnut/HNObject.h>


@class HNString;


@interface HNError : HNObject
/*! \name instance creation
  
 */
/*!
 *
 */
+ (id) signal;
/*!
 *
 */
+ (id) signal: (HNString *)message_text;
/*! @} */
@end


#endif  /* Hezelnut_HNError_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
