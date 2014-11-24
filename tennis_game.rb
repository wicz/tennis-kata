# encoding: utf-8

class Scoreboard
  def initialize(game)
    @game     = game
    @scores   = {}
    @players  = game.players

    reset_scores_count
  end

  def reset_scores_count
    players.each do |player|
      scores[player.to_s] = 0
    end
  end

  def score_for(player, value = 1)
    scores[player.to_s] += value
  end

  def score_count_for(player)
    scores[player.to_s]
  end

  def display
    "Win for #{game.winner}"
  end

  private

  attr_reader :game, :scores, :players
end

class TennisGame
  attr_reader :players

  def initialize(*players)
    @players    = players
    @scoreboard = Scoreboard.new(self)
  end

  def won_point(player)
    scoreboard.score_for(player, 1)
  end

  def winner
    p1 = players.first
    p2 = players.last

    scoreboard.score_count_for(p1) >
    scoreboard.score_count_for(p2) ? p1 : p2
  end

  def score
    result    = ""
    tempScore = 0
    p1        = players.first
    p2        = players.last
    p1_score  = scoreboard.score_count_for(p1)
    p2_score  = scoreboard.score_count_for(p2)

    if p1_score == p2_score
      result = {
          0 => "Love-All",
          1 => "Fifteen-All",
          2 => "Thirty-All",
      }.fetch(p1_score, "Deuce")
    elsif p1_score >= 4 || p2_score >= 4
      minusResult = p1_score - p2_score

      if minusResult == 1
        result = "Advantage #{p1}"
      elsif minusResult == -1
        result = "Advantage #{p2}"
      elsif minusResult >= 2
        result = scoreboard.display
      else
        result = scoreboard.display
      end
    else
      (1...3).each do |i|
        if i == 1
          tempScore = p1_score
        else
          result += "-"
          tempScore = p2_score
        end
        result += {
            0 => "Love",
            1 => "Fifteen",
            2 => "Thirty",
            3 => "Forty",
        }[tempScore]
      end
    end
    result
  end

  private

  attr_reader :scoreboard
end

