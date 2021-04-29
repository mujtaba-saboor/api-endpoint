class AddLastSyncedWithMainInstanceToHardware < ActiveRecord::Migration[6.0]
  def change
    add_column :hardware, :last_synced_with_main_instance, :datetime
  end
end
