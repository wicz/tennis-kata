# encoding: utf-8
require "test/unit"
require "test/unit/rr"
require_relative "./tennis_game"

class TestScoreboard < Test::Unit::TestCase
  def setup
    @game   = build_game
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
    stub(game).advantage? { true }
    stub(game).leader     { :alice }

    assert_equal("Advantage alice", board.display)
  end

  def test_display_scores
    board.score_for(:alice)
    assert_equal("Fifteen-Love", board.display)

    board.score_for(:alice)
    board.score_for(:bob, 3)
    assert_equal("Thirty-Forty", board.display)

    board.score_for(:alice)
    assert_equal("Forty-All", board.display)
  end

  def test_display_deuce
    stub(game).deuce? { true }

    assert_equal("Deuce", board.display)
  end

  private

  attr_reader :board, :game

  Game = Struct.new(:players)

  def build_game
    game = Game.new(%i(alice bob))

    stub(game).winner?    { false }
    stub(game).advantage? { false }
    stub(game).deuce?     { false }

    game
  end
end

