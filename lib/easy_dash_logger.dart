library easy_dash_logger;

import 'dart:developer' as dev;

import 'src/platform_specific_logger/flutter_logger.dart'
    if (dart.library.io) 'src/platform_specific_logger/dart_logger.dart';

part 'src/enums.dart';
part 'src/logger.dart';
