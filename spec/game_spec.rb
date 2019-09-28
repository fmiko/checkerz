require File.expand_path('../../lib/checkers', __FILE__)

describe Checkers::Game do
  it "must have two players" do
    game = Checkers::Game.new
    game.players.count.should == 2
  end

  it "should have the first 12 dark slots filled with dark player's pieces" do
    game = Checkers::Game.new
    board = game.board
    board.cells["c1:r1"][:piece].color.should == :dark
    board.cells["c3:r1"][:piece].color.should == :dark
    board.cells["c5:r1"][:piece].color.should == :dark
    board.cells["c7:r1"][:piece].color.should == :dark

    board.cells["c2:r2"][:piece].color.should == :dark
    board.cells["c4:r2"][:piece].color.should == :dark
    board.cells["c6:r2"][:piece].color.should == :dark
    board.cells["c8:r2"][:piece].color.should == :dark

    board.cells["c1:r3"][:piece].color.should == :dark
    board.cells["c3:r3"][:piece].color.should == :dark
    board.cells["c5:r3"][:piece].color.should == :dark
    board.cells["c7:r3"][:piece].color.should == :dark
  end

  it "should have the last 12 dark slots filled with light player's pieces" do
    game = Checkers::Game.new
    board = game.board
    board.cells["c2:r8"][:piece].color.should == :light
    board.cells["c4:r8"][:piece].color.should == :light
    board.cells["c6:r8"][:piece].color.should == :light
    board.cells["c8:r8"][:piece].color.should == :light

    board.cells["c1:r7"][:piece].color.should == :light
    board.cells["c3:r7"][:piece].color.should == :light
    board.cells["c5:r7"][:piece].color.should == :light
    board.cells["c7:r7"][:piece].color.should == :light

    board.cells["c2:r6"][:piece].color.should == :light
    board.cells["c4:r6"][:piece].color.should == :light
    board.cells["c6:r6"][:piece].color.should == :light
    board.cells["c8:r6"][:piece].color.should == :light
  end

  it "should only have pieces on dark slots" do
    game = Checkers::Game.new
    board = game.board
    board.cells.each do |k, cell|
      if cell[:piece]
        cell[:color].should == :dark
      end
    end
  end

  it "should properly validate the dark_player move to an empty cell" do
    game = Checkers::Game.new
    dark_player = game.players[:dark]
    game.is_move_valid?(dark_player, "c1:r3", "c2:r4").should == true
  end

  it "should properly validate the light_player move to an empty cell" do
    game = Checkers::Game.new
    light_player = game.players[:light]
    game.is_move_valid?(light_player, "c2:r6", "c1:r5").should == true
  end

  it "should not be valid to move from an unoccupied cell" do
    game = Checkers::Game.new
    dark_player = game.players[:dark]
    game.is_move_valid?(dark_player, "c1:r2", "c2:r3").should_not == true
  end

  it "should not be valid to move to an occupied cell" do
    game = Checkers::Game.new
    dark_player = game.players[:dark]
    game.is_move_valid?(dark_player, "c1:r1", "c2:r2").should_not == true
  end

  it "should make a move if the move is valid" do
    game = Checkers::Game.new
    dark_player = game.players[:dark]
    game.make_move(dark_player, "c1:r3", "c2:r4").should_not be_nil

    game.board.cells["c2:r4"][:piece].should_not be_nil
    game.board.cells["c1:r3"][:piece].should be_nil
  end

  it "should not allow dark player to move light chips" do
    game = Checkers::Game.new
    dark_player = game.players[:dark]
    game.is_move_valid?(dark_player, "c2:r6", "c1:r5").should_not == true
    game.is_move_valid?(dark_player, "c1:r5", "c2:r6").should_not == true
  end

  it "should be valid for dark player to capture a light piece" do
    game = Checkers::Game.new
    dark_player = game.players[:dark]
    game.board.cells["c2:r4"][:piece] = game.players[:light].pieces[0]
    game.is_move_valid?(dark_player, "c1:r3", "c3:r5").should be_true
  end

  it "should be valid for light player to capture a dark piece to the right" do
    game = Checkers::Game.new
    light_player = game.players[:light]
    game.board.cells["c5:r5"][:piece] = game.players[:dark].pieces[0]
    game.is_move_valid?(light_player, "c4:r6", "c6:r4").should be_true
  end

  it "should be valid for light player to capture a dark piece to the left" do
    game = Checkers::Game.new
    light_player = game.players[:light]
    game.board.cells["c5:r5"][:piece] = game.players[:dark].pieces[0]
    game.is_move_valid?(light_player, "c6:r6", "c4:r4").should be_true
  end

  it "should not be valid for dark player to capture an empty cell" do
    game = Checkers::Game.new
    dark_player = game.players[:dark]
    game.is_move_valid?(dark_player, "c1:r3", "c3:r5").should_not be_true
  end
end