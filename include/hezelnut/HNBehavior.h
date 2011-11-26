//  
//  HNBehavior.h
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
#ifndef Hezelnut_HNBehavior_h
#define Hezelnut_HNBehavior_h

#import <hezelnut/HNObject.h>


/*!
 * \interface HNBehavior HNBehavior.h
 * \author ned rihine
 * \since 2011-11-26
 * \brief HNBehavior は全てのクラス型メソッドの親クラスです。
 */
@interface HNBehavior : HNObject
{
    id superclass_;
    id subclasses_;
    id method_dictionary_;
    id instance_spec_;
    id instance_variables_;
}
/*! \name instance variables
  
 */
/*! @{ */
/*!
 * レシーバのインスタンスに割り当てられたインスタンス変数を追加します。
 */
- (id) addInstVarName: (id <HNPString>)a_string;


/*!
 * レシーバから指定された名前のインスタンス変数を削除し、レシーバのサブクラス全てを<ins>再コンパイル</ins>再構成します。
 */
- (id) removeInstVarName: (id <HNPString>)a_string;


/*!
 * 
 */
- (id) instanceVariableNames: (id <HNPCollectable>)inst_var_names;
/*! @} */


/*! \name parsing class declarations
  
 */
/*! @{ */
/*!
 * a_string をパースしてインスタンス変数名の配列を返します。
 */
- (id) parseVariableString: (id <HNPString>)a_string;
/*! @} */


#ifdef HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER
/*! \name method dictionary
  
 */
/*! @{ */
/*!
 * 
 */
- (id) createGetMethod: (id <HNPString>)what;
/*!
 * 
 */
- (id) createGetMethod: (id <HNPString>)what default: (id <HNPString>)value;


/*!
 * 
 */
- (id) defineAsyncCFunc: (id <HNPString>)c_func_name_string withSelectorArgs: (id)selecter_and_args args: (id)args_array;
/*! @} */
#endif  /* def HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER */
@end


#endif  /* Hezelnut_HNBehavior_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
