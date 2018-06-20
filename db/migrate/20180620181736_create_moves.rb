class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.references :board, foreign_key: true
      t.references :user, foreign_key: true
      t.references :cell, foreign_key: true
      t.integer :content

      t.timestamps
    end
  end
end
