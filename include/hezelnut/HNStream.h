//  
//  HNPStream.h
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
#ifndef hezelnut_HNPStream_h
#define hezelnut_HNPStream_h

#import <hezelnut/HNObject.h>
//#import <hezelnut/HNPStreamable.h>


@class IOChannel;
@class HNSequenceableCollection;
@class HNString;


@interface HNStream : HNObject /*< HNPStreamable >*/
/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 例外が発生します。
 * <p>
 * ストリームでは on: または with: でインスタンスを作成します。
 * </p>
 */
+ (id) new;
/*! @} */


/*! \name accessing reading
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_IOCHANNEL
/*!
 * ストリームの元になったファイルを返します。
 */
- (IOChannel *) file;
#endif  /* def HEZELNUT_HAVE_IOCHANNEL */


/*!
 * ストリームの元になったっぽい名前を返します？
 */
- (id) name;


/*!
 * "a stream" を返します。
 */
- (HNString *) localName;


/*!
 * 実装されていません。
 */
- (void *) binary;


/*!
 * 実装されていません。
 */
- (HNSequenceableCollection *) contents;


/*!
 * デフォルトでは何もしません。
 */
- (id) flush;


/*!
 * 次のオブジェクトにアクセスします。
 */
- (id) next;
#ifdef HEZELNUT_HAS_OREDEREDCOLLECTION
/*!
 * 次の an_integer 個のオブジェクトを HNOrderedCollection オブジェクトに格納して返します。
 */
- (HNOrderedCollection *) next: (int)an_integer;
#endif  /* def HEZELNUT_HAS_OREDEREDCOLLECTION */
/*!
 * an_integer 回 an_object を書き込みます。
 */
- (id) next: (int)an_integer put: (id)an_oject;


/*!
 * ストリームの内容が a_collection と一致するなら真を返します。
 */
- (BOOL) nextMatchAll: (HNCollection *)a_collection;


/*!
 * an_object と次のオブジェクトが一致すれば真を返します。
 */
- (BOOL) nextMatchFor: (id)an_object;


/*!
 * an_object を書き出します。
 */
- (id) nextPut: (id)an_object;


/*!
 * a_collection の全ての要素を書き出します。
 */
- (id) nextPutAll: (HNCollection *)a_collection;


/*!
 * 自分自身を返します。
 */
- (id) readonly;


#if defined(HEZELNUT_HAS_OREDEREDCOLLECTION) && defined(HEZELNUT_HAS_WRITESTREAM)
/*!
 * ストリームの最後までを HNOrderedCollection オブジェクトに格納して返します。
 */
- (HNOrderedCollection *) upToEnd;



/*!
 * 
 */
- (HNOrderedCollection *) nextLine;
#endif  /* defined(HEZELNUT_HAS_OREDEREDCOLLECTION) && defined(HEZELNUT_HAS_WRITESTREAM) */


/*!
 * 
 */
- (HNCollection *) nextAvailable: (int)an_integer;
/*!
 * 
 */
- (int) nextAvailable: (int)an_integer putAllOn: (HNStream *)a_stream;
/*!
 *
 */
- (int) nextAvailable: (int)an_integer into: (HNCollection *)a_collection statingAt: (int)pos;


#ifdef HEZELNUT_HAVE_OREDEREDCOLLECTION
/*!
 *
 */
- (HNOrderedCollection *) splitAt: (id)an_object;
#endif  /* def HEZELNUT_HAVE_IOCHANNEL */
/*! @} */


/*! \name buffering
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_OREDEREDCOLLECTION
/*!
 * an_integer の数だけ レシーバ から読み出して a_stream に書き込みます。
 * \return 読み出すことができた要素の数。
 */
- (int) next: (int)an_integer putAllOn: (HNStream *)a_stream;
/*!
 * ストリームから要素を an_integer 個呼び出して answer に格納します。pos から始めます。
 */
- (HNOrderedCollection *) next: (int)an_integer into: (HNOrderedCollection *)answer startingAt: (int)pos;
#endif  /* def HEZELNUT_HAVE_IOCHANNEL */
/*! @} */


/*! \name enumerating
  
 */
/*! @{ */
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * オブジェクトにアクセス可能な間 a_block を評価します。
 */
- do: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*! @} */


/*! \name printing
  
 */
/*! @{ */
/*!
 * an_object を書き出します。
 */
- (id) print: (id)an_object;


/*!
 * an_object を HTML 形式で書き出します。
 */
- (id) printHtml: (id)an_object;
/*! @} */


/*! \name filter streaming
  
 */
/*! @{ */
/*!
 * encoded_object を書き出します。
 */
- (id) write: (id)encoded_object;
/*! @} */


/*! \name alternate syntax
  
 */
/*! @{ */
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * ブロック a_block を評価した結果を返します。
 */
- (id) withStyleFor: (id)element_type do: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*! @} */
@end


#define   HEZELNUT_HAVE_STREAM   1


#endif  /* hezelnut_HNPStream_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
