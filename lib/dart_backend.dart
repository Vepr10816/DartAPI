import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_backend/controllers/app_financeDataPagination_controller.dart';
import 'package:dart_backend/controllers/app_financeData_controller.dart';
import 'controllers/app_auth_controller.dart';
import 'controllers/app_financeDataAudit_controller.dart';
import 'controllers/app_financeDataLogical_controller.dart';
import 'controllers/app_token_controller.dart';
import 'controllers/app_user_controller.dart';
import 'model/user.dart';
import 'model/catigories.dart';
import 'model/financeData.dart';
import 'model/response.dart';
import 'model/financeData_audit.dart';

class AppService extends ApplicationChannel{
  late final ManagedContext managedContext;

  Future prepare(){
    final persistentStore = _initDatabase();

    managedContext = ManagedContext(ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);

    return super.prepare();
  }


  @override
  Controller get entryPoint => Router()
    ..route('token/[:refresh]').link(
      () => AppAuthContoler(managedContext),
    )
    ..route('user')
        .link(AppTokenContoller.new)!
        .link(() => AppUserConttolelr(managedContext))
    ..route('finance/[:id]')
      .link(AppTokenContoller.new)!
      .link(() => AppFinanceDataController(managedContext))
    ..route('finance/logical/[:id]')
      .link(AppTokenContoller.new)!
      .link(() => AppFinanceDataLogicalController(managedContext))
    ..route('finance/pagination/[:pageNumber]')
      .link(AppTokenContoller.new)!
      .link(() => AppFinanceDataPaginationController(managedContext))
    ..route('finance/history')
      .link(AppTokenContoller.new)!
      .link(() => AppFinanceDataAuditController(managedContext));
    
  PersistentStore _initDatabase(){
    final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? '1';
    final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';
    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    final databaseName = Platform.environment['DB_NAME'] ?? 'postgres';
    return PostgreSQLPersistentStore(username, password, host, port, databaseName);
  }
}
