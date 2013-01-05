//  
//  HNClass.m
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
#import <hezelnut/HNCollection.h>
#import <hezelnut/HNOrderedCollection.h>
#import <hezelnut/HNSet.h>
#import <hezelnut/HNDictionary.h>
#import <hezelnut/HNString.h>
#import <hezelnut/HNSymbol.h>
#import <hezelnut/HNError.h>
#import <hezelnut/HNInvalidValueError.h>
#import <hezelnut/NHNotFoundError.h>

#ifdef HEZELNUT_HAVE_IDENTITY_SET
#   import <hezelnut/HNIdentitySet.h>
#endif  /* def HEZELNUT_HAVE_IDENTITY_SET */
#ifdef HEZELNUT_HAVE_BINDING_DICTIONARY
#   import <hezelnut/HNBindingDictionary.h>
#endif  /* def HEZELNUT_HAVE_BINDING_DICTIONARY */
#ifdef HEZELNUT_HAVE_ORDERED_COLLECTION
#   import <hezelnut/HNOrderedCollection.h>
#endif  /* def HEZELNUT_HAVE_ORDERED_COLLECTION */
#ifdef HEZELNUT_HAVE_INVALID_VALUE_ERROR
#   import <hezelnut/HNInvalidValueError.h>
#endif  /* def HEZELNUT_HAVE_INVALID_VALUE_ERROR */

#import <hezelnut/HNClass.h>


@implementation HNClass
#ifdef HEZELNUT_ENABLE_BLOCK
+ (id) allPoolDictionaries: (HNCollection *)list except: (id)in_white do: a_block {
    id white;
    HNIdentitySet* grey;
    HNOrderedCollection* order;
    id descend;

    if ( [ list isEmpty ] )
        return self;

    white = [ in_white copy ];
    grey = [ HNIdentitySet new: [ list size ] ];
    order = [ HNOrderedCollection new: [ list size ] ];

    descend = ^(id pool) {
        if ( ![ white includes: pool ] ) {
            if ( [ grey includes: pool ] )
                [ HNInvalidValueError signalOn: list
                                        reason: @"includes circular dependency" ];
        }
        // #allSuperspaces is not available on all pools
        [ grey add: pool ];
        [ [ pool allSuperspaces ] reverseDo: descend ];
        [ order addFirst: pool ];
        [ white add: pool ];
    };
    [ list reverseDo: descend ];
    [ order do: a_block ];

    return self;
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */


+ (void) initialize {
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self subclassesDo: ^(id each) {
            [ [ each instanceClass ] initializeAsRootClass ];
        } ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


- (HNString *)name { return name_; }


- (id) environment { return environment_; }
- (id) environment: (id)a_namespace {
    environment_ = a_namespace;
    /*
      ここらへんの処理は、イメージファイルを更新するためのものだと思われるが、イメージファイルは更新しないので
      要らないかもしれない。
     */
    [ [ [ self asClass ]
          compileAll ]
        compileAllSubclasses ];
    [ [ [ self asMetaClass ]
          compileAll ]
        compileAllSubclasses ];
}


- (HNString *) category { return category_; }
- (id) category: (HNString *)a_string {
    category_ = a_string;
    return self;
}


- (id) superclass: (HNClass *)a_class {
    if ( [ a_class isNil ] && [ [ self superclass ] notNil ] )
        [ self initializeAsRootClass ];

    [ super superclass: a_class ];

    return self;
}


- (id) addClassVarName: (HNString *)a_string {
    id sym = [ a_string asClassPoolKey ];

    if ( ![ [ self classPool ] includesKey: sym ] )
        [ [ self classPool ] at: sym put: nil ];
  
    return [ [ self classPool ] associationAt: sym ];
}

#ifdef HEZELNUT_ENABLE_BLOCK
- (id) addClassVarName: (HNString *)a_string value: a_block {
  
}
#else
- (id) addClassVarName: (HNString *)a_string value: (id)a_object {
    return [ [ [ self addClassVarName: a_string ] value: a_object ] yourself ];
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */


- (id) bindingFor: (HNString *)a_string {
    id sym = [ a_string asClassPoolKey ];

    return [ [ self classPool ] associationAt: sym ];
}


- (id) removeClassVarName: (HNString *)a_string {
    id sym = [ a_string asClassPoolKey ];

    if ( !( [ class_variables_ notNil ] && [ class_variables_ includesKey: sym ] ) )
        [ NHNotFoundError signalOn: a_string what: @"class variable" ];
    [ class_variables_ removeKey: sym ];

    [ [ [ self asClass ]
          compileAll ]
        compileAllSubclasses ];
    [ [ [ self asMetaClass ]
          compileAll ]
        compileAllSubclasses ];
}



#ifdef HEZELNUT_HAVE_BINDING_DICTIONARY
- (HNDictionary *) classPool {
    if ( [ class_variables_ isNil ] )
        class_variables_ = [ [ HNBindingDictionary new ] environment: self ];

    return class_variables_;
}
#endif  /* def HEZELNUT_HAVE_BINDING_DICTIONARY */


#ifdef HEZELNUT_HAVE_SET
- (HNSet *) classVarNames {
    if ( [ class_variables_ notNil ] )
        return [ class_variables_ keys ];
    else
        return [ HNSet new ];
}


- (HNSet *) allClassVarNames {
    id super_var_names = [ self classVarNames ];
#   ifndef HEZELNUT_ENABLE_BLOCK
    id it = [ [ self allSuperclasses ] iterator ];
    id each;
    for ( ; [ it finished ]; [ it next ] ) {
        each = [ it current ];
        [ super_var_names addAll: [ each classVarNames ] ];
    }
#   else
    [ [ self allSuperclasses ] do: ^(id each) {
                [ super_var_names addAll: [ each classVarNames ] ];
            } ];
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
    return super_var_names;
}


- (id) addSharedPool: (HNDictionary *)a_dictionary {
    if ( shared_pools_ == nil )
        shared_pools_ = [ HNSet empty ];
    shared_pools_ = [ shared_pools_ copyWithout: a_dictionary ];

    return self;
}


- (HNSet *) sharedPool {
    id set = [ HNSet new ];
#   ifndef HEZELNUT_ENABLE_BLOCK
    id it, each;
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
    /*
      GNU の Objective-C ではブロックを使うことができません。
      正確に云えば、ブロックはファーストクラスではないのです。
      つまり、コード中にブロックを記述することはできず、必ず別の箇所に定義してから、高階関数として渡さなければならないということです。
      これは美しくありませんし、ブロック替わりの関数への変更が必要な場合、スクロールバーがヘトヘトに疲れてしまう場合があるかもしれません。
    */
    if ( [ shared_pools_ notNil ] && [ shared_pools_ notEmpty ] ) {
#   ifdef HEZELNUT_ENABLE_BLOCK
        [ self environment associationsDo: ^(id each) {
                if ( [ [ shared_pools_ identityIncludes: each ] value ] )
                    [ set add: [ each key ] ];
            } ];
#   else
        /*
          とすれば、コレクション中の要素の全てに同じ処理を適用したい時、どの様にすればブロック無しでも同じようなことができるでしょう？
          答えは Iterator パターンです。
          世の中には二種類の反復方法があり、内部イテレータと外部イテレータがそれです。
          内部イテレータは言語に組み込まれているものを云います。
          ブロックがファーストクラスで、それを関数の引数として渡すことができるなら、内部イテレータを使うことができます。
          これは要素の反復以外にも使い道があるのですが、長くなるので割愛することにしましょう。
          この内部イテレータが無理でも諦めてはいけません。
          内部イテレータが言語仕様的に無理でも、外部イテレータがあります。
          外部イテレータは for や while などの制御構文を使い、ロジックをさらけ出すことになります。
          イテレータがやることは以下の 3 つです:

          + 次の要素があるかどうか調べる => finished
          + 次の要素に移る              => next
          + 現在の要素を返す            => current
        */
        it = [ shared_pools_ associationsIterator ];
        for ( ; [ it finished ]; [ it next ] ) {
            each = [ it current ];

            if ( [ [ shared_pools_ identityIncludes: each ] value ] )
                [ set add: [ each key ] ];
        }
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
    }
    return set;
}
#endif  /* def HEZELNUT_HAVE_SET */


#ifdef HEZELNUT_HAVE_ARRAY
- (HNIndexableCollection *) classPragmas {
    return [ HNArray with: [ HNSymbol value: @"category" ]
                     with: [ HNSymbol value: @"comment" ] ];
}
#endif  /* HEZELNUT_HAVE_ARRAY */


- (id) initializeAsRootClass {
#ifdef HEZELNUT_ENABLE_BLOCK
    [ self registerHandler: ^(id method, id ann) {
            [ method rewriteAsCCall: [ [ ann arguments ] at: 1 ] for: self ];
        }
      forPragma: [ HNSymbol value: @"cCall" ] ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */

#ifdef HEZELNUT_ENABLE_BLOCK
    [ self registerHandler: ^(id method, id ann) {
            [ method rewriteAsCCall: [ [ ann arguments ] at: 1 ]
                          returning: [ [ ann arguments ] at: 2 ]
                               args: [ [ ann arguments ] at: 3 ] ];
        }
      forPragma: [ HNSymbol value: @"cCall" ] ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
}


- (id) initialize { return self; }


- (BOOL) equals: (id)a_class {
    return [ a_class isKindOf: Class ] && [ [ self name ] equals: [ a_class name ] ];
}


- (id) extend {
    id method = [ [ self kindOfSubclass ] concat: @"instanceVariableNames:classVariableNames:poolDictionaries:category:" ];

    return [ self perform: [ method: asSymbol ]
                  withArguments:
                      [ [ self name ] asSymbol ],
                  @"",
                  @"",
                  @"",
                  @"Extensions" ];
}


- (BOOL) inheritShape { return NO; }
@end


// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
