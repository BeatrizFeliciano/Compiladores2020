#ifndef __CDK15_TYPES_TYPES_H__
#define __CDK15_TYPES_TYPES_H__

#include <cdk/types/basic_type.h>
#include <cdk/types/primitive_type.h>
#include <cdk/types/reference_type.h>
#include <cdk/types/structured_type.h>
#include <memory>

namespace cdk {

  inline std::shared_ptr<primitive_type> make_primitive_type(size_t size, typename_type name) {
    return std::make_shared<primitive_type>(size, name);
  }

  inline std::shared_ptr<reference_type> make_reference_type(size_t size, std::shared_ptr<basic_type> referenced) {
    return std::make_shared<reference_type>(size, referenced);
  }

  inline std::shared_ptr<structured_type> make_structured_type(const std::vector<std::shared_ptr<basic_type>> &types) {
    return std::make_shared<structured_type>(types);
  }

  inline std::shared_ptr<reference_type> reference_type_cast(std::shared_ptr<basic_type> type) {
    return std::dynamic_pointer_cast<reference_type>(type);
  }

  inline std::shared_ptr<structured_type> structured_type_cast(std::shared_ptr<basic_type> type) {
    return std::dynamic_pointer_cast<structured_type>(type);
  }

  inline std::string to_string(std::shared_ptr<basic_type> type) {
    if (type->name() == TYPE_INT) return "integer";
    if (type->name() == TYPE_DOUBLE) return "double";
    if (type->name() == TYPE_STRING) return "string";
    if (type->name() == TYPE_VOID) return "void";
    if (type->name() == TYPE_POINTER) {
      std::string s = "pointer";
      std::shared_ptr<basic_type> p = std::dynamic_pointer_cast<reference_type>(type)->referenced();
      while (p->name() == TYPE_POINTER) {
        s += " to " + to_string(p);
        p = std::dynamic_pointer_cast<reference_type>(p)->referenced();
      }
      return s;
    } else {
      return "";
    }
  }

}// cdk

#endif
