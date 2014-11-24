# encoding: utf-8
require "test/unit"
require_relative "./tennis_game"

class TestScoreboard < Test::Unit::TestCase
  Game = Struct.new(:players)

  def setup
    game    = Game.new(%w(alice bob))
    @board  = Scoreboard.new(game)
  end

  def test_reset_scores_on_initialize
    assert_equal(0, board.score_count_for(:alice))
    assert_equal(0, board.score_count_for(:bob))
  end

  def test_count_score_by_1
    board.score_for(:alice)

    assert_equal(1, board.score_count_for(:alice))
  end

  def test_count_score_by_2
    board.score_for(:alice, 2)

    assert_equal(2, board.score_count_for(:alice))
  end

  private

  attr_reader :board
end

