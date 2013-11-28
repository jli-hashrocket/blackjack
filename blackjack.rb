#!/usr/bin/env ruby
# encoding: UTF-8
require 'pry'

class Blackjack

  SUITS = ['♠', '♣', '♥', '♦']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  SCORE = {'2'=>2, '3'=>3, '4'=>4, '5'=>5, '6'=>6, '7'=>7, '8'=>8, '9'=>9, '10'=>10, 'J'=>10, 'Q'=>10, 'K'=>10, 'A'=>11}

  def initialize
    @deck = build_deck
    @hand = []
    @dealer_hand = []
  end

  def build_deck
    deck = []
    SUITS.each do |suit|
      VALUES.each do |value|
        deck.push(value + suit)
      end
    end

    deck.shuffle
  end

  def deal_hand(person)
    next_card = @deck.pop
    puts "#{person} was dealt #{next_card}"
    next_card
  end

  def score(hand)
    score = 0
    aces = 0
    hand.each do |card|
      if card != 'A'
        score += SCORE[card[0,card.length-1]]
      else
        aces += 1
      end
    end
    score = aces_score(aces,score)
    score
  end

  def aces_score(ace_num, score)
    ace_num.times do
      if score + SCORE['A'] + (ace_num - 1) <= 21
        score += SCORE['A']
      else
        score += 1
      end
    end
    score
  end

  def bust?(score)
    return true if score > 21
    return false
  end

  def compare_scores(dealer_score = 0, player_score = 0)
    if !dealer_score.nil?
      if (dealer_score > player_score && dealer_score < 22) || dealer_score == player_score || player_score > 21
        puts "Bust! You lose!"
        abort
      elsif (player_score > dealer_score && player_score < 22) || dealer_score > 21
        puts "You win!"
        abort
      end
    end
  end

  def start_game
    # Takes the next card from the top of the deck.
    continue = true
    puts "Welcome to Blackjack!"
    @hand << deal_hand("Player") << deal_hand("Player")
    @new_score = score(@hand)
    puts "Player score is: #{@new_score} "
    while continue == true
      print "Hit or Stand (H/S): "
      option = gets.chomp.downcase
      if option == 'h'
        @hand << deal_hand("Player")
        @new_score = score(@hand)
        puts "Player score #{@new_score}"
        if bust?(@new_score)
          puts "Bust! You lose."
          break
        end
      elsif option == 's'
        @dealer_hand << deal_hand("Dealer") << deal_hand("Dealer")
        @dealer_score = score(@dealer_hand)
        puts "Dealer score is #{@dealer_score}"
        until @dealer_score >= 17
          @dealer_hand << deal_hand("Dealer")
          @dealer_score = score(@dealer_hand)
          puts "Dealer score is: #{@dealer_score}"
          if bust?(@dealer_score)
            break
          end
        end
      end
      compare_scores(@dealer_score,@new_score)
    end
  end
end

