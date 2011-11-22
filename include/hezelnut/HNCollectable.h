

@protocol HNPCollectable
/**
 * 
 */
- (int) indexOfSubCollection: (id <HNPCollectable>)sub_collection;
#ifdef HEZELNUT_ENABLE_BLOCK
/**
 * 
 */
- (int) indexOfSubCollection: (id <HNPCollectable>)sub_collection startingAt: (int)start_index ifAbsent: exception_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
