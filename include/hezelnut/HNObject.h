//  
//  HNObject.h
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
#ifndef Hezelnut_HNObject_h
#define Hezelnut_HNObject_h

#import <objc/Object.h>


/*!
 * \interface HNObject HNObject.h
 * \brief Hezelnut 内の全てのクラスのスーパークラスです。
 * \author ned rihine
 * \since 2011-11-24
 */
@interface HNObject : Object
{
  HNClass hn_is_a;
}
/*! \name initialization
  
 */
/*! @{ */
/*!
 *
 */
+ (id) update: (id)aspect;


/*!
 *
 */
+ (id) dependencies;
/*!
 *
 */
+ (id) dependencies: (id)an_object;


#ifdef HEZELNUT_HAVE_SET
/*!
 *
 */
+ (id) finalizableObjects;
#endif  /* def HEZELNUT_HAVE_SET */


#if defined(HEZELNUT_HAVE_WEAK_KEY_IDENTITY_DICTIONARY) && defined(HEZELNUT_HAVE_OBJECT_MEMORY)
/*!
 *
 */
+ (id) initialize;
#endif  /* defined(HEZELNUT_HAVE_WEAK_KEY_IDENTITY_DICTIONARY) && defined(HEZELNUT_OBJECT_MEMORY) */
/*! @} */


/*! \name testing functionality
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_CLASS
/*!
 * 
 */
- (BOOL) isKindOf: (HNClass *)a_class;


/*!
 * 
 */
- (BOOL) isMemberOf: (HNClass *)a_class;
#endif  /* def HEZELNUT_HAVE_CLASS */


#ifdef HEZELNUT_HAVE_SYMBOL
/*!
 *
 */
- (BOOL) respondsTo: (HNSymbol *)a_symbol;
#endif  /* def HEZELNUT_HAVE_SYMBOL */


/*!
 * レシーバが nil の場合、偽を返します。
 */
- (BOOL) isNil;


/*!
 * レシーバが nil 以外の場合、偽を返します。
 */
- (BOOL) notNil;
/*! @} */


/*! \name copying
  
 */
/*! @{ */
/*!
 *
 */
- (id) copy;


/*!
 * コピー元を返します。
 */
- (id) postCopy;


/*!
 *
 */
- (id) deepCopy;
/*! @} */


/*! \name class type methods
  
 */
#ifdef HEZELNUT_HAVE_CLASS
/*! @{ */
/*!
 *
 */
- (HNClass *) species;
#endif  /* def HEZELNUT_HAVE_CLASS */


/*!
 *
 */
- (id) yourself;
/*! @} */


/*! \name dependents access
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_ORDERED_COLLECTION
/*!
 * 
 */
- (id) addDependent: (id)an_object;


/*!
 * 
 */
- (id) removeDependent: (id)an_object;


/*!
 * 
 */
- (HNOrderedCollection *) dependents;
#endif  /* HEZELNUT_HAVE_ORDERED_COLLECTION */

/*!
 * レシーバの依存リストを削除し、受信側がガベージコレクトされるようにします。
 */
- (void) release;
/*! @} */


/*! \name finalization
  
 */
/*! @{ */
/*!
 * ガベージコレクタがそれへの弱参照だけが見つかった時に #finalize がオブジェクトに送信されるように整理します。
 */
- (id) addToBeFinalized;


/*!
 * ガベージコレクタがそれへの弱参照だけが見つかった時 #finalize がもはやオブジェクトに送信されないようにオブジェクトの登録を解除します。
 */
- (id) removeToBeFinalized;


/*!
 * それらのフィールドのうち 1 つが収集可能なゴミであるとわかる場合、このメソッドは弱い短命なオブジェクトに VM によって送られます。デフォルトでは何もしません。
 */
- (void) mourn;


/*!
 * デフォルトでは何もしません。
 */
- (void) finalize;
/*! @} */


/*! \name change and update
  
 */
/*! @{ */
/*!
 * レシーバの依存オブジェクトに、レシーバを渡して update: を送ります。
 */
- (id) changed;
/*!
 * レシーバの依存オブジェクトに、a_parameter を渡して update: を送ります。
 */
- (id) changed: (id)a_parameter;


/*!
 * デフォルトでは何もしません。
 */
- (id) update: (id)a_parameter;


#ifdef HEZELNUT_HAVE_SYMBOL
/*!
 * レシーバの依存オブジェクトに、a_symbol 単項メッセージを送ります。
 */
- (id) broadcast: (HNSymbol *)a_symbol;
/*!
 * レシーバの依存オブジェクトに、an_object を渡して a_symbol 二項メッセージを送ります。
 */
- (id) broadcast: (HNSymbol *)a_symbol with: (id)an_object;
/*!
 * レシーバの依存オブジェクトに、arg1 と arg2 を渡して a_symbol 三項メッセージを送ります。
 */
- (id) broadcast: (HNSymbol *)a_symbol with: (id)arg1 with: (id)arg2;
#   ifdef HEZELNUT_ENABLE_BLOCK
/*!
 *
 */
- (id) broadcast: (HNSymbol *)a_symbol withBlock: a_block;
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
#   ifdef HEZELNUT_HAVE_CONSTANT_ARRAY
/*!
 *
 */
- (id) broadcast: (HNSymbol *)a_symbol withArguments: (HNConstantArray *)an_array;
#   endif  /* def HEZELNUT_HAVE_CONSTANT_ARRAY */
#endif  /* def HEZELNUT_HAVE_SYMBOL */
/*! @} */


/*! \name printing
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_STREAM
/*!
 *
 */
- (id <HNPString>) displayString;


/*!
 * 
 */
- (id) - displayOn: (HNStream *)a_stream;
#endif  /* def HEZELNUT_HAVE_STREAM */


#ifdef HEZELNUT_HAVE_TRANSCRIPT
/*!
 * 
 */
- (id) display;


/*!
 * 
 */
- (id) displayNl;
#endif  /* def HEZELNUT_HAVE_TRANSCRIPT */


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


/*!
 * 
 */
- (id <HNPString>) basicPrintOn: (HNPStreaming *)a_stream;


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


/*!
 * 
 */
- (id) basicPrintNl;
/*! @} */


/*! \name storing
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_STREAM
/*!
 * 
 */
- (id <HNPString>) storeString;


/*!
 * 
 */
- (id) storeLiteralOn: (HNStream *)a_stream;


/*!
 * 
 */
- (id) storeOn: (HNStream *)a_stream;


#   ifdef HEZELNUT_HAVE_TRANSCRIPT
/*!
 * 
 */
- (id) store;


/*!
 * 
 */
- (id) storeNl;
#   endif  /* def HEZELNUT_HAVE_TRANSCRIPT */
#endif  /* def HEZELNUT_HAVE_STREAM */
/*! @} */


/*! \name saving and loading
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_OBJECT_DUMP
/*!
 * 
 */
- (id) binaryRepresentationObject;
#endif  /* def HEZELNUT_HAVE_OBJECT_DUMP */


/*!
 * デフォルトでは何もしません。
 */
- (id) postLoad;


/*!
 * デフォルトでは何もしません。
 */
- (id) postStore;


/*!
 * デフォルトでは何もしません。
 */
- (id) preStore;


/*!
 * 
 */
- (id) reconstructOriginalObject;
/*! @} */


/*! \name debugging
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_TRANSCRIPT
/*!
 * HNTranscript にレシーバの全てのインスタンス変数を表示させます。
 */
- (id) examine;


#   ifdef HEZELNUT_HAVE_STREAM
/*!
 * 
 */
- (id) examineOn: (HNStream *)a_stream;
#   endif  /* def HEZELNUT_HAVE_STREAM */


/*!
 * 
 */
- (id) inspect;
#endif  /* def HEZELNUT_HAVE_TRANSCRIPT */


/*!
 * 
 */
- (int) validSize;
/*! @} */


/*! \name built ins
  VM 側で定義しているメソッドを呼び出すだけのメソッドです。
 */
/*! @{ */
/*!
 * レシーバを参照するオブジェクトの配列を返します。
 */
- (id <HNPCollectable>) allOwners;


#ifdef HEZELNUT_HAVE_BEHAVIOR
/*!
 * a_begavior に合わせてレシーバのクラスを変更します。
 * <p>
 * 暗黙のうちに構造がオリジナルのクラスと同じであることを前提としています。
 * </p>
 */
- (void) changeClassTo: (HNBehavior *)a_behavior;
#endif  /* def HEZELNUT_HAVE_BEHAVIOR */


#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (id) checkIndexableBounds: (int)index ifAbsent: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*! @} */
@end


#endif  /* Hezelnut_HNObject_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
