import 'dart:io';

import 'package:conduit/conduit.dart';

import '../model/financeData.dart';
import '../model/response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppFinanceDataController extends ResourceController {
  AppFinanceDataController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> createFinanceData(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() FinanceData financeData
  ) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      // Создаем запрос для создания финансового отчета передаем id пользователя контент берем из body
      final qCreateFinanceData = Query<FinanceData>(managedContext)
        ..values.operationName = financeData.operationName
        ..values.description = financeData.description
        ..values.operationDate = financeData.operationDate
        ..values.operationTotal = financeData.operationTotal
        ..values.isDeleted = false
        //передаем в внешний ключ id пользователя
        ..values.user!.id = id
        ..values.category!.id = financeData.idCategory;

      await qCreateFinanceData.insert();

      return AppResponse.ok(message: 'Успешное создание финансового отчета');
    } catch (error) {
      return AppResponse.serverError(error, message: 'Ошибка создания финансового отчета');
    }
  }

  /*@Operation.post()
  Future<Response> createFinanceData(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.query('operationName') String operationName,
      @Bind.query('description') String description,
      @Bind.query('operationDate') DateTime operationDate,
      @Bind.query('operationTotal') double operationTotal,
      @Bind.query('category') int category) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      // Создаем запрос для создания финансового отчета передаем id пользователя контент берем из body
      final qCreateFinanceData = Query<FinanceData>(managedContext)
        ..values.operationName = operationName
        ..values.description = description
        ..values.operationDate = operationDate
        ..values.operationTotal = operationTotal
        ..values.isDeleted = false
        //передаем в внешний ключ id пользователя
        ..values.user!.id = id
        ..values.category!.id = category;

      await qCreateFinanceData.insert();

      return AppResponse.ok(message: 'Успешное создание финансового отчета');
    } catch (error) {
      return AppResponse.serverError(error, message: 'Ошибка создания финансового отчета');
    }
  }*/

  @Operation.get()
  Future<Response> getFullFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  ) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      final qCreateFinanceData = Query<FinanceData>(managedContext)
        ..where((x) => x.user!.id).equalTo(id)
        ..where((x) => x.isDeleted).equalTo(false)
        ..sortBy((x) => x.id, QuerySortOrder.ascending);

      final List<FinanceData> list = await qCreateFinanceData.fetch();

      if (list.isEmpty)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "Нет ни одной записи по финансам"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.get("id")
  Future<Response> getFinanceDataFromID(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final financeData = await managedContext.fetchObjectWithID<FinanceData>(id);
      if (financeData == null) {
        return AppResponse.ok(message: "Финансовая запись не найдена");
      }
      if (financeData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к финансовой записи");
      }
      financeData.backing.removeProperty("user");
      return Response.ok(financeData);
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка получения финансовой записи");
    }
  }

  /*@Operation.put('id')
  Future<Response> updateFinanceData(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id,
      @Bind.query('operationName') String operationName,
      @Bind.query('description') String description,
      @Bind.query('operationDate') DateTime operationDate,
      @Bind.query('isDeleted') bool isDeleted,
      @Bind.query('operationTotal') double operationTotal,
      @Bind.query('category') int category) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final financeData = await managedContext.fetchObjectWithID<FinanceData>(id);
      if (financeData == null) {
        return AppResponse.ok(message: "Финансовая запись не найдена");
      }
      if (financeData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к финансовой записи");
      }

      final qUpdateFinanceData = Query<FinanceData>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.operationName = operationName
        ..values.description = description
        ..values.operationDate = operationDate
        ..values.operationTotal = operationTotal
        ..values.isDeleted = isDeleted
        //передаем в внешний ключ id пользователя
        ..values.user!.id = currentUserId
        ..values.category!.id = category;

      await qUpdateFinanceData.update();

      return AppResponse.ok(message: 'Финансовая запись успешно обновлена');

    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
  Future<Response> deleteLogicalFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
    @Bind.query('isDeleted') bool isDeleted,
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
        ..values.isDeleted = isDeleted;
      await qDeleteLogicalFinanceData.update();
      return AppResponse.ok(message: "Успешное логическое удаление финансовой записи");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка логического удаления финансовой записи");
    }
  }*/

  @Operation.put('id')
  Future<Response> updateFinanceData(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id,
      @Bind.body() FinanceData bodyFinanceData
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final financeData = await managedContext.fetchObjectWithID<FinanceData>(id);
      if (financeData == null) {
        return AppResponse.ok(message: "Финансовая запись не найдена");
      }
      if (financeData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к финансовой записи");
      }

      final qUpdateFinanceData = Query<FinanceData>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.operationName = bodyFinanceData.operationName
        ..values.description = bodyFinanceData.description
        ..values.operationDate = bodyFinanceData.operationDate
        ..values.operationTotal = bodyFinanceData.operationTotal
        ..values.isDeleted = bodyFinanceData.isDeleted
        //передаем в внешний ключ id пользователя
        ..values.user!.id = currentUserId
        ..values.category!.id = bodyFinanceData.idCategory;

      await qUpdateFinanceData.update();

      return AppResponse.ok(message: 'Финансовая запись успешно обновлена');

    } catch (e) {
      return AppResponse.serverError(e);
    }
  }


  @Operation.delete("id")
  Future<Response> deleteFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
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
      final qDeleteFinanceData = Query<FinanceData>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteFinanceData.delete();
      return AppResponse.ok(message: "Успешное удаление финансовой записи");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка удаления финансовой записи");
    }
  }

 
  


  

}

