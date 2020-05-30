#ifndef __CDK15_TYPES_REFERENCE_TYPE_H__
#define __CDK15_TYPES_REFERENCE_TYPE_H__

#include <cdk/types/basic_type.h>

namespace cdk {

  /**
   * This class represents a reference type concept (such as a C pointer or a C++ reference).
   */
  struct reference_type: public basic_type {
    std::shared_ptr<basic_type> _referenced = nullptr;

  public:
    reference_type(size_t size,  std::shared_ptr<basic_type> referenced) :
        basic_type(size, TYPE_POINTER), _referenced(referenced) {
    }

    ~reference_type() = default;

    std::shared_ptr<basic_type> referenced() const {
      return _referenced;
    }

  };

} // cdk

#endif
