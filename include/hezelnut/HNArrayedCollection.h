//  
//  HNArrayedCollection.h
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
#ifndef Hezelnut_HNArrayedCollection_h
#define Hezelnut_HNArrayedCollection_h

#import <hezelnut/HNSequenceableCollection.h>


/*!
 * \interface HNArrayedCollection HNArrayedCollection.h
 * \since 2011-11-27
 */
@interface HNArrayedCollection : HNSequenceableCollection
/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) new: (unsigned int)size withAll: (id)an_object;


#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
+ (id) streamContents: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
+ (id) with: (id)element1;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4 with: (id)element5;
/*!
 * 
 */
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4 with: (id)element5 with: (id)element6;


/*!
 * 
 */
+ (id) withAll: (id <HNPCollectable>)a_collection;


/*!
 * 
 */
+ (id) join: (id <HNPCollectable>)a_collection;
/*!
 * 
 */
+ (id) join: (id <HNPCollectable>)a_collection separatedBy: (id <HNPCollectable>)sep_collection;
/*! @} */


/*! \name basic
  
 */
/*! @{ */
/*!
 * 定義されていません。
 */
- (id) add: (id)value;


/*!
 * レシーバと a_seqeuenceable_collection を結合した HNArrayedCollection オブジェクトを返します。
 */
- (id) concat: (id <HNPSeqeuenceable>)a_seqeuenceable_collection;


/*!
 * key_collection の要素をインデックス値として抜き出したコレクションを返します。
 */
- (id) atAll: (id <HNPCollection>)key_collection;


/*!
 * レシーバの start 番目から stop 番目までを含んだコレクションを返します。
 */
- (id) copyFrom: (int)start to: (int)stop;


/*!
 * レシーバの全ての要素の後に an_element を追加したコレクションを作って返します。
 */
- (id) copyWith: (id)an_element;


/*!
 * レシーバの要素から、old_element 以外を含んだコレクションを返します。
 */
- (id) copyWithout: (id)old_element;
/*! @} */


/*! \name enumerating the elements of a collection
  
 */
/*! @{ */
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * a_block で真が返された全ての要素を新しい HNArrayedCollection オブジェクトに格納して返します。
 */
- (id) select: a_block;


/*!
 * a_block で偽が返された全ての要素を新しい HNArrayedCollection オブジェクトに格納して返します。
 */
- (id) reject: a_block;


/*!
 * a_block をレシーバの全ての要素に適用します。
 */
- (id) collect: a_block;


/*!
 * 
 */
- (id) with: (id <HNPSeqeuenceable>)a_seqeuenceable_collection collect: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*! @} */


/*! \name copying collections
  
 */
/*! @{ */
/*!
 * 
 */
- (id) copyReplaceFrom: (int)start to: (int)stop withObject: (id)an_object;


/*!
 * 
 */
- (id) copyReplaceAll: (id <HNPCollectable>)old_sub_collection with: (id <HNPCollectable>)new_sub_collection;


/*!
 * 
 */
- (id) reverse;
/*! @} */


/*! \name sorting
  
 */
/*! @{ */
/*!
 * レシーバの要素を #<= を使ってソートした結果を返します。
 */
- (id) sorted;
/*!
 * レシーバの要素を a_block を使ってソートした結果を返します。
 */
- (id) sorted: (HNComparisonBlock)a_block;
/*! @} */


/*! \name storing
  
 */
/*! @{ */
/*!
 * 
 */
- (id) storeOn: (id <HNPStreamable>)a_stream;
/*! @} */


/*! \name private
  
 */
/*! @{ */
/*!
 * レシーバの空のコピーを作って返します。
 */
- (id) copyEmpty;


/*!
 * 配列の長さを伸ばします。
 */
- (id) grow;


/*!
 * 
 */
- (id) growBy: (ind)delta;


/*!
 * レシーバの new_size だけ伸ばしたコピーを返します。
 */
- (id) copyGrowTo: (int)new_size;
/*! @} */


/*! \name streams
  
 */
/*! @{ */
#ifdef HEZELNUT_HAVE_WRITE_STREAM
/*!
 * 
 */
- (HNWriteStream *)writeStream;
#endif  /* def HEZELNUT_HAVE_WRITE_STREAM */
/*! @} */


/*! \name built ins
  
 */
/*! @{ */
/*!
 * 
 */
- (int) size;
/*! @} */
@end


#endif  /* Hezelnut_HNArrayedCollection_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
