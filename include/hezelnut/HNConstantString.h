#ifndef Hezelnut_HNConstantString_h
#define Hezelnut_HNConstantString_h

#import <objc/Object.h>
#import "HNPString.h"


@interface HNConstantString : Object < HNPString >
{
  unsigned int length_;
  char* c_string_;
}
/*** @addgroup instance creation */
+ (HNConstantString *) cr;
+ (HNConstantString *) lf;
+ (HNConstantString *) crlf;
+ (HNConstantString *) crlfcrlf;
+ (HNConstantString *) tab;
+ (HNConstantString *) new: (unsigned int)size_requested;
+ (HNConstantString *) value: (int)ch;
+ (HNConstantString *) with: (char)ch;
+ (HNConstantString *) fromString: (NXConstantString *)a_string;
+ (HNConstantString *) fromCString: (const char *)cs;
#ifdef HEZELNUT_HAS_BYTEARRAY
+ (HNConstantString *) fromByteArray: (HNByteArray *)a_byte_array;
#endif  /* ifdef HEZELNUT_HAS_BYTEARRAY */
#ifdef HEZELNUT_HAS_STREAM
+ (HNConstantString *) fromStream: (HNStream *)a_stream;
#endif  /* ifdef HEZELNUT_HAS_STREAM */

/*** @addgroup initialization */
- (id) init: (unsigned int)size_requested;
- (id) init: (unsigned int)size_requested fillCharacter: (char)ch;
- (id) initWithCString: (const char *)cs;
- (id) initWithHNConstantString: (HNConstantString *)an_string;
- (id) initWithNXConstantString: (NXConstantString *)an_string;
@end

#define HEZELNUT_HAS_CONSTANT_STRING   1

#endif  /* Hezelnut_HNConstantString_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
