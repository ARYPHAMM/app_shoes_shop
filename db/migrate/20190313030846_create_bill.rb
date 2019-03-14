class CreateBill < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
   		t.integer :user_id
    	t.decimal :total
    	t.timestamps
    end
  end
end