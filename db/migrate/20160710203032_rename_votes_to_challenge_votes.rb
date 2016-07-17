class RenameVotesToChallengeVotes < ActiveRecord::Migration
  def change
    rename_table :votes, :challenge_votes
  end
end
