library hop_runner;

import 'dart:async';
import "dart:io";

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart' hide createAnalyzerTask;

part 'docgen.dart';
part 'utils.dart';
part 'analyze.dart';

var files = ["lib/files.dart", "lib/html.dart", "lib/io.dart"];

void main(List<String> args) {
  addTask("docs", createDocGenTask(".", out_dir: "out/docs"));
  addTask("analyze", createAnalyzerTask(files));

  addTask("bench", createBenchTask());
  addChainedTask("check", ["analyze"]);
  runHop(args);
}
