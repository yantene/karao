class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :slack_id, index: true
      t.integer :last_stamina, null: false, default: 60
      t.integer :score, null: false, default: 0
      t.string :locale, default: 'ja', comment: 'user preferred locale'
      t.string :name, comment: 'slack display name'
      t.timestamps
    end
  end
end
