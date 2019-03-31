class AddDefaultValuesToWillSplitAndWontSplit < ActiveRecord::Migration[5.2]
  def change
    change_column_default :restaurants, :will_split, 0
    change_column_default :restaurants, :wont_split, 0
  end
end
