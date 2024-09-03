class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :planner, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
