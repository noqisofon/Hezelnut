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
    id stream = [ ReadWriteStream on: [ self new: 10 ] ];

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


+ (id) withAll: (id <HNPCollectable>)a_collection {
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


+ (id) join: (id <HNPCollectable>)a_collection {
#ifdef HEZELNUT_ENABLE_BLOCK
    id new_inst = [ self new: [ a_collection inject: 0
                                               into: ^(int size, id each) { return size + [ each size ]; } ] ];
    int start_index = 0;

    [ a_collection do: ^(id sub_coll) {
                int temp_to_index = start_index + [ sub_coll size ];
                [ new_inst replaceFrom: start_index
                                    to: temp_to_index
                                  with: subcoll ];
            } ];
#else
    id new_inst;
    int start_index = 0,
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
            temp_to_index = start_index + [ sub_coll size ];

            [ new_inst replaceFrom: start_index
                                to: temp_to_index
                              with: subcoll ];
        }
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return new_inst;
}
+ (id) join: (id <HNPCollectable>)a_collection separatedBy: (id <HNPCollectable>)sep_collection {
    id new_inst;
    int start_index;
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
    start_index = 0;
    [ a_collection do: ^(id sub_coll) {
                int temp_to_index = start_index + [ sub_coll size ] - 1;
                [ new_inst replaceFrom: start_index
                                    to: temp_to_index
                                  with: sub_coll ];
            }
      separatedBy: ^() {
            int temp_to_index = start_index + [ sep_collection size ] - 1;
            [ new_inst replaceFrom: start_index
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
    start_index = 0;
    {
        it = [ a_collection iterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            sub_coll = [ it current ];

            temp_to_index = start_index + [ sub_coll size ] - 1;
            [ new_inst replaceFrom: start_index
                                to: temp_to_index
                              with: sub_coll ];
            if ( ![ it finished ] ) {
                temp_to_index = start_index + [ sep_collection size ] - 1;
                [ new_inst replaceFrom: start_index
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


- (id) concat: (id <HNPSeqeuenceable>)a_seqeuenceable_collection {
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
@end
