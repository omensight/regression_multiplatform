import 'package:regression/core/domain/failures/regression_failure.dart';

sealed class CrudFailure extends RegressionFailure {
  CrudFailure({required super.arguments});
}

class CreateDuplicatedIdFailure extends CrudFailure {
  final String entityIdentifier;
  CreateDuplicatedIdFailure({
    required this.entityIdentifier,
  }) : super(arguments: [entityIdentifier]);
}

class CreateDuplicatedNameFailure extends CrudFailure {
  final String entityName;
  CreateDuplicatedNameFailure({
    required this.entityName,
  }) : super(arguments: [entityName]);
}

class ReadFailure extends CrudFailure {
  final String entityIdentifier;
  ReadFailure({
    required this.entityIdentifier,
  }) : super(arguments: [entityIdentifier]);
}

class UpdateFailure extends CrudFailure {
  final String entityIdentifier;
  UpdateFailure({
    required this.entityIdentifier,
  }) : super(arguments: [entityIdentifier]);
}

class DeleteFailure extends CrudFailure {
  final String entityIdentifier;
  DeleteFailure({
    required this.entityIdentifier,
  }) : super(arguments: [entityIdentifier]);
}
