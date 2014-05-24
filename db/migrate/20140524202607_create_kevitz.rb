class CreateKevitz < ActiveRecord::Migration
  def change
    create_table :collages do |t|
      t.attachment :image
    end
  end
end
