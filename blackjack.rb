#!/usr/bin/env ruby
# encoding: UTF-8
require 'pry'

class Blackjack

  SUITS = ['♠', '♣', '♥', '♦']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  SCORE = {'2'=>2, '3'=>3, '4'=>4, '5'=>5, '6'=>6, '7'=>7, '8'=>8, '9'=>9, '10'=>10, 'J'=>10, 'Q'=>10, 'K'=>10, 'A'=>11}

  def initialize
    @deck = build_deck
    @score = 0
    @dealer_score = 0
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
    puts "Player was dealt #{next_card}"
    next_card
  end

  def score(hand, person)
    score = 0
    hand.each do |card|
      score += SCORE[card[0,card.length-1]]
    end
    score
  end

  def start_game
    # Takes the next card from the top of the deck.
    puts "Welcome to Blackjack!"
    hand = []
    dealer_hand = []
    hand << deal_hand("Player") << deal_hand("Player")
    score = score(hand, "Player")
    puts "#{person} score is: #{@score} "

    while score <= 21
      print "Hit or Stand (H/S): "
      option = gets.chomp.downcase
      if option == 'h'
        hand << deal_hand("Player")
        score = score(hand, "Player")
        puts "#{person} score is: #{score} "
        if score > 21
          puts "Bust! You lose!"
          break
        end
      elsif option == 's'
        dealer_hand << deal_hand("Dealer") << deal_hand("Dealer")
        dealer_score(hand, "Dealer")
        while @dealer_score < 17
          dealer_hand << deal_hand("Dealer")
          dealer_score(hand, "Dealer")
        end
        if @dealer_score > @score
          puts "Dealer wins"
        end
      end
    end
  end
end

