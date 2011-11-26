//  
//  HNStream.h
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
#import <hezelnut/HNCollectable.h>

#import <hezelnut/HNStream.h>


@implementation HNStream
+ (id) new {
    /* 呼んではいけない！！ */
}


- (void *) binary {
    return NULL;
}


- (id <HNPCollectable>) contents {
    return [ self upToEnd ];
}


- (id) flush {
    return self;
}


- (id <HNPString>) localName {
    return @"a stream";
}


- (id) next {
    [ self subclassResponsibility ];
    return nil;
}
#ifdef HEZELNUT_HAS_OREDEREDCOLLECTION
- (HNOrderedCollection *) next: (int)an_integer {
    // species が HNOrderedCollection を返すので、 answer には HNOrderedCollection オブジェクトが入るはず。
    id answer = [ self species new: an_integer ];
    [ self next: an_integer into: answer statingAt: 0 ];

    return answer;
}
#endif  /* def HEZELNUT_HAS_OREDEREDCOLLECTION */
- (id) next: (int)an_integer put: (id)an_oject {
    return nil;
}


- (BOOL) nextMatchAll: (id <HNCollectable>)a_collection {
    return NO;
}


- (BOOL) nextMatchFor: (id)an_object {
    return an_object = [ self next ];
}


- (id) nextPut: (id)an_object {
    return self;
}


- (id) nextPutAll: (id <HNCollectable>)a_collection {
}


- (id) readonly {
    return self;
}


#if defined(HEZELNUT_HAS_OREDEREDCOLLECTION) && defined(HEZELNUT_HAS_WRITESTREAM)
- (HNOrderedCollection *) upToEnd {
    HNWriteStream* write_stream = [ WriteStream on: [ [ self species ] new: 8 ] ];

    [ self nextPutAllOn: write_stream ];

    return [ write_stream contents ];
}


- (HNOrderedCollection *) nextLine {
    HNWriteStream* write_stream = [ WriteStream on: [ [ self species ] new: 40 ] ];
    BOOL at_end;
    id next;

    at_end = [ self atEnd ];
    next = [ self next ];
    while ( !( [ next equals: [ Character cr ] ] || [ next equals: [ Character nl ] ] || [ next isNil ] ) ) {
        [ write_stream nextPut: next ];
    }
    if ( [ next equals: [ Character cr ] ] )
        [ self peekFor: [ Character nl ] ];

    return [ write_stream contents ];
}
#endif  /* defined(HEZELNUT_HAS_OREDEREDCOLLECTION) && defined(HEZELNUT_HAS_WRITESTREAM) */


#ifdef HEZELNUT_HAVE_IOCHANNEL
/*!
 * ストリームの元になったファイルを返します。
 */
- (id <HNPIOChannel>) file {
    return nil;
}
#endif  /* def HEZELNUT_HAVE_IOCHANNEL */


/*!
 * ストリームの元になったっぽい名前を返します？
 */
- (id <HNPString>) name {
    return nil;
}


- (id <HNPCollectable>) nextAvailable: (int)an_integer {
    int n = 0;
    id <HNPCollectable> answer = [ [ self species ] new: an_integer ];

    n = [ self nextAvailable: an_integer
                        into: answer
                  startingAt: 0 ];

    if ( n < an_integer ) {
        answer = [ answer copyFrom: 0 to n ];
    }
    return answer;
}
- (int) nextAvailable: (int)an_integer putAllOn: (HNStream *)a_stream {
    int n = HEZEL_MIN( an_integer, 1024 );
    id collection = [ [ self species ] new: n ];

    n = [ self nextAvailable: n
                        into: collection
                   statingAt: 0 ];
    [ a_stream next: n
             putAll: collection
         startingAt: 0 ];

    return n;
}
- (int) nextAvailable: (int)an_integer into: (id <HNPCollectable>)a_collection statingAt: (int)pos {
    int i = -1;

    while ( (++ i) == an_integer ) {
        if ( [ self atEnd ] )
            return i;
        [ a_collection at: i + pos put: [ self next ] ];
    }
    return an_integer;
}


- (HNOrderedCollection *) splitAt: (id)an_object {
    id result = [ OrderedCollection new: 10 ];

    while ( ![ self atEnd ] ) {
        [ result addLast: [ self upTo: an_object ] ];
    }
    return result;
}


#ifdef HEZELNUT_HAS_OREDEREDCOLLECTION
- (int) next: (int)an_integer putAllOn: (HNStream *)a_stream {
    int read = 0;

    while ( read != an_integer ) {
        if ( [ self atEnd ] ) {
            [ NotEnoughElements signalOn: an_integer - read ];
            return 0;
        }
        read += [ self nextAvailable: an_integer - read
                            putAllOn: a_stream ];
    }
    return read;
}


- (HNOrderedCollection *) next: (int)an_integer into: (HNOrderedCollection *)answer startingAt: (int)pos {
    int read = 0;

    while ( read != an_integer ) {
        if ( [ self atEnd ] ) {
            [ NotEnoughElements signalOn: an_integer - read ];
            return 0;
        }
        read += [ self nextAvailable: an_integer - read
                                into: answer
                          startingAt: read + pos ];
    }
    return answer;
}
#endif  /* def HEZELNUT_HAVE_IOCHANNEL */
@end


// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
