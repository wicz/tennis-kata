# encoding: utf-8
require "test/unit"
require "test/unit/rr"
require_relative "./tennis_game"

class TestScoreboard < Test::Unit::TestCase
  Game = Struct.new(:players)

  def setup
    @game   = Game.new(%i(alice bob))
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

  def test_display_winner
    stub(game).winner?  { true }
    stub(game).winner   { :alice }

    assert_equal("Win for alice", board.display)
  end

  def test_display_advantage
    stub(game).winner?    { false }
    stub(game).advantage? { true }
    stub(game).leader     { :alice }

    assert_equal("Advantage alice", board.display)
  end

  def test_display_scores
    stub(game).winner?    { false }
    stub(game).advantage? { false }

    board.score_for(:alice)
    assert_equal("Fifteen-Love", board.display)

    board.score_for(:alice)
    board.score_for(:bob, 3)
    assert_equal("Thirty-Forty", board.display)
  end

  private

  attr_reader :board, :game
end

