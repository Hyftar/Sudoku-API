class CreateCells < ActiveRecord::Migration[5.1]
  def change
    create_table :cells do |t|
      t.integer :content, null: true
      t.integer :position
      t.boolean :set, default: false
      t.references :board, foreign_key: true
    end
  end
end
