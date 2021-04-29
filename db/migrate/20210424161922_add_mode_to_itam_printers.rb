class AddModeToItamPrinters < ActiveRecord::Migration[6.0]
  def change
    add_column :printers, :model, :string
  end
end
