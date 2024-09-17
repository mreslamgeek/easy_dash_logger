library easy_dash_logger;

import 'dart:developer' as dev;

import 'src/platform_specific_logger/is_dart.dart'
    if (dart.library.ui) 'src/platform_specific_logger/is_flutter.dart';

part 'src/enums.dart';
part 'src/logger.dart';
