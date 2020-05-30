#ifndef __CDK15_TYPES_PRIMITIVE_TYPE_H__
#define __CDK15_TYPES_PRIMITIVE_TYPE_H__

#include <cdk/types/typename_type.h>
#include <cdk/types/basic_type.h>
#include <cstdlib>

namespace cdk {

  /**
   * Primitive (i.e., non-structured non-indirect) types.
   */
  class primitive_type: public basic_type {
  public:
    primitive_type() :
        basic_type(0, TYPE_UNSPEC) {
    }
    primitive_type(size_t size, typename_type name) :
        basic_type(size, name) {
    }
    ~primitive_type() = default;
  };

} // cdk

#endif
