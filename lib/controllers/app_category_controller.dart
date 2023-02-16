import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_backend/model/catigories.dart';

import '../model/financeData.dart';
import '../model/response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppCategoryController extends ResourceController {
  AppCategoryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getFullFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  ) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      final qGetCategory = Query<Categories>(managedContext);

      final List<Categories> list = await qGetCategory.fetch();

      if (list.isEmpty)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "Нет ни одной записи по финансам"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }


}

