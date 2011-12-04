//  
//  HNArray.m
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
#import <objc/objc.h>

#import <hezelnut/hn_functor.h>

#import <hezelnut/HNArray.h>


@implementation HNArray
+ (id) from: (HNArrayedCollection *)an_array {
    return an_array;
}


#ifdef HEZELNUT_ENABLE_BLOCK
- (id) at: (int)an_index ifAbsent: a_block {
    return [ self checkIndexableBounds: an_index ifAbsent: a_block ];
}
#else
- (id) at: (int)an_index ifAbsent: (hn_action0_functor)a_block {
    return [ self checkIndexableBounds: an_index ifAbsent: a_block ];
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */


#ifdef HEZELNUT_HAVE_BYTE_ARRAY
- (id) replaceFrom: (int)start_index to: (int)stop_index with: (HNByteArray *)byte_array startingAt: (int)replace_start_index {
    return [ super replaceFrom: start_index
                            to: stop_index
                          with: byte_array
                    startingAt: replace_start_index ];
}
#endif  /* def HEZELNUT_HAVE_BYTE_ARRAY */


#ifdef HEZELNUT_HAVE_STREAM
- (id) printOn (HNStream *)a_stream {
#   ifndef HEZELNUT_ENABLE_BLOCK
    id it, elt;
#   endif  /* ndef HEZELNUT_ENABLE_BLOCK */

    [ a_stream nextPut: '(' ];
#   ifdef HEZELNUT_ENABLE_BLOCK
    [ self do: ^(id elt) {
                [ elt printOn: a_stream ];
                [ a_stream space ];
            } ];
#   else
    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        elt = [ it current ];

        [ elt printOn: a_stream ];
        [ a_stream space ];
    }
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
    [ a_stream nextPut: ')' ];

    return self;
}


- (id) storeLiteralOn: (HNStream *)a_stream {
    if ( [ self class ] != Array )
        return [ super storeLiteralOn: a_stream ];

    [ a_stream nextPut: '#' ];
    [ a_stream nextPut: '(' ];
#   ifdef HEZELNUT_ENABLE_BLOCK
    [ self do: ^(id elt) {
                [ elt storeLiteralOn: a_stream ];
                [ a_stream space ];
            } ];
#   else
    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        elt = [ it current ];

        [ elt storeLiteralOn: a_stream ];
        [ a_stream space ];
    }
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
    [ a_stream nextPut: ')' ];

    return self;
}


- (id) storeOn: (HNStream *)a_stream {
    if ( [ self class ] != Array )
        return [ super storeOn: a_stream ];
    [ self storeLiteralOn: a_stream ];
    if ( ![ self isReadOnly ] )
        [ a_stream nextPutAll: @" copy" ];

    return self;
}
#endif  /* def HEZELNUT_HAVE_STREAM */


- (BOOL) isLiteralObject {
    return ![ self isReadOnly ];
}


- (id) multiBecome: (HNArrayedCollection *)an_array {
    int index = 0;
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self collect: ^(id object) {
            ++ index;
            return [ object become: [ an_array at: index ] ];
        } ];
#else
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


- (BOOL) isArray { return YES; }
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
