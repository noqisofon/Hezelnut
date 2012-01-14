//  
//  HNCharacterArray.m
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


#import <hezelnut/HNCharacter.h>


#import <hezelnut/HNCharacterArray.h>


@implementation HNCharacterArray
+ (id) fromString: (HNCharacterArray *)character_array {
    return [ [ [ self new: [ character_array size ] ]
               replaceFrom: 0
                        to: [ character_array size ]
                      with: character_array
                startingAt: 0 ]
               yourself ];
}


+ (id) lineDelimiter {
    return [ self with: [ HNCharacter nl ] ]
}


+ (BOOL) isUnicode {
    return [ self subclassResponsibility ];
}


- (BOOL) equals: (id)a_string {
    int i,
        size = [ self size ];

    if ( [ a_string isSymbol ] )
        return self == a_string;
    if ( ![ a_string isCharacterArray ] )
        return NO;
    if ( [ self encoding ] != [ a_string encoding ] )
        return [ [ self asUnicodeString ] equals: [ a_string asUnicodeString ] ];
    if ( size != [ a_string size ] )
        return NO;
    if ( [ self hash ] != [ a_string hash ] )
        return NO;

    for ( i = 0; i < size; ++ i ) {
        if ( [ [ self at: i ] equals: [ a_string at: i ] ] )
            return NO;
    }
    return NO;
}


- (BOOL) lessThan: (id)a_character_array {
    return [ self caseInsensitiveCompareTo: a_character_array ] < 0;
}


- (BOOL) lessOrEqual: (id)a_character_array {
    return [ self caseInsensitiveCompareTo: a_character_array ] <= 0;
}


- (BOOL) greaterThan: (id)a_character_array {
    return [ self caseInsensitiveCompareTo: a_character_array ] > 0;
}


- (BOOL) greaterOrEqual: (id)a_character_array {
    return [ self caseInsensitiveCompareTo: a_character_array ] >= 0;
}


- (BOOL) sameAs: (id)a_character_array {
    if ( [ self size ] != [ a_character_array size ] )
        return NO;
    return [ self caseInsensitiveCompareTo: a_character_array ] == 0;
}


- (BOOL) match: (id)a_character_array {
    int result;

    result = [ [ self asLowercase ]
                 matchSubstring: 0
                             in: [ a_character_array asLowercase ]
                             at: 0 ];

    return result == [ a_character_array size ];
}
- (BOOL) match: (id)a_character_array ignoreCase: (BOOL)a_boolean {
    int result;

    if ( a_boolean )
        return [ [ self asLowercase ] match: [ a_character_array asLowercase ] ignoreCase: NO ];
    result = [ self matchSubstring: 0
                                in: a_character_array
                                at: 0 ];
    return result == [ a_character_array size ];
}


- (HNRange *) indexOf: (id)a_character_array matchCase: (BOOL)a_boolean startingAt: (int)an_index {
    int i, size, result;

    if ( !a_boolean )
        return [ [ self asLowercase ]
                   indexOf: [ a_character_array asLowercase ]
                 matchCase: YES
                startingAt: an_index ];

    size = [ self size ];
    for ( i = an_index; i < size; ++ i ) {
        result = [ a_character_array
                     matchSubString: 0
                                 in: self
                                 at: i ];
        if ( result != -1 )
            return [ [ HNInteger valueOf: i ] to: result ];
    }

    return NIL;
}


- (BOOL) isUnicode {
    return [ [ self class ] isUnicode ];
}


- (id) encoding {
    return [ self subclassResponsibility ];
}


- (id) numberOfCharacters {
    return [ self notYetImplemented ];
}


- (id) contractTo: (int)small_size {
    int size = [ self size ],
        left_size;

    if ( size <= small_size )
        return self;
    if ( small_size < 5 )
        return [ self copyFrom: 0 to: small_size ];
    left_size = ( small_size - 2 ) / 2;

    return [ self
               copyReplaceFrom: left_size + 1
                            to: size - (small_size - left_size - 3)
                          with: "..." ];
}


- (id) lines {
    return [ [ self readStream ] contents ];
}


#ifdef HEZELNUT_ENABLE_BLOCK
- (id) linesDo: a_block {
    [ [ self readStream ] linesDo: a_block ];

    return self;
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */


- (id) substrings {
    id oc = [ HNOrderedCollection new ];
    int i,
        arrival = [ self size ],
        last = 0;

    for ( i = 0; i < arrival; ++ i ) {
        if ( [ [ self at: i ] isSeparator ] ) {
            if ( last != i )
                [ oc addLast: [ self copyFrom: last to: i ] ];
            last = i + 1;
        }
    }
    if ( last <= [ self size ] )
        [ oc addLast: [ self copyFrom: last to: [ self size ] ] ];
    return oc;
}
- (id) substrings: (id)separator {
    id oc = [ HNOrderedCollection new ];
    int i,
        arrival = [ self size ],
        last = 0;

    if ( [ separator isCharacter ] )
        return [ self substringsChar: separator ];
    if ( [ separator size ] == 1 )
        return [ self substringsChar: [ separator first ] ];

    for ( i = 0 ; i < arrival ; ++ i ) {
        if ( [ separator includes: [ self at: i ] ] ) {
            if ( last != i )
                [ oc addLast: [ self copyFrom: last to: i ] ];
            last = i + 1;
        }
    }
    if ( last <= [ self size ] )
        [ oc addLast: [ self copyFrom: last to: [ self size ] ] ];
    return oc;
}


/*!
 * 
 */
- (id) substringsChar: (HNCharacter *)separator_char {
    id oc = [ HNOrderedCollection new ];
    int i,
        arrival = [ self size ],
        last = 0;

    for ( i = 0; i < arrival; ++ i ) {
        if ( [ [ self at: i ] equals: separator_char ] ) {
            if ( last != i )
                [ oc addLast: [ self copyFrom: last to: i ] ];
            last = i + 1;
        }
    }
    if ( last <= [ self size ] )
        [ oc addLast: [ self copyFrom: last to: [ self size ] ] ];
    return oc;
}


- (id) subStrings {
    id oc = [ HNOrderedCollection new ];
    int i,
        arrival = [ self size ],
        last = 0;

    for ( i = 0; i < arrival; ++ i ) {
        if ( [ [ self at: i ] isSeparator ] ) {
            if ( last != i )
                [ oc addLast: [ self copyFrom: last to: i ] ];
            last = i + 1;
        }
    }
    if ( last <= [ self size ] )
        [ oc addLast: [ self copyFrom: last to: [ self size ] ] ];
    return oc;
}
- (id) subStrings: (id)separator {
    id oc = [ HNOrderedCollection new ];
    int i,
        arrival = [ self size ],
        last = 0;

    if ( [ separator isCharacter ] )
        return [ self subStringsChar: separator ];
    if ( [ separator size ] == 1 )
        return [ self subStringsChar: [ separator first ] ];

    for ( i = 0 ; i < arrival ; ++ i ) {
        if ( [ separator includes: [ self at: i ] ] ) {
            if ( last != i )
                [ oc addLast: [ self copyFrom: last to: i ] ];
            last = i + 1;
        }
    }
    if ( last <= [ self size ] )
        [ oc addLast: [ self copyFrom: last to: [ self size ] ] ];
    return oc;
}


- (id) subStringsChar: (HNCharacter *)separator_char {
    id oc = [ HNOrderedCollection new ];
    int i,
        arrival = [ self size ],
        last = 0;

    for ( i = 0; i < arrival; ++ i ) {
        if ( [ [ self at: i ] equals: separator_char ] ) {
            if ( last != i )
                [ oc addLast: [ self copyFrom: last to: i ] ];
            last = i + 1;
        }
    }
    if ( last <= [ self size ] )
        [ oc addLast: [ self copyFrom: last to: [ self size ] ] ];
    return oc;
}


- (id) bindWith: (id)param1 {
    return [ self printf: HN_RITERAL_ARRAY1(param1) ];
}
- (id) bindWith: (id)param1 with: (id)param2 {
    return [ self printf: HN_RITERAL_ARRAY2(param1, param2) ];
}
- (id) bindWith: (id)param1 with: (id)param2 with: (id)param3 {
    return [ self printf: HN_RITERAL_ARRAY3(param1, param2, param3) ];
}
- (id) bindWith: (id)param1 with: (id)param2 with: (id)param3 with: (id)param4 {
    return [ self printf: HN_RITERAL_ARRAY4(param1, param2, param3, param4) ];
}


/*!
 * 
 */
- (id) bindWithArguments: (HNCollection *)a_collection {
    return [ self printf: a_collection ];
}


- (id) printf: (HNCollection *)a_collection {
    id result_stream = [ HNWriteStream on: [ self copyEmpty: [ self size ] + 20 ] ];
    BOOL was_percent = NO;
    id true_string, false_string;
    id pattern = [ HNReadStream on: self ];
    id ech;

    const id dollar_percent = [ HNCharacter valueOf: '%' ];

    while ( ![ pattern atEnd ] ) {
        ech = [ pattern next ];
        if ( [ ech equals: dollar_percent ] )
            ech = [ pattern next ];
        else
            [ result_stream nextPut: ech ];
        if ( [ ech equals: dollar_percent ] )
            [ result_stream nextPut: ech ];
        else
            ech = [ pattern next ];

        if ( [ ech equals: [ HNCharacter valueOf: '<' ] ) {
            true_string = [ pattern upTo: [ HNCharacter valueOf: '|' ] ];
            false_string = [ pattern upTo: [ HNCharacter valueOf: '>' ] ];
            ech = [ pattern next ];
        }
        if ( [ ech equals: [ HNCharacter valueOf: '(' ] ] )
            key = [ pattern upTo: [ HNCharacter valueOf: ')' ] ];
        else
            key = [ ech digitValue ];
        if ( [ true_string isNil ] )
            value = [ a_collection at: key ];
        else {
            if ( [ a_collection at: key ] )
                value = true_string;
            else
                value = false_string;
        }
        true_string = NIL;
        false_string = NIL;
    
        [ result_stream display: value ];
    }
    return [ result_stream contents ];
}


- (HNNumber *) asNumber {
    return [ HNNumber readFrom: [ HNReadStream on: self ] ];
}


- (id) asUnicodeString {
    return [ self subclassResponsibility ];
}


- (id) asUppercase {
    int i,
        arrival = [ self size ];
    id new_str = [ self copyEmpty: [ self size ] ];

    for ( i = 0; i < arrival; ++ i ) {
        [ new_str at: i put: [ [ self at: i ] asUppercase ] ];
    }
    return new_str;
}


- (id) asLowercase {
    int i,
        arrival = [ self size ];
    id new_str = [ self copyEmpty: [ self size ] ];

    for ( i = 0; i < arrival; ++ i ) {
        [ new_str at: i put: [ [ self at: i ] asLowercase ] ];
    }
    return new_str;
}


- (HNString *) asString {
    return [ self subclassResponsibility ];
}


#ifdef HEZELNUT_HAVE_SYMBOL
- (HNSymbol *) asSymbol {
    return [ self subclassResponsibility ];
}


- (HNSymbol *) asGlobalKey {
    return [ self asSymbol ];
}


- (HNSymbol *) asPoolKey {
    return [ self asSymbol ];
}


- (HNSymbol *) asClassPoolKey {
    return [ self asSymbol ];
}
#endif  /* def HEZELNUT_HAVE_SYMBOL */


- (HNByteArray *) asByteArray {
    return [ [ self asString ] asByteArray ];
}


- (HNInteger *) asInteger {
    int result, value;
    id ech;
    int i, arrival;

    const id dollar_zero = [ HNCharacter valueOf: '0' ];

    if ( [ self isEmpty ] )
        return [ HNInteger valueOf: 0 ];
    ech = [ self at: 0 ];
    // dollar_zero は $0。
    result = [ ech codePoint ] - [ dollar_zero codePoint ];

    if ( result < 0 || result > 9 ) {
        result = 0;
        if ( [ ech equals: dollar_hifun ] ) {
            arrival = [ self size ];
            for ( i = 1; i < arrival; ++ i ) {
                ech = [ self at: 0 ];
                value = [ ech codePoint ] - [ dollar_zero codePoint ];
                if ( value < 0 || value > 9 )
                    return [ HNInteger valueOf: result ];
                result = result * 10 - value;
            }
        } else {
            arrival = [ self size ];
            for ( i = 1; i < arrival; ++ i ) {
                ech = [ self at: 0 ];
                value = [ ech codePoint ] - [ dollar_zero codePoint ];
                if ( value < 0 || value > 9 )
                    return [ HNInteger valueOf: result ];
                result = result * 10 + value;
            }
        }
    }
    return [ HNInteger valueOf: result ];
}


- (id) fileName { return NIL; }


- (id) filePos { return NIL; }


- (BOOL) isNumeric {
    id ech;
    id stream = [ HNReadStream on: self ];

    while ( ![ ech = [ stream next ] isDigit ] ) {
        if ( [ stream atEnd ] )
            return YES;
    }
    if ( ![ ech equals: [ HNCharacter valueOf: '.' ] ] )
        return NO;

    while ( ![ stream atEnd ] ) {
        ech = [ stream next ];
        if ( ![ ech isDigit ] )
            return NO;
    }
    return YES;
}


- (id) trimSeparators {
    int start, stop;
    int arrival = [ self size ];

    for ( start = 0; start < arrival; ++ start ) {
        if ( ![ [ self at: start ] isSeparator ] ) {
            for ( stop = arrival; stop >= start; -- stop ) {
                if ( ![ [ self at: stop ] isSeparator ] )
                    return [ self copyFrom: start to: stop ];
            }
        }
    }
    return [ HNString empty ];
}


- (BOOL) isCharacterArray { return YES; }


- (id) valueAt: (int)index {
    id shape = [ [ self class ] shape ];
    int size;

    if ( !( [ shape identityEquals: HN_LITERAL_SYMBOL(character) ] || [ shape identityEquals: HN_LITERAL_SYMBOL(utf32) ] ) )
        return [ self subclassResponsibility ];
    if ( [ [ self class ] isFixed ] )
        return [ self subclassResponsibility ];
    //if ( ![ index isInteger ] )
    //    return [ HNWrongClassError signalOn: index mustBe: HNSmallInteger ];
    return [ HNIndexOutOfRangeError signalOn: self withIndex: index ];
}
#ifdef HEZELNUT_ENABLE_BLOCK
- (id) valueAt: (int)an_index ifAbsent: a_block {
    if ( (0 <= an_index && an_index < [ self size ]) )
        return [ a_block value ];
    return [ self valueAt: an_index ];
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */
- (id) valueAt: (int)an_index ifNone: (id)except_element {
    if ( (0 <= an_index && an_index < [ self size ]) )
        return except_element;
    return [ self valueAt: an_index ];
}
- (id) valueAt: (int)an_index put: (id)value {
    if ( !( [ shape identityEquals: HN_LITERAL_SYMBOL(character) ]
            || [ shape identityEquals: HN_LITERAL_SYMBOL(utf32) ] ) )
        return [ self subclassResponsibility ];
    if ( [ [ self class ] isFixed ] )
        return [ self subclassResponsibility ];
    if ( [ self isReadOnly ] )
        return [ HNReadOnlyObjectError signal ];
    //if ( ![ an_index isInteger ] )
    //    return [ HNWrongClassError signalOn: an_index mustBe: HNSmallInteger ];
    if ( an_index < 0 )
        return [ HNIndexOutOfRangeError signalOn: self withIndex: an_index ];
    if ( ![ value isInteger ] )
        return [ HNWrongClassError signalOn: value mustBe: HNSmallInteger ];
    if ( shape identityEquals: HN_LITERAL_SYMBOL(character) )
        return [ HNArgumentOutOfRangeError signalOn: value
                                      mustBeBetween: 0
                                                and: 255 ];
    return [ HNArgumentOutOfRangeError signalOn: value
                                      mustBeBetween: 0
                                                and: 1114111 ];
}


- (int) caseInsensitiveCompareTo: (id)a_character_array {
    int i,
        arrival = HN_MIN( [ self size ], [ a_character_array ] );
    id left, right;

    for ( i = 0; i < arrival; ++ i ) {
        left = [ [ self at: i ] asLowercaseValue ];
        right = [ [ a_character_array at: i ] asLowercaseValue ];

        if ( ![ left equals: right ] )
            return [ left asChar ] - [ right asChar ];
    }
    return [ self size ] - [ a_character_array ];
}


- (int) matchSubstring: (int)pp in: (id)a_character_array at: (int)an_index {
    int result;
    int arrival = an_index;
    int j, k;
    int p;
    id it, pc;

    it = [ self keysAndValuesFrom: pp to: [ self size ] ];
    for ( ; [ it finished ]; [ it next ] ) {
        p = [ [ it currentKey ] asInt32 ];
        pc = [ it currentValue ];

        if ( [ pc equals: [ HNCharacter valueOf: '*' ] ] ) {
            for ( j = [ a_character_array size ] + 1; j >= arrival; -- j ) {
                result = [ self
                             matchSubstring: p + 1
                                         in: a_character_array
                                         at: j ];
                if ( result != -1 )
                    return result;
            }
            return -1;
        }
        if ( arrival == [ a_character_array size ] )
            return -1;
        if ( ![ pc equals: [ HNCharacter valueOf: '#' ] ] ) {
            if ( ![ pc equals: [ a_character_array at: arrival ] ] )
                return -1;
        }
        ++ arrival;
    }
    return arrival - 1;
}
@end


// Local Variables:
//   coding: utf-8
// End:
