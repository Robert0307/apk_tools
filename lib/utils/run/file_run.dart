import 'dart:io';

import 'package:process_run/shell.dart';

class FileRun {
 static openFolder(String folder) {
    run(
      '${Platform.isMacOS ? 'open' : 'start'} $folder',
      verbose: false,
      commandVerbose: false,
    );
  }
}
