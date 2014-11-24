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
      scores[player] = 0
    end
  end

  def score_for(player, value = 1)
    scores[player] += value
  end

  def score_count_for(player)
    scores[player]
  end

  def display
    if game.winner?
      "Win for #{game.winner}"
    elsif game.advantage?
      "Advantage #{game.leader}"
    else
      scores_labels
    end
  end

  private

  SCORE_LABELS = %w(Love Fifteen Thirty Forty).freeze

  attr_reader :game, :scores, :players

  def scores_labels
    scores.values.map do |score|
      score_to_label(score)
    end.join("-")
  end

  def score_to_label(score)
    SCORE_LABELS[score]
  end
end

class TennisGame
  attr_reader :players, :scoreboard

  def initialize(*players)
    @players    = players.map(&:to_s)
    @scoreboard = Scoreboard.new(self)
  end

  def won_point(player)
    scoreboard.score_for(player.to_s, 1)
  end

  def winner?
    score_delta = (score_a - score_b).abs

    (score_a >= 4 || score_b >= 4) && score_delta >= 2
  end

  def advantage?
    score_delta = (score_a - score_b).abs

    score_a >= 3 && score_b >= 3 && score_delta == 1
  end

  def leader
    return if score_a == score_b

    score_a > score_b ? player_a : player_b
  end

  def winner
    return unless winner?

    leader
  end

  def score
    result    = ""
    tempScore = 0

    if score_a == score_b
      result = {
          0 => "Love-All",
          1 => "Fifteen-All",
          2 => "Thirty-All",
      }.fetch(score_a, "Deuce")
    elsif score_a >= 4 || score_b >= 4
      result = scoreboard.display
    else
      result = scoreboard.display
    end
    result
  end

  private

  def player_a
    players.first
  end

  def player_b
    players.last
  end

  def score_a
    scoreboard.score_count_for(player_a)
  end

  def score_b
    scoreboard.score_count_for(player_b)
  end
end

