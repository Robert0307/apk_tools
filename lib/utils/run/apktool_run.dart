import 'dart:developer';
import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/home/tools/tools_config.dart';
import 'package:process_run/shell.dart';

class ApkToolRun {
  static dynamic getEnvironment() {
    var environment = ShellEnvironment();
    environment.paths[0] = '${AppConfig.jdkPath}';
    environment.paths[1] = '${AppConfig.javaHomeBin}';
    log(environment.paths[0]);
    log(environment.paths[1]);
    return environment;
  }

  static Future<void> aapt2Compile(
      {required String resPath, required String outputZip, required StatusCallback status}) {
    return run('${aapt2()} compile -v --dir $resPath -o $outputZip/res.zip',
        verbose: false, commandVerbose: false, environment: getEnvironment(), onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.errText.isNotEmpty) {
        status.onError(1);
        status.onResult(1, value.errText);
      } else {
        status.onResult(0, value.outText);
      }
    });
  }

  static Future<void> decompiling(
      {required String fromApk, required String outputApk, required StatusCallback status}) {
    return run(
        'java -jar ${apktool()} '
        'd --force --only-main-classes $fromApk '
        '--output $outputApk',
        verbose: false,
        commandVerbose: false,
        environment: getEnvironment(), onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.errText.isNotEmpty) {
        status.onError(1);
        status.onResult(1, value.errText);
        log(value.errText);
      } else {
        status.onResult(0, value.outText);
      }
    }).catchError((error) {
      log(error.toString());
    });
  }

  static Future<void> compile({required String fromPath, required String outputApk, required StatusCallback status}) {
    return run(
        'java -jar ${apktool()} '
        'b $fromPath '
        '-o $outputApk',
        verbose: false,
        commandVerbose: false,
        environment: getEnvironment(), onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.errText.isNotEmpty) {
        status.onResult(1, value.errText);
      } else {
        status.onResult(0, value.outText);
      }
    });
  }

  static Future<void> sign(
      {required String fromApk,
      required String outputApk,
      required String signFile,
      required String pass,
      required String aliasPass,
      required String alias,
      required bool v2Enabled,
      required StatusCallback status}) {
    return run(
        'java -jar ${apksigner()} sign '
        '-verbose --ks $signFile '
        '--v1-signing-enabled true '
        '--v2-signing-enabled $v2Enabled '
        '--v3-signing-enabled false '
        '--ks-key-alias $alias '
        '--ks-pass pass:$pass '
        '--key-pass pass:$aliasPass '
        '--out $outputApk $fromApk',
        environment: getEnvironment(),
        verbose: false,
        commandVerbose: false, onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.errText.isNotEmpty) {
        status.onResult(1, value.errText);
      } else {
        status.onResult(0, value.outText);
      }
    });
  }

  static Future<void> signAlias({required String signFile, required String pass, required StatusCallback status}) {
    return run('keytool -list -v -keystore $signFile -storepass $pass',
        environment: getEnvironment(), verbose: false, commandVerbose: false, onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      log(value.outText);
      if (value.outText.isNotEmpty) {
        status.onResult(0, value.outText);
      } else {
        status.onResult(1, value.errText);
      }
    });
  }

  static Future<void> getSign({required String filePath, required StatusCallback status}) {
    return run('keytool -printcert -file $filePath',
        environment: getEnvironment(), verbose: false, commandVerbose: false, onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.outText.isNotEmpty) {
        status.onResult(0, value.outText);
      } else {
        status.onResult(1, value.errText);
      }
    });
  }

  static Future<void> getClass({required String filePath, required StatusCallback status}) {
    return run(' - javac -source 1.8 -target 1.8 -encoding UTF-8 $filePath',
        environment: getEnvironment(), verbose: false, commandVerbose: false, onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.outText.isNotEmpty) {
        status.onResult(0, value.outText);
      } else {
        status.onResult(1, value.errText);
      }
    });
  }

  static Future<void> zipalign({required String fromApk, required String outputApk, required StatusCallback status}) {
    return run(
        '${zipaligns()} '
        '-f -v 4 $fromApk $outputApk',
        verbose: false,
        commandVerbose: false,
        environment: getEnvironment(), onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.errText.isNotEmpty) {
        status.onResult(1, value.errText);
        status.onError(1);
      } else {
        status.onResult(0, value.outText);
      }
    });
  }

  static Future<void> dex2Jar({required String fromApk, required String outputJar, required StatusCallback status}) {
    return run('${Platform.isMacOS ? 'sh ${dexToJar()}' : dexToJarBat()} --force $fromApk -o $outputJar',
        verbose: false, commandVerbose: false, environment: getEnvironment(), onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.errText.isNotEmpty) {
        status.onResult(1, value.errText);
      } else {
        status.onResult(0, value.outText);
      }
    });
  }

  static Future<void> apkanalyzers({required String fromApk, bool dex = false, required StatusCallback status}) {
    return run('java -jar ${apkanalyzer()} ${dex ? 'dex references' : ''} $fromApk',
        environment: getEnvironment(), verbose: false, commandVerbose: false, onProcess: (result) {
      result.exitCode.then((value) {
        if (value == 0) {
          status.onSuccess();
        } else {
          status.onError(value);
        }
      });
    }).then((value) {
      if (value.errText.isNotEmpty) {
        status.onResult(1, value.errText);
      } else {
        status.onResult(0, value.outText);
      }
    });
  }
}
