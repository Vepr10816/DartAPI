import 'package:conduit/conduit.dart';
import 'catigories.dart';
import 'user.dart';

class FinanceData extends ManagedObject<_FinanceData> implements _FinanceData {}

class _FinanceData{
  @primaryKey
  int? id;
  @Column(indexed: true)
  String? operationName;
  @Column(indexed: true)
  String? description;
  @Column(indexed: true)
  DateTime? operationDate;
  @Column(indexed: true)
  double? operationTotal;
  @Column(indexed: true)
  bool? isDeleted;

  @Serialize(input: true, output: false)
  int? idCategory;

  @Relate(#financeList, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
  @Relate(#financeList, isRequired: true, onDelete: DeleteRule.cascade)
  Categories? category;

}