import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:regression/features/edit_data/domain/usecases/add_empty_data_row_usecase.dart';

void main() {
  test('Return an empty data if the lenth of the data variables length is zero',
      () async {
    final addEmptyDataRowUsecase = AddEmptyDataRowUsecase();
    final result = await addEmptyDataRowUsecase([], 3);
    expect(
      result,
      const Right(
        [
          double.nan,
          double.nan,
          double.nan,
        ],
      ),
    );
  });
}
