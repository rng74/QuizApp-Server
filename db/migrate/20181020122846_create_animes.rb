class CreateAnimes < ActiveRecord::Migration[5.2]
  def change
    create_table :animes do |t|
      t.string :title_orig
      t.string :title_ru
      t.string :poster_link
      t.integer :rating
      t.string :type
      t.string :song_name
      t.string :song_link

      t.timestamps
    end
  end
end
