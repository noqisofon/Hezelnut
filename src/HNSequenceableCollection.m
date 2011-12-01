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


#ifdef HEZELNUT_ENABLE_BLOCK
- (id) at: (int)an_index ifAbsent: (HNFilterBlock *)a_block;
#else
- (id) at: (int)an_index ifAbsent: (hn_functor0)a_block {
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
    if ( 0 <= an_index && an_index <= [ self size ] )
        /* nothing!! */
    else {
#ifdef HEZELNUT_ENABLE_BLOCK
        return [ a_block value ];
#else
        return a_block();
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    }

    return [ self at: an_index ];
}


- (id) atAll:(HNCollection *)key_collection {
    id result = [ self copyEmptyForCollect: [ key_collection size ] ];
#ifdef HEZELNUT_ENABLE_BLOCK
    [ key_collection do: ^(id key) {
                [ result add: [ self at: [ key asInt32 ] ] ];
            } ];
#else
    id it, key;

    it = [ key_collection iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        key = [ it current ];

        [ result add: [ self at: [ key asInt32 ] ] ];
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return result;
}


- (id) atAll:(HNCollection *)a_collection put: (id)an_object {
#ifdef HEZELNUT_ENABLE_BLOCK
    [ a_collection do: ^(id index) { [ self at: [ index asInt32 ] put: an_object ]; } ];
#else
    id it, index;

    it = [ key_collection iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        index = [ it current ];

        [ self at: [ index asInt32 ] put: an_object ];
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return self;
}


- (id) atAllPut: (id)an_object {
    int size = [ self size ];
    int to;

    if ( size == 0 )
        return self;
    [ self at: 0 put: an_object ]; if ( size == 1 ) return self;
    [ self at: 1 put: an_object ]; if ( size == 2 ) return self;
    [ self at: 2 put: an_object ]; if ( size == 3 ) return self;
    [ self at: 3 put: an_object ]; to = 4;
    /*
      それ以上なら while を遣います。
     */
    while ( size > to ) {
        to += to;
        [ self replaceFrom: to + 1
                        to: HN_MIN( to, size )
                      with: self
                 statingAt: 0 ];
    }
    return self;
}


- (id) after: (id)old_object {
    int i = [ self indexOf: old_object ];

    if ( i == -1 )
        [ HNNotFoundError signalOn: old_object what: @"object" ];

    return [ self at: i - 1 ];
}


- (id) allButFirst {
    return [ self copyFrom: 1 ];
}
- (id) allButFirst: (int)n {
    return [ self copyFrom: n ];
}


- (id) allButLast {
    return [ self copyFrom: [ self size ] - 2 ];
}
- (id) allButLast: (int)n {
    return [ self copyFrom: ([ self size ] - 1) - n ];
}


- (id) first { return [ self at: 0 ]; }
- (id) first: (int)n {
    return [ self copyFrom: 0 to: n ];
}


- (id) second { return [ self at: 1 ]; }


- (id) third { return [ self at: 2 ]; }


- (id) fourth { return [ self at: 3 ]; }


- (id) last {
    return [ self at: [ self size ] - 1 ];
}
- (id) last: (int)n {
    return [ self copyFrom: 0 to: [ self size ] - n ];
}


- (BOOL) includes: (id)an_object {
    int i,
        size = [ self size ];

    for ( i = 0; i < size; ++ i ) {
        if ( [ an_object equals: [ self at: i ] ] )
            return YES;
    }
    return NO;
}


- (BOOL) identityIncludes: (id)an_object {
    int i,
        size = [ self size ];

    for ( i = 0; i < size; ++ i ) {
        if ( an_object == [ self at: i ] )
            return YES;
    }
    return NO;
}


- (int) indexOfSubCollection: (HNCollection *)a_sub_collection {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self
               indexOfSubCollection: a_sub_collection
                         startingAt: 0
                           ifAbsent: ^() { return -1; } ];
#else
    return [ self
               indexOfSubCollection: a_sub_collection
                         startingAt: 0
                           ifAbsent: NULL ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}
#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) indexOfSubCollection: (HNCollection *)a_sub_collection ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection ifAbsent: (hn_filter0_functor)exception_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return [ self
               indexOfSubCollection: a_sub_collection
                         startingAt: 0
                           ifAbsent: exception_block ];
}
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection startingAt: (int)an_index {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self
               indexOfSubCollection: a_sub_collection
                         startingAt: an_index
                           ifAbsent: ^() { return -1; } ];
#else
    return [ self
               indexOfSubCollection: a_sub_collection
                         startingAt: an_index
                           ifAbsent: NULL ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}
#ifdef HEZELNUT_ENABLE_BLOCK
#else
- (int) indexOfSubCollection: (HNCollection *)a_sub_collection startingAt: (int)an_index ifAbsent: (hn_functor0)exception_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int self_size,
        sub_size;
    int temp_size;

    sub_size = [ a_sub_collection size ];
    if ( sub_size == 0 )
        return an_index;
    self_size = [ self size ];

    temp_size = an_index + ( sub_size - 1 );
    if ( temp_size <= self_size ) {
        for ( ; an_index < temp_size; ++ an_index ) {
            if ( [ [ self at: index ] equals: [ a_sub_collection at: 0 ] ] ) {
                if ( [ self matchSubCollection: a_sub_collection startingAt: an_index ] )
                    return an_index;
            }
        }
    }
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ exception_block value ];
#else
    if ( exception_block )
        return exception_block();
    return -1;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


- (int) indexOf: (id)an_element {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self
               indexOf: an_element
             statingAt: 0
              ifAbsent: ^() { return 0; } ];
#else
    return [ self
               indexOf: an_element
             statingAt: 0
              ifAbsent: NULL ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}
- (int) indexOf: (id)an_element startingAt: (int)an_index {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self
               indexOf: an_element
             statingAt: an_index
              ifAbsent: ^() { return -1; } ];
#else
    return [ self
               indexOf: an_element
             statingAt: an_index
              ifAbsent: NULL ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}
#ifdef HEZELNUT_ENABLE_BLOCK
- (int) indexOf: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) indexOf: (id)an_element ifAbsent: (hn_filter0_functor)exception_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return [ self
               indexOf: an_element
             statingAt: 0
              ifAbsent: exception_block ];
}
#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) indexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block {
#else
- (int) indexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int size = [ self size ];

    if ( an_index < 0 || an_index > size ) {
        if ( an_index == size + 1 ) {
#ifdef HEZELNUT_ENABLE_BLOCK
            return [ exception_block value ];
#else
            if ( exception_block )
                return exception_block();
            return -1;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
        } else
            return [ self checkIndexableBounds: an_index ];
    }
    for ( ; an_index < size; ++ an_index ) {
        if ( [ [ self at: an_index ] equals: an_element ] )
            return an_index;
    }
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ exception_block value ];
#else
    if ( exception_block )
        return exception_block();
    return -1;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) indexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block;
#else
- (int) indexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int i,
        size = [ self size ];

    for ( i = size; i > 0; -- i ) {
        if ( [ [ self at: i ] equals: an_element ] )
            return i;
    }
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ exception_block value ];
#else
    if ( exception_block )
        return exception_block();
    return -1;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}

- (int) identityIndexOf: (id)an_element {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self
               identityIndexOf: an_element
             statingAt: 0
              ifAbsent: ^() { return -1; } ];
#else
    return [ self
               identityIndexOf: an_element
             statingAt: 0
              ifAbsent: NULL ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}
- (int) identityIndexOf: (id)an_element startingAt: (int)an_index {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self
               identityIndexOf: an_element
             statingAt: an_index
              ifAbsent: ^() { return 0; } ];
#else
    return [ self
               identityIndexOf: an_element
             statingAt: an_index
              ifAbsent: NULL ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}
#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) indexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block {
#else
- (int) identityIndexOf: (id)an_element startingAt: (int)an_index ifAbsent: (hn_filter0_functor)exception_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int size = [ self size ];

    if ( an_index < 0 || an_index > size ) {
        if ( an_index == size + 1 ) {
#ifdef HEZELNUT_ENABLE_BLOCK
            return [ exception_block value ];
#else
            if ( exception_block )
                return exception_block();
            return -1;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
        } else
            return [ self checkIndexableBounds: an_index ];
    }
    for ( ; an_index < size; ++ an_index ) {
        if ( [ self at: an_index ] == an_element )
            return an_index;
    }
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ exception_block value ];
#else
    if ( exception_block )
        return exception_block();
    return -1;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


#ifdef HEZELNUT_ENABLE_BLOCK
//- (int) identityIndexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block {
#else
- (int) identityIndexOfLast: (id)an_element ifAbsent: (hn_filter0_functor)exception_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int i,
        size = [ self size ];

    for ( i = size; i > 0; -- i ) {
        if ( [ self at: i ] == an_element )
            return i;
    }
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ exception_block value ];
#else
    if ( exception_block )
        return exception_block();
    return -1;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


- (id) replaceAll: (id)an_object with: (id)another_object {
    int i,
        size = [ self size ];

    for ( i = 0; i < size; ++ i ) {
        if ( [ [ self at: i ] equals: an_object ] )
            [ self at: i put: another_object ];
    }
    return self;
}


- (id) replaceFrom: (int)start to: (int)stop with: (HNCollection *)replacement_collection {
    int i;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, each;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */ 

    i = start - 1;
    if ( ( stop - i ) == [ replacement_collection size ] )
        [ HNInvalidSizeError signalOn: [ replacement_collection size ] ];
    if ( [ replacement_collection isSequenceable ] )
        return [ self replaceFrom: start to: stop with: replacement_collection startingAt: 0 ];
#ifdef HEZELNUT_ENABLE_BLOCK
    [ replacement_collection do: ^(id each) {
                [ self at: i put: each ];
                ++ i;
            } ];
#else
    it = [ replacement_collection iterator ];
    for ( ; [ it finished ]; [ it next ], ++ i ) {
        [ self at: i put: each ];
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */ 
    return self;
}
- (id) replaceFrom: (int)an_index to: (int)stop_index withObject: (id)replacement_object {
    if ( stop_index - an_index < -1 ) {
        [ HNArgumentOutOfRangeError signalOn: stop_index
                               mustBeBetween: an_index
                                         and: [ self size ] ];
        return self;
    }
    for ( ; an_index < stop_index; ++ an_index ) {
        [ self at: an_index put: replacement_object ];
    }
    return self;
}
- (id) replaceFrom: (int)start to: (int)stop with: (HNCollection *)replacement_collection startingAt: (int)replace_start {
    int i;
    int delta;
    int min_stop = start - 1,
        max_stop = HN_MIN( [ self size ], min_stop + [ replacement_collection size ]);

    if ( min_stop <= stop && stop <= max_stop )
    else {
        [ HNArgumentOutOfRangeError signalOn: stop
                               mustBeBetween: min_stop
                                         and: max_stop ];
    }
    delta = start - replace_start;
    if ( replace_start > start ) {
        for ( i = start; i < stop; ++ i ) {
            [ self at: start put: [ replacement_collection at: i - delta ] ];
        }
    } else {
        for ( i = stop; i >= start; -- i ) {
            [ self at: start put: [ replacement_collection at: i - delta ] ];
        }
    }
    return self;
}


- (id) copyAfter: (id)an_object {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self copyFrom: [ self indexOf: an_object ifAbsent: ^() { return [ self size ]; } ] ];
#else
    return [ self copyFrom: [ self indexOf: an_object ifAbsent: [ self size ]; ] ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


- (id) copyAfterLast: (id)an_object {
#ifdef HEZELNUT_ENABLE_BLOCK
    return [ self copyFrom: [ self indexOfLast: an_object ifAbsent: ^() { return [ self size ]; } ] ];
#else
    return [ self copyFrom: [ self indexOfLast: an_object ifAbsent: [ self size ]; ] ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


- (id) copyUpTo: (id)an_object {
    return [ self copyFrom: 0
                        to: [ self indexOf: an_object
#ifdef HEZELNUT_ENABLE_BLOCK
                                  ifAbsent: ^() { return [ self size ]; }
#else
                                  ifAbsent: [ self size ]
#endif  /* def HEZELNUT_ENABLE_BLOCK */
                        ] - 1 ];
}


- (id) copyUpToLast: (id)an_object {
        return [ self copyFrom: 0
                        to: [ self indexOfLast: an_object
#ifdef HEZELNUT_ENABLE_BLOCK
                                  ifAbsent: ^() { return [ self size ]; }
#else
                                  ifAbsent: [ self size ]
#endif  /* def HEZELNUT_ENABLE_BLOCK */
                        ] - 1 ];
}


- (id) copyReplace: (int)start to: (int)stop withObject: (id)an_object {
    int new_size,
        replace_size;
    id result;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, each;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
    if ( stop - start < -1 ) {
        [ HNArgumentOutOfRangeError signalOn: stop
                               mustBeBetween: start - 1
                                         and: [ self size ] ];
        //return self;
    }
    if ( stop >= start )
        return [ [ [ self copy ]
                     atAll: HN_RITERAL_RANGE( start, stop )
                       put: an_object ]
                   yourself ];
    new_size = [ self size ] - ( stop - start );
    result = [ self copyEmpty: new_size ];
    if ( start > 0 ) {
#ifdef HEZELNUT_ENABLE_BLOCK
        [ self from: 0 to: start do: ^(id each) {
                    [ result add: each ];
                } ];
#else
        it = [ self iteratorFrom: 0 to: start ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            [ result add: each ];
        }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    }
    [ result add: an_object ];
    if ( stop < [ self size ] ) {
#ifdef HEZELNUT_ENABLE_BLOCK
        [ self from: stop + 1 to: [ self size ] do: ^(id each) {
                    [ result add: each ];
                } ];
#else
        size = [ self size ];
        it = [ self iteratorFrom: stop + 1 ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            [ result add: each ];
        }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    }
    return result;
}


- (id) copyWithFirst: (id)an_object {
    return [ self copyReplaceFrom: 1 to: 0 withObject: an_object ];
}


- (id) copyFrom: (int)start {
    return [ self copyFrom: start to: [ self size ] ];
}
/*!
 * 
 */
- (id) copyFrom: (int)start to: (int)stop {
    int len;
    id collection;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, each;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
    if ( stop < start ) {
        [ HNArgumentOutOfRangeError signalOn: stop
                               mustBeBetween: start - 1
                                         and: [ self size ] ];
    }
    len = stop - start + 1;
    collection = [ self copyEmpty: len + 10 ];
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self from: start to: stop do: ^(id each) { [ collection add: each ]; } ];
#else
    it = [ it iteratorFrom: start to: stop ];

    for ( ; [ it finished ]; [ it next ] ) {
        each = [ it current ];

        [ collection add: each ];
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return collection;
}


- (id) copyReplaceAll: (HNSequenceableCollection *)old_sub_collection with: (HNSequenceableCollection *)new_sub_collection {
    int num_old = [ self countSubCollectionOccurrencesOf: old_sub_collection ];
    int new_sub_size = [ new_sub_collection size ];
    int old_sub_size = [ old_sub_collection size ];
    int size_difference = new_sub_size - old_sub_size;
    id new_collection = [ self copyEmpty: [ self size ] + ( size_difference * num_old ) ];
    int old_start = 0;
    int index, copy_size;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, each;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
    while ( ( index = [ self
                          indexOfSubCollection: old_sub_collection
                                    startingAt: old_start ] ) != -1 ) {
        copy_size = index - old_start;
#ifdef HEZELNUT_ENABLE_BLOCK
        [ self from: old_start
                 to: old_start + copy_size
                 do: ^(id each) {
                         [ new_collection add: each ];
                     } ];
#else
        it = [ self iteratorFrom: old_start to: old_start + copy_size ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            [ new_collection add: each ];
        }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
        [ new_collection addAll: new_sub_collection ];
        old_start += copy_size + old_sub_size;
    }
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self from: old_start
             to: [ self size ]
             do: ^(id each) {
                     [ new_collection add: each ];
                 } ];
#else
    it = [ self iteratorFrom: old_start to: [ self size ] ];
    for ( ; [ it finished ]; [ it next ] ) {
        each = [ it current ];

        [ new_collection add: each ];
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return new_collection;
}


- (id) copyReplaceFrom: (int)start to: (int)stop with: (HNCollection *)replacement_collection {
    int new_size, replacement_size;
    id result;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, each;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

    if ( stop - start < -1 ) {
        [ HNArgumentOutOfRangeError signalOn: stop
                               mustBeBetween: start - 1
                                         and: [ self size ] ];
    }
    replacement_size = [ replacement_collection size ];
    new_size = [ self size ] + replacement_size - ( stop - start + 1 );
    result = [ self copyEmpty: new_size ];
    if ( start > 0 ) {
#ifdef HEZELNUT_ENABLE_BLOCK
        [ self
            from: 0
              to: start
              do: ^(id each) { [ result add: each ]; } ];
#else
        it = [ iteratorFrom: 0 to: start ];

        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            [ result add: each ];
        }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    }
}


- (id) join: (HNSequenceableCollection *)sequence {
    if ( [ self isEmpty ] )
        return HN_RITERAL_EMPTY_ARRAY;
    else
        return [ [ [ self first ] species ] join: self separatedBy: sequence ];
}


- (id) nextPutAllOn: (HNStream *)a_stream {
    [ a_stream next: [ self size ] putAll: self statringAt: 0 ];

    return self;
}


- (HNReadStream *) readStream {
    return [ HNReadStream on: self ];
}


- (HNReadWriteStream *) readWriteStream {
    return [ HNReadWriteStream on: self ];
}


- (id) anyOne {
    return [ self first ];
}


#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) do: a_block {
#else
- (id) do: (hn_action1_functor)a_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int i,
        size = [ self size ];

    for ( i = 0; i < size; ++ i ) {
#ifdef HEZELNUT_ENABLE_BLOCK
        [ a_block value: [ self at: i ] ];
#else
        a_block( [ self at: i ] );
#endif  /* def HEZELNUT_ENABLE_BLOCK */        
    }
    return self;
}
#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) do: a_block separatedBy: separate_block;
#else
- (id) do: (hn_action1_functor)a_block separatedBy: (hn_action_functor)separate_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int i,
        size = [ self size ];
#ifdef HEZELNUT_ENABLE_BLOCK
    [ a_block value: [ self at: 0 ] ];
#else
    a_block( [ self at: 0 ] );
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    for ( i = 1; i < size; ++ i ) {
#ifdef HEZELNUT_ENABLE_BLOCK
        [ separate_block value ];
        [ a_block value: [ self at: 0 ] ];
#else
        separate_block();
        a_block( [ self at: 0 ] );
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    }
    return self;
}


#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) doWithIndex: a_block {
#else
- (id) doWithIndex: (hn_enumeration2_functor)a_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    int i,
        size = [ self size ];

    for ( i = 0; i < size; ++ i ) {
#ifdef HEZELNUT_ENABLE_BLOCK
        [ a_block value: [ self at: i ] value: i ];
#else
        a_block( [ self at: i ], i );
#endif  /* def HEZELNUT_ENABLE_BLOCK */        
    }
    return self;
}


#ifdef HEZELNUT_ENABLE_BLOCK
//- (id) fold: binary_block {
#else
- (id) fold: (hn_binary_functor)binary_block {
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    id it, element;
    id result;

    if ( [ self isEmpty ] )
        [ HNEmptyCollectionError signalOn: self ];

    result = [ self at: 0 ];

    it = [ self iteratorFrom: 1 to: [ self size ] ];
    for ( ; [ it finished ]; [ it next ] ) {
        element = [ it current ];
#ifdef HEZELNUT_ENABLE_BLOCK
        result = [ binary_block value: result value: element ];
#else
        result = binary_block( result, element );
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    }
    return result;
}


- (id) keys {
    return HN_LITERAL_RANGE( 0, [ self size ] );
}
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
