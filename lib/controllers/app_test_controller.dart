import 'dart:io';

import 'package:conduit/conduit.dart';

import '../model/financeData.dart';
import '../model/response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppTestController extends ResourceController {
  AppTestController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getFullFinanceData() 
  async {
    try {

      final qCreateFinanceData = Query<FinanceData>(managedContext);

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

}