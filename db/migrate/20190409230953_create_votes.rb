class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :restaurant, foreign_key: true
      t.string :split

      t.timestamps
    end
  end
end
