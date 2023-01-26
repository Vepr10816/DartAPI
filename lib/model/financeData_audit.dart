import 'package:conduit/conduit.dart';

class FinanceData_audit extends ManagedObject<_FinanceData_audit> implements _FinanceData_audit {}

class _FinanceData_audit
{
  @Column(indexed: true)
  String? operation;
  @Column(indexed: true)
  DateTime? stamp;
  @Column(indexed: true)
  String? userid;
  @Column(indexed: true)
  int? idFinance;
  @Column(indexed: true)
  String? operationName;
  @Column(indexed: true)
  String? description;
  @Column(indexed: true)
  DateTime? operationDate;
  @Column(indexed: true)
  double? operationTotal;
  @Column(indexed: true)
  bool isDeleted = false;
  @Column(indexed: true)
  int? idUser;
  @Column(indexed: true)
  int? idCategory;
  @primaryKey
  int? id;
}