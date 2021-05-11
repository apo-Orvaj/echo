class CreateEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :endpoints, id: :uuid do |t|
      t.string :verb
      t.string :path
      t.json :response

      t.timestamps
    end
  end
end
