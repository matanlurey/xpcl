@experimental
library xpcl;

import 'dart:io' as io;

import 'package:meta/meta.dart';

/// Represents a limited surface an option can interact with.
@sealed
abstract class Context {
  /// Opens a sub-menu as a result.
  void open(Menu menu);

  /// Ends the session.
  void terminate();
}

/// Represents a menu of options.
@immutable
@sealed
class Menu {
  /// Options for the menu.
  final List<Option> options;

  /// Label for the menu.
  final String Function() label;

  /// Optional catch-all for another option.
  final void Function(String, Context)? orElse;

  Menu({
    required this.label,
    this.orElse,
    List<Option> options = const [],
  }) : options = List.unmodifiable(options);
}

/// Represents an option in the menu.
@immutable
@sealed
class Option {
  /// Name and display label for the option.
  final String name;

  /// Function to execute when the option is selected.
  final void Function(Context) on;

  const Option({
    required this.name,
    required this.on,
  });
}

/// A specification implementation that uses very basic `stdout` and `stdin`.
///
/// Mostly for demonstrative purposes, a full featured terminal or terminal
/// emulator would want to consider a specific rewrite, potentially using other
/// libraries or FFI.
@sealed
class BasicTerminalExecutor implements Context {
  final io.Stdout _stdout;
  final io.Stdin _stdin;

  var _terminated = false;

  BasicTerminalExecutor({
    io.Stdout? stdout,
    io.Stdin? stdin,
  })  : _stdout = stdout ?? io.stdout,
        _stdin = stdin ?? io.stdin;

  @override
  void open(Menu menu) {
    if (_terminated) {
      throw UnimplementedError('Executor was already terminated... Oops');
    }

    _stdout.writeln(menu.label());
    for (var i = 0; i < menu.options.length; i++) {
      final option = menu.options[i];
      final number = i + 1;

      _stdout.writeln('  $number. ${option.name}');
    }

    final input = _stdin.readLineSync();
    if (input == null) {
      return;
    }
    final picked = int.tryParse(input);
    if (picked == null) {
      return;
    }

    if (picked < 1 || picked > menu.options.length) {
      menu.orElse?.call(input, this);
    } else {
      menu.options[picked - 1].on(this);
    }
  }

  @override
  void terminate() {
    _terminated = true;
  }

  static bool _never() => false;

  void run(Menu loop, {bool Function() terminateWhen = _never}) {
    while (!_terminated && !terminateWhen()) {
      open(loop);
    }
  }
}
