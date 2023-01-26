import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_backend/model/financeData_audit.dart';
import '../model/response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppFinanceDataAuditController extends ResourceController {
  AppFinanceDataAuditController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getFinanceHistory() 
  async {
    try {

      final qGetFinanceDataAudit = Query<FinanceData_audit>(managedContext);

      final List<FinanceData_audit> list = await qGetFinanceDataAudit.fetch();

      if (list.isEmpty)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "Страница пуста"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

}

