/// A basic example of the "Casino War" card game.
///
/// Similar to `war.dart`, except it uses XPCL for the game loop and rendering.
library example.war_xpcl;

// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:xpcl/xpcl.dart';

import 'war.dart';

void main() {
  var deck = <Card>[
    Card(Suit.clubs, Rank.queen),
    Card(Suit.hearts, Rank.queen),
  ];
  var money = 100;

  stdout.writeln('Welcome to Casino War');

  Card draw() {
    if (deck.isEmpty) {
      deck = buildDecks();
    }
    return deck.removeLast();
  }

  void hand(Context context, int amount) {
    money -= amount;
    final player = draw();
    final dealer = draw();

    stdout
      ..writeln('PLAYER $player ')
      ..writeln('  versus ')
      ..writeln('DEALER $dealer');

    final compare = player.rank.compareTo(dealer.rank);
    if (compare < 0) {
      stdout.writeln('... LOSER ($amount)');
    } else if (compare > 0) {
      stdout.writeln('... WINNER ($amount)');
      money += amount * 2;
    } else {
      context.open(Menu(label: () => '... TIE', options: [
        Option(
          name: 'SURRENDER (Half)',
          on: (_) {
            money += amount ~/ 2;
          },
        ),
        Option(
          name: 'GO TO WAR (Double)',
          on: (_) {
            money += amount;
            for (var i = 0; i < 3; i++) {
              draw();
            }
            hand(context, amount * 2);
          },
        ),
      ]));
    }
  }

  BasicTerminalExecutor().run(
    Menu(
      label: () => 'You have \$$money. How much to be? (0=EXIT):',
      orElse: (input, context) {
        if (input == '0') {
          return context.terminate();
        }
        final amount = int.tryParse(input);
        if (amount != null) {
          hand(context, amount);
        }
      },
    ),
    terminateWhen: () => money < 1,
  );

  stdout.writeln("And... that's all of the cards and/or money (\$$money).");
}
