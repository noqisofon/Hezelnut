//  
//  HNObjectMemory.h
//  
//  Auther:
//       ned rihine <ned.rihine@gmail.com>
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

#import <hezelnut/HNObject.h>


@interface HNObjectMemory : HNObject
/*! \name initialization
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_SYMBOL
/*!
 * 
 */
+ (id) changed: (HNSymbol *)a_symbol;
#endif  /* def HEZELNUT_HAVE_SYMBOL */


/*!
 * 
 */
+ (id) initialize;
/*! @} */


/*! \name accessing
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) current;
/*! @} */


/*! \name builtins
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) addressOf: (id)an_object;


/*!
 * 
 */
+ (id) addressOfOOP: (id)an_object;


/*!
 * 
 */
+ (id) scavenge;


/*!
 * 
 */
+ (id) globalGarbageCollect;


/*!
 * 
 */
+ (id) compact;


/*!
 * 
 */
+ (id) incrementalGCStep;


/*!
 * 
 */
+ (id) finishIncrementalGC;


/*!
 * 
 */
+ (id) abort;


/*!
 * 
 */
+ (id) quit;
/*!
 * 
 */
+ (id) quit: (int)exit_status;
/*! @} */
@end


// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
