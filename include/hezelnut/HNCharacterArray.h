//  
//  HNCharacterArray.h
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

#import <hezelnut/HNArrayedCollection.h>

/*!
 * \interface HNCharacterArray HNCharacterArray.h
 * \since 2011-12-22
 */
@interface HNCharacterArray : HNArrayedCollection
/*! \name basic
  
 */
/*! @{ */
/*!
 * 
 */
+ (id) fromString: (HNCharacterArray *)character_array;


/*!
 * 
 */
+ (id) lineDelimiter;


/*!
 * 
 */
+ (BOOL) isUnicode;
/*! @} */


/*! \name comparing
  
 */
/*! @{ */
/*!
 *
 */
- (BOOL) equals: (id)a_string;


/*!
 *
 */
- (BOOL) lessThan: (id)a_character_array;


/*!
 *
 */
- (BOOL) lessOrEqual: (id)a_character_array;


/*!
 *
 */
- (BOOL) greaterThan: (id)a_character_array;


/*!
 *
 */
- (BOOL) greaterOrEqual: (id)a_character_array;


/*!
 * 
 */
- (BOOL) sameAs: (id)a_character_array;


/*!
 * 
 */
- (BOOL) match: (id)a_character_array;
/*!
 * 
 */
- (BOOL) match: (id)a_character_array ignoreCase: (BOOL)a_boolean;


/*!
 * 
 */
- (HNRange *) indexOf: (id)a_character_array matchCase: (BOOL)a_boolean startingAt: (int)an_index;
/*! @} */


/*! \name multibyte encodings
  
 */
/*! @{ */
/*!
 * 
 */
- (BOOL) isUnicode;


/*!
 * 
 */
- (id) encoding;


/*!
 * 
 */
- (id) numberOfCharacters;
/*! @} */


/*! \name string processing
  
 */
/*! @{ */
/*!
 * 
 */
- (id) contractTo: (int)small_size;


/*!
 * 
 */
- (id) lines;


#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (id) linesDo: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
 * 
 */
- (id) substrings;
/*!
 * 
 */
- (id) substrings: (id)separator;


/*!
 * 
 */
- (id) substringsChar: (HNCharacter *)separator_char;


/*!
 * 
 */
- (id) subStrings;
/*!
 * 
 */
- (id) subStrings: (id)separator;


/*!
 * 
 */
- (id) subStringsChar: (HNCharacter *)separator_char;


/*!
 * 
 */
- (id) bindWith: (id)param1;
/*!
 * 
 */
- (id) bindWith: (id)param1 with: (id)param2;
/*!
 * 
 */
- (id) bindWith: (id)param1 with: (id)param2 with: (id)param3;
/*!
 * 
 */
- (id) bindWith: (id)param1 with: (id)param2 with: (id)param3 with: (id)param4;


/*!
 * 
 */
- (id) bindWithArguments: (HNCollection *)a_collection;


/*!
 * 
 */
- (id) printf: (HNCollection *)a_collection;
/*! @} */


/*! \name converting
  
 */
/*! @{ */
/*!
 * 
 */
- (HNNumber *) asNumber;


/*!
 * 
 */
- (id) asUnicodeString;


/*!
 * 
 */
- (id) asUppercase;


/*!
 * 
 */
- (id) asLowercase;


/*!
 * 
 */
- (HNString *) asString;


#ifdef HEZELNUT_HAVE_SYMBOL
/*!
 * 
 */
- (HNSymbol *) asSymbol;


/*!
 * 
 */
- (HNSymbol *) asGlobalKey;


/*!
 * 
 */
- (HNSymbol *) asPoolKey;


/*!
 * 
 */
- (HNSymbol *) asClassPoolKey;
#endif  /* def HEZELNUT_HAVE_SYMBOL */


/*!
 * 
 */
- (HNByteArray *) asByteArray;


/*!
 * 
 */
- (HNInteger *) asInteger;


/*!
 * 
 */
- (id) fileName;


/*!
 * 
 */
- (id) filePos;


/*!
 * 
 */
- (BOOL) isNumeric;


/*!
 * 
 */
- (id) trimSeparators;
/*! @} */


/*! \name testing functionality
  
 */
/*! @{ */
/*!
 * 
 */
- (BOOL) isCharacterArray;
/*! @} */


/*! \name built ins
  
 */
/*! @{ */
/*!
 * 
 */
- (id) valueAt: (int)an_index;
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (id) valueAt: (int)an_index ifAbsent: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*!
 * 
 */
- (id) valueAt: (int)an_index ifNone: (id)except_element;
/*!
 * 
 */
- (id) valueAt: (int)an_index put: (id)value;
/*! @} */


/*! \name private
  
 */
/*! @{ */
/*!
 * 
 */
- (int) caseInsensitiveCompareTo: (id)a_character_array;


/*!
 *
 */
- () matchSubstring: (int)pp in: (id)a_character_array at: (int)an_index;
/*! @} */
@end


// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
