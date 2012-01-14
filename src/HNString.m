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

#import <hezelnut/HNCObject.h>


#import <hezelnut/HNString.h>


@implementation HNString
+ (id) fromCData: (HNCObject)a_cobject {
    [ self primitiveFailed ];

    return self;
}
+ (id) fromCData: (HNCObject)a_cobject size: (int)an_integer {
    return [ HNWrongClassError signalOn: an_integer mustBe: HNSmallInteger ];
}


+ (bool) isUnicode { return false; }


- (bool) equals: (HNCollection *)a_collection {
    return [ super equals: a_collection ];
}


- (id) concat: (HNString *)a_string {
    id new_string;
    int my_size;

    if ( ![ [ a_string class ] identityEquals: HNString ] )
        return [ super concat: a_string ];

    my_size = [ self size ];
    new_string = [ self copyEmpty: my_size + [ a_string size ] ];
    [ new_string replaceFrom: 0
                          to: my_size
                        with: self
                  startingAt: 0 ];
    [ new_string replaceFrom: my_size
                          to: [ new_string size ]
                        with: a_string
                  startingAt: 0 ];

    return new_string;
}


- (int) indexOf: (char)an_element startingAt: (int)an_index {
    return [ self indexOf: an_element startingAt: 0 ifNone: -1 ];
}
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
- (int) indexOf: (char)an_element startingAt: (int)an_index ifAbsent: exception_block {
    if ( an_index < 0 || an_index > [ self size ] + 1 )
        return [ self checkIndexableBounds: an_index ];
    return [ exception_block value ];
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */
/*!
 * 
 */
- (int) indexOf: (char)an_element startingAt: (int)an_index ifNone: (int)except_value {
    if ( an_index < 0 || an_index > [ self size ] + 1 )
        return [ self checkIndexableBounds: an_index ];
    return except_value;
}


- (id) encoding {
    return [ self notYetImplemented ];
}


- (HNByteArray *) asByteArray {
    HNByteArray* byte_array;
    int size = [ self size ];

    byte_array = [ HNByteArray new: size ];
    [ byte_array replaceFrom: 1
                          to: size
                  withString: self
                  startingAt: 0 ];

    return byte_array;
}


- (HNSymbol *) asSymbol {
    return [ HNSymbol intern: self ];
}


- (HNString *) asString { return self; }


- (BOOL) isString { return YES; }


- (HNString *) displayString { return self; }


- (id) displayOn: (HNStream *)a_stream {
    [ a_stream nextPutAll: self ];

    return self;
}


- (BOOL) isLiteralObject {
    return ![ self isReadOnly ];
}


- (id) storeLiteralOn: (HNStream *)a_stream {
    id it;
    char ch;

    [ a_stream nextPut: '$' ];
    it = [ self iterator ];

    for ( ; [ it finished ]; [ it next ] ) {
        ch = [ [ it current ] asChar ];
        if ( ch == '$' )
            [ a_stream nextPut: ch ];
        [ a_stream nextPut: ch ];
    }
    [ a_stream nextPut: '$' ];

    return self;
}


- (id) storeOn: (HNStream *)a_stream {
    [ self storeLiteralOn: a_stream ];
    if ( ![ self isReadOnly ] )
        [ a_stream nextPutAll: " copy" ];

    return self;
}


- (id) printOn: (HNStream *)a_stream {
    id it;
    char ch;

    [ a_stream nextPut: '$' ];
    it = [ self iterator ];

    for ( ; [ it finished ]; [ it next ] ) {
        ch = [ [ it current ] asChar ];
        if ( ch == '$' )
            [ a_stream nextPut: ch ];
        [ a_stream nextPut: ch ];
    }
    [ a_stream nextPut: '$' ];

    return self;
}


- (char) byteAt: (int)index {
    return [ [ self valueAt: index ] asChar ];
}
- (char) byteAt: (int)index put: (char)value {
    return [ self valueAt: index put: [ HNCharacter valueOf: value ] ];
}


- (int) hash { return 0; }


- (id) similarityTo: (HNString *)a_string {
    return [ HNWrongClassError signalOn: a_string mustBe: HNString ];
}


- (int) size {
    return [ self primitiveFaliled ];
}


- (id) replaceFrom: (int)start to: (int)stop with: (HNString *)a_string startingAt: (int)replace_start {
    return [ super
               replaceFrom: start
                        to: stop
                      with: a_string
                startingAt: replace_start ];
}
- (id) replaceFrom: (int)start to: (int)stop withByteArray: (HNByteArray *)byte_array startingAt: (int)replace_start {
    return [ super
               replaceFrom: start
                        to: stop
                      with: [ byte_array asString ]
                startingAt: replace_start ];
}


- (id) at: (int)an_index {
    return [ self checkIndexableBounds: an_index ];
}
#ifdef HEZELNUT_ENABLE_BLOCK
- (id) at: (int)an_index ifAbsent: ()a_block {
    return [ self checkIndexableBounds: an_index ifAbsent: a_block ];
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */
- (id) at: (int)an_index ifNone: (id)element {
    return [ self checkIndexableBounds: an_index ifNone: element ];
}
- (id) at: (int)an_index put: (id)value {
    return [ self checkIndexableBounds: an_index put: value ];
}


- (id) basicAt: (int)an_index {
    return [ self checkIndexableBounds: an_index ];
}
- (id) basicAt: (int)an_index put: (id)value {
    return [ self checkIndexableBounds: an_index put: value ];
}


- (id) asCData: (HNCType *)a_ctype {
    return [ self primitiveFailed ];
}
- (id) asCData {
    return [ self asCData: HNCCharType ];
}
@end



// Local Variables:
//   coding: utf-8
// End:
