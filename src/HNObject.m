#import <hezelnut/hezelnut.h>

#ifdef HEZELNUT_HAVE_CLASS
#   import <hezelnut/HNClass.h>
#endif  /* def HEZELNUT_HAVE_CLASS */
#ifdef HEZELNUT_HAVE_SYMBOL
#   import <hezelnut/HNSymbol.h>
#endif  /* def HEZELNUT_HAVE_SYMBOL */
#ifdef HEZELNUT_HAVE_OBJECT_MEMORY
#   import <hezelnut/HNObjectMemory.h>
#endif  /* def HEZELNUT_OBJECT_MEMORY */
#ifdef HEZELNUT_HAVE_OBJECT_DUMP
#   import <hezelnut/HNObjectDump.h>
#endif  /* HEZELNUT_HAVE_OBJECT_DUMP */
#ifdef HEZELNUT_HAVE_ERROR
#   import <hezelnut/HNError.h>
#endif  /* def HEZELNUT_HAVE_ERROR */

#ifdef HEZELNUT_HAVE_STREAM
#   import <hezelnut/HNStream.h>
#endif  /* def HEZELNUT_HAVE_STREAM */
#ifdef HEZELNUT_HAVE_WRITE_STREAM
#   import <hezelnut/HNWriteStream.h>
#endif  /* def HEZELNUT_HAVE_WRITE_STREAM */
#ifdef HEZELNUT_HAVE_TRANSCRIPT
#   import <hezelnut/HNTranscript.h>
#endif  /* def HEZELNUT_HAVE_TRANSCRIPT */

#ifdef HEZELNUT_HAVE_SET
#   import <hezelnut/HNSet.h>
#endif  /* def HEZELNUT_HAVE_SET */
#ifdef HEZELNUT_HAVE_WEAK_KEY_IDENTITY_DICTIONARY
#   import <hezelnut/HNWeakKeyIdentityDictionary.h>
#endif  /* def HEZELNUT_HAVE_WEAK_KEY_IDENTITY_DICTIONARY */
#ifdef HEZELNUT_HAVE_ORDERED_COLLECTION
#   import <hezelnut/HNOrderedCollection.h>
#endif  /* def HEZELNUT_HAVE_ORDERED_COLLECTION */
#ifdef HEZELNUT_HAVE_CONSTANT_ARRAY
#   import <hezelnut/HNConstantArray.h>
#endif  /* def HEZELNUT_HAVE_CONSTANT_ARRAY */
#ifdef HEZELNUT_HAVE_STRING
#   import <hezelnut/HNString.h>
#endif  /* def HEZELNUT_HAVE_STRING */

#import <hezelnut/HNObject.h>


static id Dependencies = nil;
static id FinalizableObjects = nil;


@implementation HNObject

+ (id) update: (id)aspect {
  if ( ![ aspect equals returnFromSnapshot ] )
    return self;

  //[ ContextPart checkPresenceOfJIT ];
  FinalizableObjects = nil;
}


+ (id) dependencies {
  return Dependencies;
}
+ (id) dependencies: (id)an_object {
  Dependencies = an_object;

  return Dependencies;
}


#ifdef HEZELNUT_HAVE_SET
+ (id) finalizableObjects {
  if ( [ FinalizableObjects isNil ] )
    FinalizableObjects = [ HNSet new ];

  return FinalizableObjects;
}
#endif  /* def HEZELNUT_HAVE_SET */


#if defined(HEZELNUT_HAVE_WEAK_KEY_IDENTITY_DICTIONARY) && defined(HEZELNUT_HAVE_OBJECT_MEMORY)
+ (id) initialize {
  if ( self != Object )
    return self;

  [ self dependencies: [ HNWeakKeyIdentityDictionary new ] ];
  [ HNObjectMemory addDependent: self ];

  return self;
}
#endif  /* defined(HEZELNUT_HAVE_WEAK_KEY_IDENTITY_DICTIONARY) && defined(HEZELNUT_OBJECT_MEMORY) */


#ifdef HEZELNUT_HAVE_CLASS
(BOOL) isKindOf: (HNClass)a_class {
  return [ [ self class ] equals: a_class ] || [ [ self class ] inheritsFrom: a_class ];
}


(BOOL) isMemberOf: (HNClass)a_class {
  return [ [ self class ] equals: a_class ];
}
#endif  /* def HEZELNUT_HAVE_CLASS */


#ifdef HEZELNUT_HAVE_SYMBOL
(BOOL) respondsTo: (HNSymbol *)a_symbol {
  return [ [ self class ] canUnderstand: a_symbol ];
}
#endif  /* def HEZELNUT_HAVE_SYMBOL */


(BOOL) isNil { return NO; }


(BOOL) notNil { return YES; }



- (id) copy { [ [ self shallowCopy ] postCopy ]; }


- (id) postCopy { return self; }


/*!
 *
 */
- (id) deepCopy {
  int i, num;
  HNClass* klass = [ self class ];
  id a_copy = [ self shallowCopy ];

  if ( [ klass isPointers ] )
    num = [ klass instSize ] + [ self basicSize ];
  else
    num = [ klass instSize ];

  for ( i = 0; i < num; ++ i ) {
    [ a_copy instVarAt: i
                   put: [ [ self instVarAt: i ] copy ] ];
  }
  return a_copy;
}


- (HNClass *)species { return [ self class ]; }


- (id) yourself { return self; }


#ifdef HEZELNUT_HAVE_ORDERED_COLLECTION
- (id) addDependent: (id)an_object {
#   ifndef HEZELNUT_ENABLE_BLOCK
  if ( Dependencies == nil )
    Dependencies = [ HNOrderedCollection new ];
  return [ [ Dependencies at: self ] add: an_object ];
#   else
  return [ [ Dependencies at: self ifAbsentPut: ^(id) { [ HNOrderedCollection new ] } ] add: an_object ];
#   endif  /* ndef HEZELNUT_ENABLE_BLOCK */
}


- (id) removeDependent: (id)an_object {
  id dependencies = [ Dependencies at: self ];
  if ( dependencies == nil )
    dependencies = an_object;
  [ dependencies remove: an_object ];
  if ( [ dependencies size ] < 1 )
    [ Dependencies removeKey: self ];
  return an_object
}


- (HNOrderedCollection *) dependents {
  HNOrderedCollection* dependencies = [ Dependencies at: self ];
  if ( dependencies == nil )
    dependencies = HNOrderedCollection new;
  return [ dependencies asOrderedCollection ];
}
#endif  /* HEZELNUT_HAVE_ORDERED_COLLECTION */


- (void) release {
  [ Dependencies removeKey: self ];
}


- (id) addToBeFinalized {
  return  [ [ self class ] finalizeableObjects add: [ [ HNHomedAssociation key: self
                                                                         value: nil
                                                                   environment: FinalizableObjects ] makeEphemeron ] yourself ];
}


- (id) removeToBeFinalized {
  return [ [ [ self class ] finalizableObjects ] remove: [ HNHomedAssociation key: self
                                                                            value: nil
                                                                      environment: [ [ self class ] finalizableObjects ] ] ];
}


- (void) mourn {}


- (void) finalize {}


- (id) changed {
  return [ self changed: self ];
}
- (id) changed: (id)a_parameter {
#ifndef HEZELNUT_ENABLE_BLOCK
  id dependent;
  id it;  // イテレータ。
  id dependencies = [ [ HNObject dependencies ] at: self ];

  // ifAbsent: が使えないので、指定したキーに対応する値が存在しない時は nil が返ることになる。
  // if ( dependencies == nil )
  //   dependencies = nil;
#else
  id dependencies = [ [ HNObject dependencies ] at: self ifAbsent: ^(id) { return nil } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

  if ( [ dependencies notNil ] ) {
#ifndef HEZELNUT_ENABLE_BLOCK
    it = [ dependencies iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
      dependent = [ it current ];
      [ dependent update: a_parameter ];
    }
#else
    [ dependencies do ^(id dependent) {
          [ dependent update: a_parameter ];    
        } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
  }
  return self;
}


- (id) update: (id)a_parameter {
  return self;
}


- (id) broadcast: (HNSymbol *)a_symbol {
#ifndef HEZELNUT_ENABLE_BLOCK
  id dependent;
  id it;  // イテレータ。
  id dependencies = [ [ HNObject dependencies ] at: self ];

  // ifAbsent: が使えないので、指定したキーに対応する値が存在しない時は nil が返ることになる。
  // if ( dependencies == nil )
  //   dependencies = nil;
#else
  id dependencies = [ [ HNObject dependencies ] at: self ifAbsent: ^(id) { return nil } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

  if ( [ dependencies notNil ] ) {
#ifndef HEZELNUT_ENABLE_BLOCK
    it = [ dependencies iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
      dependent = [ it current ];
      [ dependent perform: a_symbol ];
    }
#else
    [ dependencies do ^(id dependent) {
          [ dependent perform: a_symbol ];
        } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
  }
  return self;
}


- (id) broadcast: (HNSymbol *)a_symbol with: (id)an_object {
#ifndef HEZELNUT_ENABLE_BLOCK
  id dependent;
  id it;  // イテレータ。
  id dependencies = [ [ HNObject dependencies ] at: self ];

  // ifAbsent: が使えないので、指定したキーに対応する値が存在しない時は nil が返ることになる。
  // if ( dependencies == nil )
  //   dependencies = nil;
#else
  id dependencies = [ [ HNObject dependencies ] at: self ifAbsent: ^(id) { return nil } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

  if ( [ dependencies notNil ] ) {
#ifndef HEZELNUT_ENABLE_BLOCK
    it = [ dependencies iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
      dependent = [ it current ];
      [ dependent perform: a_symbol with: an_object ];
    }
#else
    [ dependencies do ^(id dependent) {
          [ dependent perform: a_symbol with: an_object ];
        } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
  }
  return self;
}


- (id) broadcast: (HNSymbol *)a_symbol with: (id)arg1 with: (id)arg2 {
#ifndef HEZELNUT_ENABLE_BLOCK
  id dependent;
  id it;  // イテレータ。
  id dependencies = [ [ HNObject dependencies ] at: self ];

  // ifAbsent: が使えないので、指定したキーに対応する値が存在しない時は nil が返ることになる。
  // if ( dependencies == nil )
  //   dependencies = nil;
#else
  id dependencies = [ [ HNObject dependencies ] at: self ifAbsent: ^(id) { return nil } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */

  if ( [ dependencies notNil ] ) {
#ifndef HEZELNUT_ENABLE_BLOCK
    it = [ dependencies iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
      dependent = [ it current ];
      [ dependent perform: a_symbol with: arg1 with: arg2 ];
    }
#else
    [ dependencies do ^(id dependent) {
          [ dependent perform: a_symbol with: arg1 with: arg2 ];
        } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
  }
  return self;
}
#ifdef HEZELNUT_ENABLE_BLOCK
- (id) broadcast: (HNSymbol *)a_symbol withBlock: a_block {
  id dependencies = [ [ HNObject dependencies ] at: self
                                          ifAbsent: ^(id) { return nil } ];

  if ( [ dependencies notNil ] )
    [ dependencies do: ^(id dependent) {
          [ dependent perform: a_symbol with [ a_block value: dependent ] ];
        } ];
    return self;
}
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
#ifdef HEZELNUT_HAVE_CONSTANT_ARRAY
- (id) broadcast: (HNSymbol *)a_symbol withArguments: (HNConstantArray *)an_array {
#ifndef HEZELNUT_ENABLE_BLOCK
  id dependent;
  id it;  // イテレータ。
  id dependencies = [ [ HNObject dependencies ] at: self ];

  // ifAbsent: が使えないので、指定したキーに対応する値が存在しない時は nil が返ることになる。
  // if ( dependencies == nil )
  //   dependencies = nil;
#else
  id dependencies = [ [ HNObject dependencies ] at: self ifAbsent: ^(id) { return nil } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
  if ( [ dependencies notNil ] ) {
#ifndef HEZELNUT_ENABLE_BLOCK
    it = [ dependencies iterator ];
    for ( ; [ it finished ]; [ it next ] ) {
      dependent = [ it current ];
      [ dependent perform: a_symbol withArguments: an_array ];
    }
#else
    [ dependencies do ^(id dependent) {
          [ dependent perform: a_symbol withArguments: an_array ];
        } ];
#endif  /* ndef HEZELNUT_ENABLE_BLOCK */
  }
  return self;
}
#endif  /* def HEZELNUT_HAVE_CONSTANT_ARRAY */

#ifdef HEZELNUT_HAVE_STREAM
- (id <HNPString>) displayString {
  id stream = [ HNWriteStream on: [ HNString new ] ];
  [ self displayOn: stream ];
  return [ stream contents ];
}


- (id) - displayOn: (HNStream *)a_stream {
  return [ self printOn: a_stream ];
}


- (id) display {
  [ HNTranscript show: [ self displayString ] ];

  return self;
}


- (id) displayNl {
  [ HNTranscript showCr: [ self displayString ] ];

  return self;
}


- (id <HNPString>) printString {
  id stream = [ HNWriteStream on: [ HNString new ] ];
  [ self printOn: stream ];
  return [ stream contents ];
}


- (id) printOn: (HNStream *)a_stream {
  [ a_stream nextPutAll: [ [ self class ] article ] ];
  [ a_stream space ];
  [ a_stream nextPutAll: [ [ self class ] name ] ];
  return self;
}
#endif  /* def HEZELNUT_HAVE_STREAM */


- (id <HNPString>) basicPrintOn: (HNPStreaming *)a_stream {
  [ a_stream nextPutAll: [ [ self class ] article ] ];
  [ a_stream space ];
  [ a_stream nextPutAll: [ [ self class ] name ] ];
  return self;
}


#ifdef HEZELNUT_HAVE_TRANSCRIPT
- (id) print {
  [ HNTranscript show: [ self printString ] ];
  return self;
}


- (id) printNl {
  [ HNTranscript showCr: [ self printString ] ];
  return self;
}
#endif  /* def HEZELNUT_HAVE_TRANSCRIPT */


- (id) basicPrintNl {
  [ HNstdout flush ];
  [ self basicPring ];
  [ HNstdout nextPut: [ HNCharacter nl ] ];
  [ HNstdout flush ];
  return self;
}


#ifdef HEZELNUT_HAVE_STREAM
- (id <HNPString>) storeString {
  id stream = [ HNWriteStream on: [ HNString new ] ];
  [ self printOn: stream ];
  return [ stream contents ];
}


- (id) storeLiteralOn: (HNStream *)a_stream {
  [ a_stream nextPutAll: @"##(" ];
  [ self storeOn: a_stream ];
  [ a_stream nextPut: ')' ];
  return self;
}


- (id) storeOn: (HNStream *)a_stream {
  int i;
  id klass = [ self class ];
  BOOl has_semi = NO;
  int instance_size = [ klass instSize ],
    valid_size = 0;

  [ a_stream nextPut: '(' ];
  [ a_stream nextPutAll [ klass storeString ] ];

  for ( i = 0; i < instance_size; ++ i ) {
    [ a_stream nextPutAll: @" instVarAt: " ];
    [ [ HNInteger value: i ] printOn: a_stream ];
    [ a_stream nextPutAll: @" put: " ];
    [ [ self instVarAt: i ] storeOn: a_stream ];
    [ a_stream nextPut: ';' ];
    has_semi = YES;
  }
  if ( [ klass isVariable ] ) {
    valid_size = [ self validSize ];
    for ( i = 0; i < valid_size; ++ i ) {
      [ a_stream nextPutAll: @" basicAt: " ];
      [ [ HNInteger value: i ] printOn: a_stream ];
      [ a_stream nextPutAll: @" put: " ];
      [ [ self basicAt: i ] storeOn: a_stream ];
      [ a_stream nextPut: ';' ];
      has_semi = YES;
    }
  }
  if ( has_semi )
    [ a_stream nextPutAll: @" yourself" ];
  [ a_stream nextPut: ')' ];
  return self;
}


#   ifdef HEZELNUT_HAVE_TRANSCRIPT
/*!
 * 
 */
- (id) store {
  [ HNTranscript show: [ self storeString ] ];
  return self;
}


/*!
 * 
 */
- (id) storeNl{
  [ HNTranscript showCr: [ self storeString ] ];
  return self;
}
#   endif  /* def HEZELNUT_HAVE_TRANSCRIPT */
#endif  /* def HEZELNUT_HAVE_STREAM */


#ifdef HEZELNUT_HAVE_OBJECT_DUMP
- (id) binaryRepresentationObject {
  if ( [ HNObjectDumper proxyClassFor: self ] == !HNPluggableProxy )
    [ self subclassResponsibility ];
  else
    [ self shouldNotImplement ];

  return self;
}
#endif  /* def HEZELNUT_HAVE_OBJECT_DUMP */


- (id) postLoad { return self; }


- (id) postStore { return [ self postLoad ]; }


- (id) preStore { return self; }


- (id) reconstructOriginalObject {
  [ self subclassResponsibility ];

  return self;
}


#ifdef HEZELNUT_HAVE_TRANSCRIPT
- (id) examine {
  [ self examineOn: HNTranscript ];

  return self;
}


#   ifdef HEZELNUT_HAVE_STREAM
- (id) examineOn: (HNStream *)a_stream {
  int i;
  id inst_vars;
  id output;
  id object;
  int inst_vars_size,
    valid_size;

  [ a_stream nextPutAll: @"An instance of " ];
  [ a_stream print: [ self class ] ];
  [ a_stream nl ];

  inst_vars = [ [ self class ] allInstVarNames ];
  inst_vars_size = [ inst_vars size ];
  valid_size = valid_size;

  for ( i = 0; i < ( inst_vars_size + valid_size ); ++ i ) {
    object = [ self instVarAt: i ];
    // on:do: が何するメソッドなのか分からないので書けない。
    // 多分、try-catch と同じようなものだと思われる。
    @try {
      output = [ object printString ];
    } @catch ( HNError* err ) {
      output = [ err return: [ HNString format: @"%@ %@"
                                          with: [ [ object class ] article ]
                                          with: [ [ [ object class ] name ] asString ] ] ];
    }
    if ( i <= inst_vars_size ) {
      [ a_stream nextPutAll: "  " ];
      [ a_stream nextPutAll: [ inst_vars at: i ] ];
      [ a_stream nextPutAll: ": " ];
    } else {
      [ a_stream nextPutAll: " [" ];
      [ a_stream print: i - inst_vars_size ];
      [ a_stream nextPutAll: "]: " ];
    }
    [ [ a_stream nextPutAll: output ] nl ];
  }
}
#   endif  /* def HEZELNUT_HAVE_STREAM */


- (id) inspect {
  [ self examineOn: HNTranscript ];

  return self;
}
#endif  /* def HEZELNUT_HAVE_TRANSCRIPT */


- (int) validSize {
  return [ self basicSize ];
}


- (id <HNPCollectable>) allOwners {
  return hn_object_all_owners( self );
}


- (void) changeClassTo: (HNBehavior *)a_behavior {
  hn_object_change_class_to( self, a_behavior );
}


#ifdef HEZELNUT_ENABLE_BLOCK
- (id) checkIndexableBounds: (int)index ifAbsent: a_block {
}
#endif  /* def HEZELNUT_ENABLE_BLOCK */
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
