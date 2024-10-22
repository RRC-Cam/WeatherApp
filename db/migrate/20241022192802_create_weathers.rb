class CreateWeathers < ActiveRecord::Migration[7.2]
  def change
    create_table :weathers do |t|
      t.references :city, null: false, foreign_key: true
      t.decimal :temperature
      t.string :weather_description

      t.timestamps
    end
  end
end
