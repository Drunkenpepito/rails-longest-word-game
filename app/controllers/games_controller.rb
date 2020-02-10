require 'open-uri'
require 'date'

class GamesController < ApplicationController
  def new
    @tirage = generate_grid(10)
    @start = Time.now
  end

  def score
    @word = params[:answer]
    @length = @word.length
    # @time = Time.now - params[:time]
    @time = 9
    @exist = parse(@word)
    @grid = params[:displayed_grid]
    @score = calculate_score(@time, @length)
    @message = congratulate(@score)
  end

  def parse(word)
    @url = "https://wagon-dictionary.herokuapp.com/#{word}"
    @var = open(@url).read
    @result = JSON.parse(@var)
    @found = @result['found']
  end

  def generate_grid(grid_size)
    grid = []
    voyels = %w[A E I O U Y]
    (grid_size - 3).times { grid << ("A".."Z").to_a.sample }
    3.times { grid << voyels.to_a.sample }
    grid.shuffle!
  end

  def word_in_grid(word, grid)
    letters = word.upcase.split("")
    letters.all? do |letter|
      a = word.upcase.count(letter)
      b = grid.count(letter)
      a <= b
    end
  end

private

  def congratulate(score)
    return  'You are such a Master!' if score > 100
    return 'Niiiiiice!' if score > 70  && score <= 100
    return 'Good.' if score > 40 && score <= 70
    return 'Not so bad!' if score > 10 && score <= 40
    return 'You suck, my friend!' if score <= 10
  end

  def calculate_score(time, length)
    if @exist && word_in_grid(@word, @grid)
      @score = 10
      # - 5*@time.to_i*1000 + @l.to_i*5
      # @message = m1
    elsif  @exist && word_in_grid(@word, @grid) == false
      @score = 15
      # @message = m2
    elsif @exist == false && word_in_grid(@word, @grid) == true
      @score = 20
      # @message = m3
    end
    # @score
  end
end

# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result
#   url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
#   output = {}
#   output[:time] = end_time - start_time
#   var = open(url).read
#   mot = JSON.parse(var)
#   puts mot["word"].split
#   puts grid.to_s

#   if mot["found"] && word_in_grid(mot["word"], grid)
#     output[:score] = mot.length + 100 - output[:time]
#     output[:message] = 'well done'
#   elsif mot ["found"] && word_in_grid(mot["word"], grid) == false
#     output[:score] = 0
#     output[:message] = "not in the grid"
#   elsif mot ["found"] == false
#     output[:score] = 0
#     output[:message] = "not an english word"
#   end
#   output
#   # mot non valide,
#   #return {"found":false,"word":"zzz","error":"word not found"}
# end

# def word_in_grid(word, grid)
#   letters = word.upcase.split("")
#   letters.all?{|letter|  word.upcase.count(letter)<= grid.count(letter)}
# end
