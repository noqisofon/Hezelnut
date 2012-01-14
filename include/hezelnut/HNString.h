//  
//  HNString.h
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

#import <hezelnut/HNCharacterArray.h>


/*!
 * 
 */
@interface HNString : HNCharacterArray
/*! \name instance creation
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) fromCData: (HNCObject *)a_cobject;
/*!
 * 
 */
+ (id) fromCData: (HNCObject *)a_cobject size: (int)an_integer;
/*! @} */


/*! \name multibyte encodings
  
 */
/*! @{ */
/*!
 * 
 */
+ (bool) isUnicode;
/*! @} */


/*! \name basic
  
 */
/*! @{ */
/*!
 * 
 */
- (bool) equals: (HNCollection *)a_collection;


/*!
 * 
 */
- (id) concat: (HNString *)a_string;


/*!
 * 
 */
- (int) indexOf: (char)an_element startingAt: (int)an_index;
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (int) indexOf: (char)an_element startingAt: (int)an_index ifAbsent: except_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*!
 * 
 */
- (int) indexOf: (char)an_element startingAt: (int)an_index ifNone: (int)except_value;
/*! @} */


/*! \name converting
  
 */
/*! @{ */
/*!
 * 
 */
- (id) encoding;


/*!
 * 
 */
- (HNByteArray *) asByteArray;


/*!
 * 
 */
- (HNSymbol *) asSymbol;


/*!
 * 
 */
- (HNString *) asString;
/*! @} */


/*! \name testing functionality
  
 */
/*! @{ */
/*!
 * 
 */
- (BOOL) isString;
/*! @} */


/*! \name printing
  
 */
/*! @{ */
/*!
 * 
 */
- (HNString *) displayString;


/*!
 * 
 */
- (id) displayOn: (HNStream *)a_stream;


/*!
 * 
 */
- (BOOL) isLiteralObject;


/*!
 * 
 */
- (id) storeLiteralOn: (HNStream *)a_stream;


/*!
 * 
 */
- (id) storeOn: (HNStream *)a_stream;


/*!
 * 
 */
- (id) printOn: (HNStream *)a_stream; 
/*! @} */


/*! \name accessing
  
 */
/*! @{ */
/*!
 * 
 */
- (char) byteAt: (int)index;
/*!
 * 
 */
- (char) byteAt: (int)index put: (char)value;
/*! @} */


/*! \name built ins
  
 */
/*! @{ */
/*!
 * 
 */
- (int) hash;


/*!
 * 
 */
- (id) similarityTo: (HNString *)a_string;


/*!
 * 
 */
- (int) size;


/*!
 * 
 */
- (id) replaceFrom: (int)start to: (int)stop with: (HNString *)a_string startingAt: (int)replace_start;
/*!
 * 
 */
- (id) replaceFrom: (int)start to: (int)stop withByteArray: (HNByteArray *)byte_array startingAt: (int)replace_start;


/*!
 * 
 */
- (id) at: (int)an_index;
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (id) at: (int)an_index ifAbsent: ()a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*!
 * 
 */
- (id) at: (int)an_index ifNone: (id)element;
/*!
 * 
 */
- (id) at: (int)an_index put: (id)value;


/*!
 * 
 */
- (id) basicAt: (int)an_index;
/*!
 * 
 */
- (id) basicAt: (int)an_index put: (id)value;

#ifdef HEZELNUT_HAVE_CTYPE
/*!
 * 
 */
- (id) asCData: (HNCType *)a_ctype;
#endif  /* def HEZELNUT_HAVE_CTYPE */
/*! @} */


/*! \name CObject
  
 */
/*! @{ */
/*!
 * 
 */
- (id) asCData;
/*! @} */
@end


// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
