import 'package:easy_localization/easy_localization.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';
import 'package:regression/core/domain/failures/regression_failure.dart';
import 'package:regression/generated/codegen_keys.g.dart';

class RegressionFailureConverter {
  final List<RegressionFailureConverter> converters;

  RegressionFailureConverter({required this.converters});

  void registerConverter(RegressionFailureConverter newConverter) {
    converters.add(newConverter);
  }

  String convert(RegressionFailure regressionFailure) {
    String? converterFailure;
    int index = 0;
    while (converterFailure == null && index < converters.length) {
      converterFailure = converters[index].convert(regressionFailure);
      index++;
    }
    return converterFailure?.tr(args: regressionFailure.arguments) ??
        LocaleKeys.unspecifiedFailure.tr();
  }
}

class CrudFailureConverter extends RegressionFailureConverter {
  CrudFailureConverter({required super.converters});

  @override
  String convert(RegressionFailure regressionFailure) {
    return switch (regressionFailure) {
      CreateDuplicatedIdFailure() => LocaleKeys.crudFailures_duplicateId,
      CreateDuplicatedNameFailure() => LocaleKeys.crudFailures_duplicatedName,
      ReadFailure() => LocaleKeys.crudFailures_read,
      UpdateFailure() => LocaleKeys.crudFailures_update,
      DeleteFailure() => LocaleKeys.crudFailures_delete,
      RegressionFailure() => LocaleKeys.crudFailures_defaultFailure,
    };
  }
}

class EditDataFailureConverter {}
