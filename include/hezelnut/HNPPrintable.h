//  
//  HNPCollectable.h
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
// 
#ifndef hezelnut_HNPPrintable_h
#define hezelnut_HNPPrintable_h


/*! \protocol HNPPrintable HNPPrintable.h
  \file HNPPrintable.h
  \auther ned rihine <ned.rihine@gmail.com>
 */
@protocol HNPPrintable
#ifdef HEZELNUT_HAVE_STREAM
/*!
 * 
 */
- (id <HNPString>) printString;


/*!
 * 
 */
- (id) printOn: (HNStream *)a_stream;
#endif  /* def HEZELNUT_HAVE_STREAM */


#ifdef HEZELNUT_HAVE_TRANSCRIPT
/*!
 * 
 */
- (id) print;


/*!
 * 
 */
- (id) printNl;
#endif  /* def HEZELNUT_HAVE_TRANSCRIPT */
@end


#endif  /* hezelnut_HNPPrintable_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
