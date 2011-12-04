//  
//  HNSequenceableCollection.h
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
#ifndef Hezelnut_HNSequenceableCollection_h
#define Hezelnut_HNSequenceableCollection_h

#import <hezelnut/HNCollection.h>


@class HNStream;
@class HNWriteStream;
@class HNReadStream;
@class HNReadWriteStream;


/*!
 * \interface HNSequenceableCollection HNSequenceableCollection.h
 * \since 2011-11-28
 */
@interface HNSequenceableCollection : HNCollection
/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 
 */
- (id) join: (HNCollection *)a_collection separatedBy: (HNSequenceableCollection *)seq_collection;
/*! @} */


/*! \name testing
  
 */
/*! @{ */
/*!
 * 
 */
- (id) examineOn: (HNStream *)a_stream;


/*!
 * 真を返します。
 */
- (BOOL) isSequenceable;


/*!
 * 
 */
- (BOOL) equals: (HNCollection *)a_collection;


/*!
 * 
 */
- (int) hash;
/*! @} */


/*! \name comparing
  
 */
/*! @{ */
/*!
 * 
 */
- (BOOL) endsWith: (HNSequenceableCollection *)a_sequenceable_collection;


/*!
 * 
 */
- (BOOL) startsWith: (HNSequenceableCollection *)a_sequenceable_collection;
/*! @} */


/*! \name basic
  
 */
/*! @{ */
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
- (id) at: (int)an_index ifAbsent: (HNFilterBlock *)a_block;
#else
- (id) at: (int)an_index ifAbsent: (hn_filter0_functor)a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
- (id) atAll:(HNCollection *)key_collection;


/*!
 * 
 */
- (id) atAll:(HNCollection *)a_collection put: (id)an_object;


/*!
 * 全ての要素と an_object を置き換えます。
 */
- (id) atAllPut: (id)an_object;


/*!
 * old_object の前の要素を返します。
 */
- (id) after: (id)old_object;


/*!
 * 先頭の要素を除いたレシーバのコピーを作成して返します。
 */
- (id) allButFirst;
/*!
 * 先頭の n 個の要素を除いたレシーバのコピーを作成して返します。
 */
- (id) allButFirst: (int)n;


/*!
 * 末尾の要素を除いたレシーバのコピーを作成して返します。
 */
- (id) allButLast;
/*!
 * 末尾の n 個の要素を除いたレシーバのコピーを作成して返します。
 */
- (id) allButLast: (int)n;


/*!
 * 先頭の要素を返します。
 */
- (id) first;
/*!
 * 
 */
- (id) first: (int)n;


/*!
 * 二番目の要素を返します。
 */
- (id) second;


/*!
 * 三番目の要素を返します。
 */
- (id) third;


/*!
 * 四番目の要素を返します。
 */
- (id) fourth;


/*!
 * 末尾の要素を返します。
 */
- (id) last;
/*!
 * 
 */
- (id) last: (int)n;


/*!
 * 
 */
- (BOOL) includes: (id)an_object;


/*!
 * 
 */
- (BOOL) identityIncludes: (id)an_object;


/*!
 * 
 */
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection;
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection ifAbsent: (hn_filter0_functor)exception_block;
#else
/*!
 * 
 */
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection ifAbsent: (hn_filter0_functor)exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block;
#else
/*!
 * 
 */
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
- (int) indexOf: (id)an_element;
/*!
 * 
 */
- (int) indexOf: (id)an_element startingAt: (int)an_index;
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
- (int) indexOf: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) indexOf: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
- (int) indexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) indexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) indexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) indexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
- (int) identityIndexOf: (id)an_element;
/*!
 * 
 */
- (int) identityIndexOf: (id)an_element startingAt: (int)an_index;
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) identityIndexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) identityIndexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
- (int) identityIndexOfLast: (id)an_element;
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) identityIndexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) identityIndexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*! @} */


/*! \name replacing items
  
 */
/*! @{ */
/*!
 * an_object が入った要素を another_object で置き換えます。self を返します。
 */
- (id) replaceAll: (id)an_object with: (id)another_object;


/*!
 * start から stop まで、replacement_collection のそれぞれの要素で置き換えます。self を返します。
 */
- (id) replaceFrom: (int)start to: (int)stop with: (HNCollection *)replacement_collection;
/*!
 * an_index から stop_index まで、それぞれの要素を replacement_object で置き換えます。self を返します。
 */
- (id) replaceFrom: (int)an_index to: (int)stop withObject: (id)replacement_object;
/*!
 * start から stop まで、replacement_collection のそれぞれの要素で置き換えます。self を返します。
 */
- (id) replaceFrom: (int)start to: (int)stop with: (HNCollection *)replacement_collection startingAt: (int)replace_start;
/*! @} */


/*! \name copying SequenceableCollections
  
 */
/*! @{ */
/*!
 * 最初に見つかった an_object より後の要素から末尾までのコピーを新しく作成して返します。
 */
- (id) copyAfter: (id)an_object;


/*!
 * 最後に見つかった an_object より後の要素から末尾までのコピーを新しく作成して返します。
 */
- (id) copyAfterLast: (id)an_object;


/*!
 *
 */
- (id) copyUpTo: (id)an_object;


/*!
 *
 */
- (id) copyUpToLast: (id)an_object;


/*!
 *
 */
- (id) copyReplace: (int)start to: (int)stop withObject: (id)an_object;


/*!
 * 
 */
- (id) copyWithFirst: (id)an_object;


/*!
 * レシーバの start 番目の要素から末尾の要素までをコレクションを新しく作成して返します。
 */
- (id) copyFrom: (int)start;
/*!
 * レシーバの start 番目の要素から stop 番目の要素までをコレクションを新しく作成して返します。
 */
- (id) copyFrom: (int)start to: (int)stop;


/*!
 * 
 */
- (id) copyReplaceAll: (HNSequenceableCollection *)old_sub_collection with: (HNSequenceableCollection *)new_sub_collection;


/*!
 * 
 */
- (id) copyReplaceFrom: (int)start to: (int)stop with: (HNCollection *)replacement_collection;
/*! @} */


/*! \name concatenating
  
 */
/*! @{ */
/*!
 * 
 */
- (id) join: (HNSequenceableCollection *)sequence;
/*! @} */


/*!
 * 
 */
- (id) nextPutAllOn: (HNStream *)a_stream;


/*! \name enumerating
  
 */
/*! @{ */
/*!
 * 
 */
- (HNReadStream *) readStream;


/*!
 * 
 */
- (HNReadWriteStream *) readWriteStream;


/*!
 * 
 */
- (id) anyOne;


/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) do: a_block;
#else
- (id) do: (hn_action1_functor)a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) do: a_block separatedBy: separate_block;
#else
- (id) do: (hn_action1_functor)a_block separatedBy: (hn_action0_functor)separate_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) doWithIndex: a_block;
#else
- (id) doWithIndex: (hn_enumeration2_functor)a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) fold: a_block;
#else
- (id) fold: (hn_action2_functor)a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
- (id) keys;
/*! @} */
@end


#endif  /* Hezelnut_HNSequenceableCollection_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
