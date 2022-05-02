/// A basic example of the "Casino War" card game.
///
/// Elements:
/// * Six standard 52-card decks.
/// * Cards are ranked in the same way poker games are ranked.
/// * One card each is dealt to a daler and a player.
/// * A tie occurs when the dealer and player have the same ranked cards.
///
/// See: <https://en.wikipedia.org/wiki/Casino_War>
library example.war;

import 'dart:io';

import 'package:meta/meta.dart';

void main() {
  var deck = const <Card>[];
  var money = 100;

  stdout.writeln('Welcome to Casino War');

  Card draw() {
    if (deck.isEmpty) {
      deck = buildDecks();
    }
    return deck.removeLast();
  }

  while (money > 0) {
    stdout.write('You have \$$money. How much to be? (0=EXIT): ');

    final input = stdin.readLineSync();
    if (input == null) {
      continue;
    }
    final amount = int.tryParse(input);
    if (amount == null || money - amount < 0) {
      continue;
    }
    if (amount == 0) {
      break;
    }

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
      stdout
        ..writeln('... TIE')
        ..writeln(' 1: SURRENDER (Half)')
        ..writeln(' 2: GO TO WAR (Double)');

      var tie = stdin.readLineSync();
      while (tie == null) {
        tie = stdin.readLineSync();
        if (tie != '1' && tie != '2') {
          tie = null;
        }
      }
      if (tie == '1') {
        money += amount ~/ 2;
      } else {
        for (var i = 0; i < 3; i++) {
          draw();
        }
      }
    }
  }

  stdout.writeln("And... that's all of the cards and/or money (\$$money).");
}

List<Card> buildDecks() {
  final singleDeck = [
    for (final suit in const [
      Suit.diamonds,
      Suit.clubs,
      Suit.hearts,
      Suit.spades,
    ])
      for (final rank in const [
        Rank.two,
        Rank.three,
        Rank.four,
        Rank.five,
        Rank.six,
        Rank.seven,
        Rank.eight,
        Rank.nine,
        Rank.ten,
        Rank.jack,
        Rank.queen,
        Rank.king,
        Rank.ace,
      ])
        Card(suit, rank)
  ];
  return [for (int i = 0; i < 6; i++) ...singleDeck]..shuffle();
}

@immutable
@sealed
class Card {
  final Suit suit;
  final Rank rank;

  const Card(this.suit, this.rank);

  @override
  bool operator ==(Object other) {
    return other is Card && suit == other.suit && rank == other.rank;
  }

  @override
  int get hashCode => Object.hash(suit, rank);

  @override
  String toString() => '${suit.symbol} ${rank.symbol}';
}

/// Represents the "rank" of a [Card].
@immutable
@sealed
class Rank implements Comparable<Rank> {
  static const two = Rank._(2, 'Two', '2');
  static const three = Rank._(3, 'Three', '3');
  static const four = Rank._(4, 'Four', '4');
  static const five = Rank._(5, 'Five', '5');
  static const six = Rank._(6, 'Six', '6');
  static const seven = Rank._(7, 'Six', '7');
  static const eight = Rank._(8, 'Six', '8');
  static const nine = Rank._(9, 'Six', '9');
  static const ten = Rank._(10, 'Six', '10');
  static const jack = Rank._(11, 'Six', 'J');
  static const queen = Rank._(12, 'Six', 'Q');
  static const king = Rank._(13, 'Six', 'K');
  static const ace = Rank._(14, 'Six', 'A');

  /// Formal name of the rank.
  final String name;

  /// 1 to 2 character string symbol of the rank.
  final String symbol;

  /// Used to define the ranking order (i.e. for determining the winner).
  final int _order;

  const Rank._(this._order, this.name, this.symbol);

  @override
  int get hashCode => _order;

  @override
  bool operator ==(Object other) => other is Rank && _order == other._order;

  @override
  int compareTo(Rank other) => _order - other._order;
}

/// Represents the "suit" of a [Card].
@immutable
@sealed
class Suit {
  static const diamonds = Suit._('Diamonds', '♦');
  static const clubs = Suit._('Clubs', '♣');
  static const hearts = Suit._('Hearts', '♥');
  static const spades = Suit._('Spades', '♠');

  /// Formal name of the suit.
  final String name;

  /// 1-character unicode symbol of the suit.
  final String symbol;

  const Suit._(this.name, this.symbol);

  @override
  int get hashCode => symbol.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Suit && symbol == other.symbol;
  }
}
