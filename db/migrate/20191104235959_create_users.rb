class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :slack_id
      t.string :locale, default: 'ja', comment: 'user preferred locale'
      t.string :name, comment: 'slack display name'
      t.string :navi_code, comment: 'naviId: JOYSOUNDの16進36桁のユーザ識別子'
      t.timestamps
    end
    add_index :users, :slack_id, unique: true
  end
end
