import 'package:easy_localization/easy_localization.dart';
import 'package:regression/generated/codegen_keys.g.dart';

class FieldValidator {
  String? requiredFieldValidator(String? fieldValue) {
    return fieldValue == null || fieldValue.isEmpty
        ? LocaleKeys.errorRequiredField.tr()
        : null;
  }
}
