class CreateCompletion < ActiveRecord::Migration[5.1]
  def change
    create_table :completions do |t|
      t.references :user, foreign_key: true
      t.references :board, foreign_key: true
      t.time :time
    end
  end
end
