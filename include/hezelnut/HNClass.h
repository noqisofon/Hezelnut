//  
//  HNClass.h
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
#ifndef Hezelnut_HNClass_h
#define Hezelnut_HNClass_h

//#import <objc/typedstream.h>
#import <hezelnut/HNClassDescription.h>


@class HNArray;
@class HNString;
@class HNEnvironment;


/*!
 * \interface HNClass HNClass.h
 * \brief HNClass のインスタンスは実行中のアプリケーションのクラス情報を表します。
 * \author ned rihine
 * \since 2011-11-25
 */
@interface HNClass : HNClassDescription
{
  Class inner_;
@private
  HNString* name_;
  //HNString* comment_;
  HNEnvironment* environment_;
  HNString* category_;
  id class_variables_;
  id shared_pools_;
  id security_policy_;
  id pragma_handlers_;
}
/*! \name private
  
 */
/*! @{ */
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
+ (id) allPoolDictionaries: (HNCollection *)list except: (id)in_white do: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*! @} */


/*! \name initialize
  
 */
/*! @{ */
/*!
 * ルートクラスの特別な初期化を実行します。
 */
+ (void) initialize;
/*! @} */


/*! \name accessing instances and variables
  
 */
/*! @{ */
/*!
 * クラスの名前を返します。
 */
- (HNString *)name;


/*!
 * 
 */
- (id) environment;
/*!
 * 
 */
- (id) environment: (id)a_namespace;


/*!
 * このクラスのカテゴリを返します。
 */
- (HNString *) category;
/*!
 * このクラスのカテゴリを指定の文字列に変更します。
 */
- (id) category: (HNString *)a_string;


/*!
 * レシーバのスーパークラスを変更します。
 */
- (id) superclass: (HNClass)a_class;


/*!
 * クラスの変数辞書に指定された名前のクラス変数を追加します。
 */
- (id) addClassVarName: (HNString *)a_string;
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (id) addClassVarName: (HNString *)a_string value: a_block;
#else
/*!
 * 
 */
- (id) addClassVarName: (HNString *)a_string value: (id)a_object;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 指定された名前に対応するクラス変数の値を返します。
 */
- (id) bindingFor: (HNString *)a_string;


/*!
 * 指定された名前に対応するクラス変数を削除します。指定された名前のクラス変数が存在しない場合、エラーを送出します。
 */
- (id) removeClassVarName: (HNString *)a_string;


#ifdef HEZELNUT_HAVE_BINDING_DICTIONARY
/*!
 * クラス変数辞書を返します。
 */
- (HNDictionary *) classPool;
#endif  /* def HEZELNUT_HAVE_BINDING_DICTIONARY */


#ifdef HEZELNUT_HAVE_SET
/*!
 * クラス変数辞書に登録されているクラス変数の名前のセットを返します。
 */
- (HNSet *) classVarNames;


/*!
 * サブクラスのクラス変数辞書のクラス変数の名前も含めたセットを返します。
 */
- (HNSet *) allClassVarNames;


/*!
 * クラスのプール辞書に指定された共有プールを追加します？
 */
- (id) addSharedPool: (HNDictionary *)a_dictionary;


/*!
 * クラスで定義された共有プールを返します。
 */
- (HNSet *) sharedPool;
#endif  /* def HEZELNUT_HAVE_SET */


#ifdef HEZELNUT_HAVE_ARRAY
/*!
 * このクラスのファイルアウトで書かれているプラグマを返します。
 */
- (HNArray *) classPragmas;
#endif  /* HEZELNUT_HAVE_ARRAY */


/*!
 * ルートクラスに予約された特別な初期化を実行します。
 */
- (id) initializeAsRootClass;


/*!
 * 子クラスで再定義？
 */
- (id) initialize;
/*! @} */


/*! \name testing
  
 */
/*! @{ */
- (BOOL) equals: (id)a_class;
/*! @} */


/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 現在の名前空間内のレシーバのバージョンを再定義します。
 * <p>
 * システムクラスに送られる時にこのメソッドが各種の方法であなたをかまないように出
 * 来ますが、発生する可能性のある問題のいくつかの例については、マニュアル内の名前
 * 空間に関するセクションを読んでください。
 * </p>
 */
- (id) extend;


/*!
 * サブクラスはこのクラスと同じ形状を持っているかどうかを返します。デフォルトでは偽を返します。
 */
- (BOOL) inheritShape;
/*! @} */


/*! \name instance creation - alternative
  
 */
/*! @{ */
#ifdef HEZELNUT_OBSOLUTES
/*!
 * このメソッドを使用しないでください。IBM Smalltalk にしか存在しないメソッドです？
 */
- (id) categoriesFor: (id)method are: (id)categories;


/*!
 * このメソッドを使用しないでください。IBM Smalltalk にしか存在しないメソッドです？
 */
- (id) subclass: (id)classname_string instanceVariableNames: (id)class_variable_names classVarNames: string_of_class_var_names poolDictonaries: string_of_pool_names;
#endif  /* def HEZELNUT_OBSOLUTES */
/*! @} */
@end


#define    HEZELNUT_HAVE_CLASS    1


#endif  /* Hezelnut_HNClass_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
