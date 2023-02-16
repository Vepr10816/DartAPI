import 'dart:io';

import 'package:conduit/conduit.dart';

import '../model/financeData.dart';
import '../model/response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppFinanceDataLogicalController extends ResourceController {
  AppFinanceDataLogicalController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.put('id')
  Future<Response> deleteLogicalFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final financeData = await managedContext.fetchObjectWithID<FinanceData>(id);
      if (financeData == null) {
        return AppResponse.ok(message: "Финансовая запись не найден");
      }
      if (financeData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к финансовой записи :(");
      }
      final qDeleteLogicalFinanceData = Query<FinanceData>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.isDeleted = true;
      await qDeleteLogicalFinanceData.update();
      return AppResponse.ok(message: "Успешное логическое удаление финансовой записи");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка логического удаления или восстановления финансовой записи");
    }
  }

  @Operation.put()
  Future<Response> returnLogicalFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final qDeleteLogicalFinanceData = Query<FinanceData>(managedContext)
        ..where((x) => x.isDeleted).equalTo(true)
        ..where((x) => x.user!.id).equalTo(currentUserId)
        ..values.isDeleted = false;
      await qDeleteLogicalFinanceData.update();
      return AppResponse.ok(message: "Успешное логическое восстановление финансовых записей");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка логического удаления или восстановления финансовой записи");
    }
  }
  

}

