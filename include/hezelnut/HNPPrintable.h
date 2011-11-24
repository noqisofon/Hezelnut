#ifndef hezelnut_HNPPrintable_h
#define hezelnut_HNPPrintable_h


/*! \protocol HNPPrintable HNPPrintable.h
  
 */
@protocol HNPPrintable
#ifdef HEZELNUT_HAVE_STREAM
/*!
 * 
 */
- (id <HNPString>) printString;


/*!
 * 
 */
- (id) printOn: (HNStream *)a_stream;
#endif  /* def HEZELNUT_HAVE_STREAM */


#ifdef HEZELNUT_HAVE_TRANSCRIPT
/*!
 * 
 */
- (id) print;


/*!
 * 
 */
- (id) printNl;
#endif  /* def HEZELNUT_HAVE_TRANSCRIPT */
@end


#endif  /* hezelnut_HNPPrintable_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
