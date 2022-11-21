require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:word].upcase
    @grid = params[:letters].split(' ')
    @score = @guess.split('').count * @guess.split('').count
    @result = message(@guess, @grid, @score)
  end

  def included?(guess, grid)
    guess.split('').all? { |letter| grid.include? letter }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def message(guess, grid, score)
    if included?(guess, grid)

      if english_word?(guess)
        "Congratulations! #{guess} is a valid English word!
        SCORE : #{score}"
      else
        "Sorry but #{guess} does not seem to be a valid English word"
      end
    else
      "Sorry but #{guess} can't be built out of #{grid.join(',')}"
    end
  end
end
