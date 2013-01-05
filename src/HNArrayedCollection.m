//  
//  HNArrayedCollection.m
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
#import <hezelnut/hn_functor.h>

#import <hezelnut/HNSequenceableCollection.h>
#import <hezelnut/HNStream.h>
#import <hezelnut/HNReadStream.h>
#import <hezelnut/HNWriteStream.h>
#import <hezelnut/HNReadWriteStream.h>

#import <hezelnut/HNError.h>
#import <hezelnut/HNArgumentOutOfRangeError.h>

#import <hezelnut/HNArrayedCollection.h>


@implementation HNArrayedCollection
+ (id) new: (unsigned int)size withAll: (id)an_object {
    return [ [ self new: size atAllPut: an_object ] yourself ];
}


#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 
 */
+ (id) streamContents: a_block {
    id stream = [ HNReadWriteStream on: [ self new: 10 ] ];

    [ stream truncate ];
    [ ablock value: stream ];

    return [ stream contents ];
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */


+ (id) with: (id)element1 {
    return [ [ [ self new: 1 ]
                 at: 0 put: element1 ] yourself ];
}
+ (id) with: (id)element1 with: (id)element2 {
    return [ [ [ [ self new: 2 ]
                 at: 0 put: element1 ]
                 at: 1 put: element2 ] yourself ];
}
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 {
    return [ [ [ [ [ self new: 3 ]
                 at: 0 put: element1 ]
                 at: 1 put: element2 ]
                 at: 2 put: element3 ] yourself ];
}
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4 {
    return [ [ [ [ [ [ self new: 3 ]
                       at: 0 put: element1 ]
                     at: 1 put: element2 ]
                 at: 2 put: element3 ]
                 at: 3 put: element4 ] yourself ];
}
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4 with: (id)element5 {
    return [ [ [ [ [ [ [ self new: 4 ]
                 at: 0 put: element1 ]
                 at: 1 put: element2 ]
                 at: 2 put: element3 ]
                 at: 3 put: element4 ]
                 at: 4 put: element5 ] yourself ];
}
+ (id) with: (id)element1 with: (id)element2 with: (id)element3 with: (id)element4 with: (id)element5 with: (id)element6 {
    return [ [ [ [ [ [ [ [ self new: 5 ]
                 at: 0 put: element1 ]
                 at: 1 put: element2 ]
                 at: 2 put: element3 ]
                 at: 3 put: element4 ]
                 at: 4 put: element5 ]
                 at: 5 put: element6 ] yourself ];
}


+ (id) withAll: (HNCollection *)a_collection {
    id an_arrayed_collection = [ self new: [ a_collection size ] ];
    int index = 0;
#ifdef HEZELNUT_ENABLE_BLOCK
    [ a_collection do: ^(id each) {
                [ an_arrayed_collection at: index put: each ];
                index ++;
            } ];
#else
    id it, each;
    it = [ a_collection iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        each = [ it current ];

        [ an_arrayed_collection at: index put: each ];
        index ++;
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


+ (id) join: (HNCollection *)a_collection {
#ifdef HEZELNUT_ENABLE_BLOCK
    id new_inst = [ self new: [ a_collection inject: 0
                                               into: ^(int size, id each) { return size + [ each size ]; } ] ];
    int start = 0;

    [ a_collection do: ^(id sub_coll) {
                int temp_to_index = start + [ sub_coll size ];
                [ new_inst replaceFrom: start
                                    to: temp_to_index
                                  with: subcoll ];
            } ];
#else
    id new_inst;
    int start = 0,
        temp_to_index;
    int size;
    id it, each, sub_coll;
    {
        size = 0;
        it = [ a_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            size += [ each size ];
        }
    }
    new_inst = [ self new: size ];
    {
        it = [ a_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            sub_coll = [ it current ];
            temp_to_index = start + [ sub_coll size ];

            [ new_inst replaceFrom: start
                                to: temp_to_index
                              with: subcoll ];
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return new_inst;
}
+ (id) join: (HNCollection *)a_collection separatedBy: (HNCollection *)sep_collection {
    id new_inst;
    int start;
#ifndef HEZELNUT_ENABLE_BLOCK
    int temp_to_index;
    int size;
    id it, each, sub_coll;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

    if ( [ a_collection isEmpty ] )
        return [ self new: 0 ];
#ifdef HEZELNUT_ENABLE_BLOCK
    new_inst = [ self new: [ a_collection inject: [ sep_collection size ] * ([ a_collection size ] - 1)
                                            into: ^(int size, id each) { return size + [ each size ]; } ] ];
    start = 0;
    [ a_collection do: ^(id sub_coll) {
                int temp_to_index = start + [ sub_coll size ] - 1;
                [ new_inst replaceFrom: start
                                    to: temp_to_index
                                  with: sub_coll ];
            }
      separatedBy: ^() {
            int temp_to_index = start + [ sep_collection size ] - 1;
            [ new_inst replaceFrom: start
                                to: temp_to_index
                              with: sep_collection ];
        } ];
#else
    {
        size = [ sep_collection size ] * ([ a_collection size ] - 1);
        it = [ a_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            size += [ each size ];
        }
    }
    start = 0;
    {
        it = [ a_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            sub_coll = [ it current ];

            temp_to_index = start + [ sub_coll size ] - 1;
            [ new_inst replaceFrom: start
                                to: temp_to_index
                              with: sub_coll ];
            if ( ![ it finished ] ) {
                temp_to_index = start + [ sep_collection size ] - 1;
                [ new_inst replaceFrom: start
                                    to: temp_to_index
                                  with: sep_collection ];
            }
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return new_inst;
}


- (id) add: (id)value {
    return [ self shouldNotImplement ];
}


- (id) concat: (HNSequenceableCollection *)a_seqeuenceable_collection {
    return [ [ [ [ self copyEmpty: [ self size ] + [ a_seqeuenceable_collection size ] ]
               replaceFrom: 0
                        to: [ self size ]
                      with: self
                startingAt: 0 ]
               replaceFrom: [ self size ] + 1
                        to: [ self size ] + [ a_seqeuenceable_collection size ]
                      with: a_seqeuenceable_collection
                 statingAt: 0 ]
               yourself ];
}


- (id) atAll: (id <HNPCollection>)key_collection {
    int i;
    id result = [ self copyEmptyForCollect: [ key_collection size ] ];
#ifdef HEZELNUT_ENABLE_BLOCK
    [ key_collection do: ^(id key) {
                [ result at: i ++ put: [ self at: [ key asInt32 ] ] ];
            } ];
#else
    id it, key;
    it = [ key_collection iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        key = [ it current ];

        [ result at: i ++ put: [ self at: [ key asInt32 ] ] ];
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return result;
}


- (id) copyFrom: (int)start to: (int)stop {
    int len;

    if ( stop < start ) {
        if ( stop == (start - 1) )
            return [ self copyEmpty: 0 ];
        [ HNArgumentOutOfRangeError signalOn: stop
                               mustBeBetween: start -1
                                         and: [ self size ] ];

        return self;
    }
    len = ( stop - start ) + 1;

    return [ [ [ self copyEmpty: len ]
               replaceFrom: 1
                        to: len
                      with: self
                startingAt: start ] yourself ];
}


- (id) copyWith: (id)an_element {
    return [ [ [ [ self copyEmpty: [ self size ] + 1 ]
                   replaceFrom: 0
                            to: [ self size ]
                          with: self
                    startingAt: 0 ]
                 at: [ self size ] + 1 put: an_element ] yourself ];
}


- (id) copyWithout: (id)old_element {
    int i;
    id new_collection;
    int num_occurrences = 0;
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self do: ^(id element) {
                if ( element == old_element )
                    ++ num_occurrences;
            } ];
#else
    id it, element;

    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        element = [ it current ];

        if ( element == old_element )
                    ++ num_occurrences;
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    new_collection = [ self copyEmpty: [ self size ] - num_occurrences ];
    i = 0;
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self do: ^(id element) {
                if ( element != old_element ) {
                    [ new_collection at: i put: element ];
                    ++ i;
                }
            } ];
#else
    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        element = [ it current ];

        if ( element != old_element ) {
            [ new_collection at: i put: element ];
            ++ i;
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return new_collection;
}


#ifdef HEZELNUT_ENABLE_BLOCK
- (id) select: a_block {
    id new_collection = [ HNWriteStream on: [ self copyEmpty ] ];

    [ self do: ^(id element) {
                if ( [ a_block value: element ] )
                    [ new_collection nextPut: element ];
            } ];
    return [ new_collection contents ];
}


- (id) reject: a_block {
    id new_collection = [ HNWriteStream on: [ self copyEmpty ] ];

    [ self do: ^(id element) {
                if ( ![ a_block value: element ] )
                    [ new_collection nextPut: element ];
            } ];
    return [ new_collection contents ];
}


- (id) collect: a_block {
    int i;
    int size = [ self size ];
    id new_collection = [ self copyEmptyForCollect ];

    for ( i = 0; i < size; ++ i ) {
        [ new_collection at: i put: [ a_block value: [ self at: i ] ] ];
    }
    return new_collection;
}


- (id) with: (HNSequenceableCollection *)a_seqeuenceable_collection collect: a_block {
    int i;
    int size;
    id new_collection;

    if ( [ self size ] != [ a_seqeuenceable_collection size ] )
        [ HNInvalidSizeError signalOn: a_seqeuenceable_collection ];

    new_collection = [ self copyEmpty ];
    size = [ self size ];
    for ( i = 0; i < size; ++ i ) {
        [ new_collection at: i
                        put: [ a_block value: [ self at: i ]
                                       value: [ a_seqeuenceable_collection at: i ] ] ];
    }
    return new_collection;
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */


- (id) copyReplaceFrom: (int)start to: (int)stop withObject: (id)an_object {
    int new_size;
    int end;

    if ( stop - start < -1 )
        [ HNArgumentOutOfRangeError signalOn: stop
                               mustBeBetween: start - 1
                                         and: [ self size ] ];
    end = stop >= start? stop: start;
    new_size = end + ( [ self size ] - stop );

    return [ [ [ [ [ self copyEmpty: new_size ]
               replaceFrom: 0 to: start - 1 with: self startingAt: 0 ]
               replaceFrom: start to: end withObject: an_object ]
               replaceFrom: end + 1 to: new_size with: self startingAt: stop + 1 ] yourself ];
}


- (id) copyReplaceAll: (HNCollection *)old_sub_collection with: (HNCollection *)new_sub_collection {
    int num_old = [ self countSubCollectionOccurrencesOf: old_sub_collection ];
    int new_sub_size = [ new_sub_collection size ];
    int old_sub_size = [ old_sub_collection size ];
    int size_difference = new_sub_size - old_sub_size;
    id new_collection = [ self copyEmpty: [ self size ] - ( size_difference * num_old ) ];
    int old_start, new_start;
    int index, copy_size;

    old_start = new_start = 0;
#ifdef HEZELNUT_ENABLE_BLOCK
    index = [ self indexOfSubCollection: old_sub_collection
                             startingAt: old_start
                               ifAbsent: ^() {
            [ new_collection replaceFrom: new_start
                                      to: [ new_collection size ]
                                    with: self
                              startingAt: old_start ];
            return new_collection;
        } ];
#else
    index = [ self indexOfSubCollection: old_sub_collection
                             startingAt: old_start ];
    if ( index == -1 ) {
        [ new_collection replaceFrom: new_start
                                  to: [ new_collection size ]
                                with: self
                          startingAt: old_start ];

        return new_collection;
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    copy_size = index - old_start;
    [ new_collection replaceFrom: new_start
                              to: new_start + copy_size - 1
                            with: self
                      startingAt: old_start ];
    new_start += copy_size;
    [ new_collection replaceFrom: new_start
                              to: new_start + new_sub_size - 1
                            with: new_sub_collection
                      startingAt: 0 ];
    old_start += copy_size + old_sub_size;
    new_start += new_sub_size;
    // ] repeat. だって…。

    return new_collection;
}


- (id) reverse {
    int i;
    int size = [ self size ];
    id result = [ self copyEmpty ];
    int complement = [ self size ] + 1;  // この 1 はどういう 1 なのか…

    for ( i = 0; i < size; ++ i ) {
        [ result at: i put: [ self at: complement - i ] ];
    }
    return result;
}


- (id) sorted {
    return [ [ self copyEmpty ]
               replaceFrom: 0
                        to: [ self size ]
                      with: [ self asSortedCollection ]
                startingAt: 0 ];
}
#ifdef HEZELNUT_ENABLE_BLOCK
- (id) sorted: (HNComparisonBlock *)a_block {
    return [ [ self copyEmpty ]
               replaceFrom: 0
                        to: [ self size ]
                      with: [ self asSortedCollection: a_block ]
                startingAt: 0 ];
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */


- (id) storeOn: (HNStream *)a_stream {
    int index;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, element;
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

    [ [ [ a_stream
          nextPutAll: @"((" ]
        nextPutAll: [ [ self class ] storeString ]
        nextPutAll: @" basicNew: " ] ];
    [ [ HNInteger value: [ self basicSize ] ] printOn: a_stream ];
    [ a_stream nextPut: ')' ];
    index = 0;
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self do: ^(id element) {
                [ a_stream nextPutAll: @" at: " ];
                [ [ HNInteger value: index ] printOn: a_stream ];
                [ a_stream nextPutAll: @" put: " ];
                [ element storeOn: a_stream ];
                [ a_stream nextPut: ';' ];
                ++ index;
            } ];
#else
    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        element = [ it current ];

        [ a_stream nextPutAll: @" at: " ];
        [ [ HNInteger value: index ] printOn: a_stream ];
        [ a_stream nextPutAll: @" put: " ];
        [ element storeOn: a_stream ];
        [ a_stream nextPut: ';' ];
        ++ index;
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    [ a_stream nextPut: ')' ];

    return self;
}


- (id) copyEmpty {
    return [ self copyEmpy: [ self size ] ];
}


- (id) grow {
    return [ self growBy: [ self growSize ] ];
}


- (id) growBy: (ind)delta {
    return [ self become: [ self copyGrowTo: [ self basicSize ] + delta ] ];
}


- (id) copyGrowTo: (int)new_size {
    id new_collection;

    new_collection = [ self copyEmpty: new_size ];
    [ new_collection replaceFrom: 0
                              to: [ self size ]
                            with: self
                      startingAt: 0 ];

    return new_collection;
}


#ifdef HEZELNUT_HAVE_WRITE_STREAM
- (HNWriteStream *)writeStream {
    return [ HNWriteStream on: self ];
}
#endif  /* def HEZELNUT_HAVE_WRITE_STREAM */


- (size_t) size {
    return vmpr_object_basic_size( self );
}
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
