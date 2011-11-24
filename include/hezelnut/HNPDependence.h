#ifndef hezelnut_HNPDependence_h
#define hezelnut_HNPDependence_h


/*! \protocol HNPDependence
 */
@protocol HNPDependence
/*! \name class type methods
  
 */
/*! @{ */
/*!
 *
 */
- (HNClass *) species;


/*!
 *
 */
- (id) yourself;


/*!
 * 
 */
- (id) addDependent: (id)an_object;


/*!
 * 
 */
- (id) removeDependent: (id)an_object;


#ifdef HEZELNUT_HAVE_ORDEREDCOLLECTION
/*!
 * 
 */
- (HNOrderedCollection *) dependents;
#endif  /* HEZELNUT_HAVE_ORDEREDCOLLECTION */
/*! @} */                  
@end


#endif  /* hezelnut_HNPDependence_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
