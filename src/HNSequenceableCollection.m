//  
//  HNSequenceableCollection.m
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

#import <hezelnut/HNSequenceableCollection.h>


@implementation HNSequenceableCollection
- (id) join: (HNCollection *)a_collection separatedBy: (HNSequenceableCollection *)sep_collection {
    id new_inst;
    int start;

    if ( [ a_collection isEmpty ] )
        return [ self new: 0 ];
#ifdef HEZELNUT_ENABLE_BLOCK
    new_inst = [ self new:
                          [ a_collection inject: [ sep_collection size ] * [ a_collection size ] - 1 ]
                     into: ^(int size, id each) { return size + [ each size ]; }
    ];

    [ a_collection do: ^(id sub_coll) { [ new_inst addAll: sub_coll ]; } separatedBy: ^() { [ new_inst addAll: sep_collection ] } ];
#else
    id it, each, sub_coll;
    int size =  [ [ sep_collection size ] * [ a_collection size ] - 1 ];
    {
        it = [ a_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            size = size + [ each size ];
        }
    }
    new_inst = [ self new: size ];
    {
        it = [ a_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            sub_coll = [ it current ];

            [ new_inst addAll: sub_coll ];

            if ( ![ it finished ] )
                [ new_inst addAll: sep_collection ];
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return new_inst;
}


- (id) examineOn: (id <HNPStreamable>)a_stream {
    int i, size;
    id inst_vars, object, output;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, key, obj, temp_output;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

    [ [ [ a_stream
            nextPutAll: @"An instance of " ]
          print: [ self class ] ]
        nl ];
    inst_vars = [ [ self class ] allInstVarNames ];
    size = [ inst_vars size ];
    for ( i = 0; i < size; ++ i ) {
        object = [ self instVarAt: i ];
        @try {
            output = [ object printString ];
        } @catch ( HNError* err ) {
            [ err returns: [ HNString format: @"%1 %2"
                                            : [ [ object class ] article ],
                                      [ [ [ object class ] name ] asString ] ] ];
        }
        [ [ [  [ a_stream
                 nextPutAll: @"  " ]
              nextPutAll: [ inst_vars at: i ]
              nextPutAll: @": " ]
            nextPutAll: output ]
            nl ];
    }
    [ [ a_stream
          nextPutAll: @" contents: [" ]
        nl ];
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self keysAndValuesDo: ^(id key, id obj) {
            id outout;
            @try {
                outout = [ obj printString ];
            } @catch ( HNError* err ) {
                [ err returns: [ HNString format: @"%1 %2"
                                            : [ [ object class ] article ],
                                      [ [ [ object class ] name ] asString ] ] ];
            }

            [ [ [ [ [ a_stream
                        nextPutAll: @"   [" ]
                      print: i ]
                    nextPutAll: @"]: " ]
                  nextPutAll: output ]
                nl ];

            return HN_CONTINUE;
        } ];
#else
    {
        it = [ self associationIterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            key = [ it currentKey ]; obj = [ it currentValue ];

            @try {
                temp_outout = [ obj printString ];
            } @catch ( HNError* err ) {
                [ err returns: [ HNString format: @"%1 %2"
                                                : [ [ object class ] article ],
                                          [ [ [ object class ] name ] asString ] ] ];
            }

            [ [ [ [ [ a_stream
                        nextPutAll: @"   [" ]
                      print: i ]
                    nextPutAll: @"]: " ]
                  nextPutAll: temp_outout ]
                nl ];
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    [ [ a_stream nextPutAll: @"  ]" ] nl ];

    return self;
}


- (BOOL) isSequenceable { return YES; }


- (BOOL) equals: (id <HNCollectable>)a_collection {
    int i, size;
    if ( [ self class ] != [ a_collection class ] )
        return NO;
    if ( [ self size ] != [ a_collection size ] )
        return NO;

    size = [ a_collection size ];
    for ( i = 0; i < size; ++ i ) {
        if ( [ [ self at: i ] equals: [ a_collection at: i ] ] )
            return NO;
    }
    return YES;
}


- (int) hash {
    int hash = [ self size ];
    BOOL carray;
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self do: ^(id element) {
                carry = (hash & 536870912) > 0;
                hash &= 536870911;
                hash <<= 1;
                if ( carry )
                    hash |= 1;
                hash ^= [ element hash ];
            } ];
#else
    id it, element;
    {
        it = [ self iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            element = [ it current ];

            carry = (hash & 536870912) > 0;
            hash &= 536870911;
            hash <<= 1;
            if ( carry )
                hash |= 1;
            hash ^= [ element hash ];
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return hash;
}


- (BOOL) endsWith: (id <HNPSequenceable>)a_sequenceable_collection {
    int delta = [ self size ] - [ a_sequenceable_collection size ];
    BOOL result = YES;
#ifndef HEZELNUT_ENABLE_BLOCK
    int i;
    id it, each;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    if ( delta >= 0 )
        /* nothing!! */
    else
        return NO;
#ifdef HEZELNUT_ENABLE_BLOCK
    [ a_sequenceable_collection keyAndValuesDo: ^(int i, id each) {
            if ( [ self at: i + delta ] != each ) {
                result = NO;
                /*
                  Smalltalk ではブロック内の return は呼び出し元のコンテキスト上にあるようですが、多
                  くの C 言語系列の言語はそうではありません。
                 */
                return HN_BREAK;  // HN_BREAK が返るとそれ以降の要素列挙を已めます。
            }
            return HN_CONTINUE;
        } ];
#else
    {
        i = 0;
        it = [ a_sequenceable_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            if ( [ self at: i + delta ] != each ) {
                result = NO;

                break;
            }
            ++ i;
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return result;
}


- (BOOL) startsWith: (id <HNPSequenceable>)a_sequenceable_collection {
    BOOL result = YES;

    if ( [ self size ] >= [ a_sequenceable_collection size ] )
        /* nothing!! */
    else
        return NO;
#ifdef HEZELNUT_ENABLE_BLOCK
    [ a_sequenceable_collection keyAndValuesDo: ^(int i, id each) {
            if ( [ [ self at: i ] equals: each ] ) {
                result = NO;

                return HN_BREAK;
            }
            return HN_CONTINUE;
        } ];
#else
    {
        i = 0;
        it = [ a_sequenceable_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            if ( [ [ self at: i ] equals: each ] ) {
                result = NO;

                break;
            }
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return result;
}


#ifndef HEZELNUT_ENABLE_BLOCK
- (id) at: (int)an_index ifAbsent: a_block;
#else
- (id) at: (int)an_index ifAbsent: (HNFilterBlock *)a_block {
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
    if ( 0 <= an_index && an_index <= [ self size ] )
        /* nothing!! */
    else
        return [ a_block value ];

    return [ self at: an_index ];
}
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
