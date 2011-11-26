//  
//  HNClassDescription.h
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
#ifndef Hezelnut_HNClassDescription_h
#define Hezelnut_HNClassDescription_h

#import <hezelnut/HNBehavior.h>


/*!
 * \interface HNClassDescription HNClassDescription.h
 * \author ned rihine
 * \since 2011-11-26
 * \brief HNClassDescription のインスタンスは、アクセスの種類別のクラス、そしてクラスの全カテゴリが外部ディスクファイルへの出力に提出できるようにするメソッドを提供します。
 */
@interface HNClassDescription : HNBehavior
#ifdef HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER
/*! \name organization of messages and classes
 */
/*! @{ */
/*!
 * 
 */
- (id) createGetMethod: (HNPString)what;
/*!
 * 
 */
- (id) createGetMethod: (HNPString)what default: (id)value;


/*!
 * 
 */
- (id) createSetMethod: (HNPString)what;
/*! @} */
#endif  /* def HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER */
@end


#endif  /* Hezelnut_HNClassDescription_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
