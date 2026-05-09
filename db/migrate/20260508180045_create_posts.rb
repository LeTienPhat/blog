class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body
      t.references :authorable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
