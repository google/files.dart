// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library hop_runner;

import 'dart:async';
import "dart:io";

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart' hide createAnalyzerTask;

var files = ["lib/files.dart", "lib/html.dart", "lib/io.dart"];

void main(List<String> args) {
  addTask("docs", createDocGenTask(".", out_dir: "out/docs"));
  addTask("analyze", createAnalyzerTask(files));

  addTask("bench", createBenchTask());
  addChainedTask("check", ["analyze"]);
  runHop(args);
}

Task createAnalyzerTask(List<String> files, [List<String> extra_args]) {
  var args = [];
  args.addAll(files);
  if (extra_args != null) {
    args.addAll(extra_args);
  }
  return createProcessTask(
      "dartanalyzer",
      args: args,
      description: "Statically Analyze Code");
}

/* Custom DocGen Task for Flexibility */
Task createDocGenTask(String path, {
    bool compile: false,
    Iterable<String> excludes,
    bool include_sdk: true,
    bool include_deps: false,
    String out_dir: "docs",
    bool verbose: false
  }) {
  return new Task((TaskContext context) {
    var args = [];

    if (verbose) {
      args.add("--verbose");
    }

    if (excludes != null) {
      for (String exclude in excludes) {
        context.fine("Excluding Library: ${exclude}");
        args.add("--exclude-lib=${exclude}");
      }
    }

    if (compile) {
      args.add("--compile");
    }

    if (include_sdk) {
      args.add("--include-sdk");
    } else {
      args.add("--no-include-sdk");
    }

    if (include_deps) {
      args.add("--include-dependent-packages");
    } else {
      args.add("--no-include-dependent-packages");
    }

    args.add("--out=${out_dir}");

    args.addAll(context.arguments.rest);

    args.add(path);

    context.fine("using argments: ${args}");

    return Process.start("docgen", args).then((process) {
      return inheritIO(process);
    }).then((code) {
      if (code != 0) {
        context.fail("docgen exited with the status code ${code}");
      }
    });
  }, description: "Generates Documentation");
}

Future<int> inheritIO(Process process) {
  process.stdin.addStream(stdin);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);

  return process.exitCode;
}

