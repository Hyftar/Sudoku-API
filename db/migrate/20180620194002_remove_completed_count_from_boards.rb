class RemoveCompletedCountFromBoards < ActiveRecord::Migration[5.1]
  def change
    remove_column :boards, :completed_count
  end
end
