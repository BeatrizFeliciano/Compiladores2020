#ifndef __CDK15_TYPES_STRUCTURED_TYPE_H__
#define __CDK15_TYPES_STRUCTURED_TYPE_H__

#include <vector>
#include <numeric>
#include <cdk/types/basic_type.h>

namespace cdk {

  /**
   * This class represents a structured type concept.
   */
  class structured_type: public basic_type {
    std::vector<std::shared_ptr<basic_type>> _components;

  private:
    size_t compute_size(const std::vector<std::shared_ptr<basic_type>> &components) {
      size_t size = 0;
      for (auto component : components)
        size += component->size();
      return size;
    }

  public:
    structured_type(const std::vector<std::shared_ptr<basic_type>> &components) :
        basic_type(compute_size(components), TYPE_STRUCT), _components(components) {
      // EMPTY
    }

    ~structured_type() = default;

    std::shared_ptr<basic_type> component(size_t ix) {
      return _components[ix];
    }

    const std::vector<std::shared_ptr<basic_type>>& components() const {
      return _components;
    }

    size_t length() const {
      return _components.size();
    }

  };

} // cdk

#endif
