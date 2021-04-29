class ItamSyncService
  DEVICE_TYPES = { computer: 'computer', mobile_device: 'mobile_device' }.freeze
  STORAGE_TYPES = { internal: 'Internal' }.freeze

  def initialize(company)
    @hardware_has_exceeded_limit = false
    @company = company
  end

  def find_existing_record(itam_class, itam_class_params, record_hardware_id, device_type)
    return find_existing_itam_hardware(itam_class_params) if itam_class == 'ItamHardware'

    matching_records = @company.send(itam_class.underscore.pluralize).where(hardware_id: record_hardware_id)

    case itam_class
    when 'ItamNetwork'
      existing_record = matching_records.find_by(macaddr: itam_class_params[:macaddr])
    when 'ItamStorage'
      existing_record = matching_records.find_by(name: itam_class_params[:name])
    when 'ItamPrinter'
      existing_record = matching_records.find_by(name: itam_class_params[:name], model: itam_class_params[:model])
    when 'ItamDrive'
      drive_query = device_type == DEVICE_TYPES[:computer] ? { volumn: itam_class_params[:volumn] } : { type: STORAGE_TYPES[:internal] }
      existing_record = matching_records.find_by(drive_query)
    when 'ItamController'
      existing_record = matching_records.find_by(type: itam_class_params[:type])
    when 'ItamFilevaultStatus'
      existing_record = matching_records.find_by(drive_name: itam_class_params[:drive_name])
    when 'ItamInput'
      existing_record = matching_records.find_by(caption: itam_class_params[:caption])
    when 'ItamMonitor'
      existing_record = matching_records.find_by(serial: itam_class_params[:serial])
    when 'ItamMemory'
      existing_record = matching_records.find_by(caption: itam_class_params[:caption], description: itam_class_params[:description])
    when 'ItamSound', 'ItamVideo', 'ItamPort'
      existing_record = matching_records.find_by(name: itam_class_params[:name])
    when 'ItamSoftware'
      existing_record = matching_records.find_by(name: itam_class_params[:name], version: itam_class_params[:version], software_type: itam_class_params[:software_type], hardware_id: record_hardware_id)
    else
      existing_record = matching_records.first
    end

    existing_record
  end

  def find_existing_itam_hardware(itam_class_params)
    company_hardware_records = @company.itam_hardwares
    company_hardware_records = company_hardware_records.where(uuid: itam_class_params[:uuid]) if @company.merge_it_assets_on_uuid?
    company_hardware_records = company_hardware_records.joins(:itam_bios).where(bios: { ssn: itam_class_params[:ssn] }) if @company.merge_it_assets_on_bios_serial?
    company_hardware_records = company_hardware_records.joins(:itam_networks).where(networks: { macaddr: itam_class_params[:mac_addresses] + ItamNetwork.alternate_mac_addresses(itam_class_params[:mac_addresses]) }) if @company.merge_it_assets_on_mac_address?
    company_hardware_records.first
  end

  def create_and_update_records!(itam_classes, params_container, source_to_ez_id_mapping, device_primary_details, options)
    device_type = options[:device_type]
    source_device_id = options[:source_device_id]
    is_new_it_asset = false

    itam_classes.each do |itam_class|
      itam_class_parameters = params_container[itam_class]

      itam_class_parameters.each do |itam_class_params|
        params_existing_record = if itam_class == 'ItamHardware'
                                   device_primary_details
                                 else
                                   itam_class_params
                                 end

        if (existing_record = find_existing_record(itam_class, params_existing_record, source_to_ez_id_mapping[source_device_id], device_type)).present?
          source_to_ez_id_mapping[source_device_id] = existing_record.id if itam_class == 'ItamHardware'
          existing_record.update!(itam_class_params) unless itam_class == 'ItamSoftware'
        else
          raise EzOfficeExceptions::MaxLimitReachedError, @company.errors.full_messages if itam_class == 'ItamHardware' && (@hardware_has_exceeded_limit || !@company.company_within_limit?(additional_it_assets: 1))

          new_record = @company.send(itam_class.underscore.pluralize).new(itam_class_params)

          if itam_class == 'ItamHardware'
            is_new_it_asset = true
            new_record.save!
            source_to_ez_id_mapping[source_device_id] = new_record.id
            @company.itam_account_infos.create!(access_token: @company.access_token, hardware_id: new_record.id)
          else
            new_record[:hardware_id] = source_to_ez_id_mapping[source_device_id]
            new_record.save!
          end

        end
      end
    end

    is_new_it_asset
  end

  def create_and_update_asset!(asset_params, is_new_it_asset, hardware_id)
    if is_new_it_asset
      return unless @company.company_within_limit?(additional_it_assets: 1)

      asset = @company.api_asset_details.create!(asset_params)
    elsif (asset = @company.api_asset_details.find_by(hardware_id: hardware_id)).present?
      hardware = ItamHardware.find(hardware_id)
      asset_params[:name] = ItamSyncService.asset_name_from_hardware(hardware.name)
      asset.update!(asset_params)
    end

    asset
  end

  def update_itam_records!(itam_hardware, parameterized_data, itam_classes)
    itam_classes.each do |itam_class|
      parameterized_data[itam_class].each do |itam_class_params|
        if (existing_record = find_existing_record_for_update(itam_class, itam_class_params, itam_hardware)).present?
          existing_record.update!(itam_class_params)
        else
          new_record = @company.send(itam_class.underscore.pluralize).new(itam_class_params)
          new_record[:hardware_id] = itam_hardware.id
          new_record.save!
        end
      end
    end
  end

  def find_existing_record_for_update(itam_class, itam_class_params, itam_hardware)
    case itam_class
    when 'ItamHardware'
      itam_hardware
    when 'ItamBios'
      itam_hardware.itam_bios
    when 'ItamDrive'
      itam_drives = itam_hardware.itam_drives
      if itam_hardware.mobile_device?
        itam_drives.find_by(type: STORAGE_TYPES[:internal])
      else
        itam_drives.find_by(volumn: itam_class_params[:volumn])
      end
    when 'ItamNetwork'
      itam_networks = itam_hardware.itam_networks
      itam_networks.find_by(macaddr: itam_class_params[:macaddr])
    when 'ItamPrinter'
      itam_printers = itam_hardware.itam_printers
      itam_printers.find_by(name: itam_class_params[:name], model: itam_class_params[:model])
    when 'ItamStorage'
      itam_storages = itam_hardware.itam_storages
      itam_storages.find_by(name: itam_class_params[:name])
    when 'ItamController'
      itam_controllers = itam_hardware.itam_controllers
      itam_controllers.find_by(type: itam_class_params[:type])
    when 'ItamCpu'
      itam_hardware.itam_cpu
    when 'ItamInput'
      itam_inputs = itam_hardware.itam_inputs
      itam_inputs.find_by(caption: itam_class_params[:caption])
    when 'ItamMemory'
      itam_memories = itam_hardware.itam_memories
      itam_memories.find_by(caption: itam_class_params[:caption], description: itam_class_params[:description])
    when 'ItamMonitor'
      itam_monitors = itam_hardware.itam_monitors
      itam_monitors.find_by(serial: itam_class_params[:serial])
    when 'ItamSound', 'ItamVideo', 'ItamPort'
      itam_objects = itam_hardware.send(itam_class.underscore.pluralize)
      itam_objects.find_by(name: itam_class_params[:name])
    when 'ItamMobileDeviceSecurity'
      itam_hardware.itam_mobile_device_security
    when 'ItamFilevaultStatus'
      itam_filevault_statuses = itam_hardware.itam_filevault_statuses
      itam_filevault_statuses.find_by(drive_name: itam_class_params[:drive_name])
    when 'ItamBitlockerStatus'
      itam_bitlocker_statuses = itam_hardware.itam_bitlocker_statuses
      itam_bitlocker_statuses.find_by(drive: itam_class_params[:drive])
    when 'ItamSecurityCenter'
      itam_security_centers = itam_hardware.itam_security_centers
      itam_security_centers.find_by(product: itam_class_params[:product])
    when 'ItamSoftware'
      itam_hardware.itam_softwares.find_by(name: itam_class_params[:name], version: itam_class_params[:version], software_type: itam_class_params[:software_type])
    else
      itam_class.constantize.find_by(hardware_id: itam_hardware.id)
    end
  end

  def hardware_has_exceeded_limit(value)
    @hardware_has_exceeded_limit ||= value
  end

  def self.asset_name_from_hardware(asset_name)
    if asset_name.length < ApiAssetDetail::NAME_LIMIT[:lower]
      asset_name = "#{asset_name}__"
    elsif asset_name.length > ApiAssetDetail::NAME_LIMIT[:upper]
      asset_name = "#{asset_name.first(ApiAssetDetail::NAME_LIMIT[:upper])}"
    end
    asset_name
  end
end