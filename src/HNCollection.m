//  
//  HNCollection.h
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

#import <hezelnut/HNCollection.h>


@implementation HNCollection
+ (id) from: (HNArray *)an_array {
    return [ self withAll: an_array ];
}

+ (id) with: (id)an_object {
    return [ [ [ self new ] add: an_object ] yourself ];
}
+ (id) with: (id)first_object with: (id)second_object {
    return [ [ [ [ self new ]
                   add: first_object ]
                 add: second_object ]
               yourself ];
}
+ (id) with: (id)first_object with: (id)second_object with: (id)third_object {
    return [ [ [ [ [ self new ]
                   add: first_object ]
                 add: second_object ]
                 add: third_object ]
               yourself ];
}
+ (id) with: (id)first_object with: (id)second_object with: (id)third_object with: (id)fourth_object {
    return [ [ [ [ [ [ self new ]
                   add: first_object ]
                 add: second_object ]
                 add: third_object ]
                 add: fourth_object ]
               yourself ];
}
+ (id) with: (id)first_object with: (id)second_object with: (id)third_object with: (id)fourth_object with: (id)fifth_object {
    return [ [ [ [ [ [ [ self new ]
                   add: first_object ]
                 add: second_object ]
                 add: third_object ]
                 add: fourth_object ]
                 add: fifth_object ]
               yourself ];
}


+ (id) withAll: (HNCollection *)a_collection {
    return [ [ [ self new ] addAll: a_collection ] yourself ];
}


+ (BOOL) isUnicode {
    return YES;
}


- (id) concat: (HNIterable *)an_iterable {
    return [ [ [ [ self copyEmpty: [ self size ] + [ an_iterable size ] ]
                 addAll: self ]
               addAll: an_iterable ]
               yourself ];
}


- (id) add: (id)new_object {
    return [ self subclassResponsibility ];
}


- (id) addAll: (HNCollection *)a_collection {
    id it, element;

    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        [ self add: element ];
    }
    return a_collection;
}


- (id) empty {
    return [ self become: [ self copyEmpty ] ];
}


- (id) remove: (id)old_object {
    id tmp;
    if ( (tmp = [ self remove: old_object ]) == nil )
        [ HNNotFoundError signalOn: old_object what: @"object" ];
    return tmp;
}
- (id) remove: (id)old_object ifAbsent: (hn_except_functor)an_exception_block {
    return [ self subclassResponsibility ];
}


- (id) removeAll: (HNCollection *)a_collection {
    id it, element;

    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        element = [ it current ];

        [ self remove: element ];
    }
    return a_collection;
}
- (id) removeAll: (HNCollection *)a_collection ifAbsent: (hn_except_functor)a_block {
    id it, element;

    it = [ self iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
        element = [ it current ];

        [ self remove: element ifAbsent: a_block ];
    }
    return a_collection;
}


- (id) removeAllSuchThat: (hn_selector_functor)a_block {
    [ self removeAll: [ self select: a_block ] ifAbsent: NIL ];
}


- (BOOL) isSequenceable {
    return YES;
}
@end


// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
