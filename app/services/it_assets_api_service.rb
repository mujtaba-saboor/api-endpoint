class ItAssetsApiService
  include EzUtilities

  CLASSES_FOR_IT_ASSET = %w[ItamHardware ItamBios ItamDrive ItamNetwork ItamPrinter ItamStorage ItamController ItamCpu ItamInput ItamMemory ItamMonitor ItamPort ItamSound ItamVideo ItamMobileDeviceSecurity ItamBitlockerStatus ItamSecurityCenter ItamSoftware].freeze
  CLASSES_WITH_ARRAY_PARAMS = %i[network_adapters physical_storage disk_and_drives input_devices multimedia ports controllers memory_slots printers monitors security_information installed_software].freeze
  LAST_SYNCED_FLAGS = { 'ge' => '>=', 'le' => '<=', 'eq' => '=' }.freeze
  PER_PAGE_SIZE = 25

  def initialize(company)
    @company = company
  end

  def fetch_it_assets(device_parameters)
    api_service_result = {}
    device_parameters = permitted_device_parameters_for_index(device_parameters)
    return format_json_result(api_service_result) if invalid_parameters_for_index?(device_parameters, api_service_result)

    logger = Logger.new "#{Rails.root}/log/fetch_it_assets_via_api.log"

    itam_hardwares = filter_itam_hardwares(device_parameters)
    api_service_result = { successful: true, api_response: { it_assets: ActiveModel::SerializableResource.new(itam_hardwares, each_serializer: ItamHardwareSerializer), total_pages: (itam_hardwares.total_entries / PER_PAGE_SIZE.to_f).ceil } }

    format_json_result(api_service_result)
  rescue Exception => e
    Airbrake.notify(e, { error_class: 'FILTER IT ASSET API', parameters: { itam_company_id: @company.itam_company_id, device_info: device_parameters } })
    logger.info "\nError Occured :( \nITAM Company ID: #{@company.id}|\nMessage: #{e.message}|\nBacktrace: #{e.backtrace.join('\n')}|\nDevice_Parameters: #{device_parameters}\n"
    format_json_result({ error_message: e.message })
  end

  def create_it_asset(device_parameters)
    api_service_result = {}
    device_parameters = permitted_device_parameters_for_create(device_parameters)
    return format_json_result(api_service_result) if invalid_parameters?(device_parameters, api_service_result) || mandatory_fields_absent?(device_parameters, api_service_result)

    logger               = Logger.new "#{Rails.root}/log/create_it_asset_via_api.log"
    itam_sync_service    = ItamSyncService.new(@company)
    api_to_ez_id_mapping = {}

    ActiveRecord::Base.transaction do
      is_new_it_asset = create_and_update_itam_record!(itam_sync_service, device_parameters, extract_device_primary_details(device_parameters), api_to_ez_id_mapping)
      api_service_result = create_and_update_asset!(itam_sync_service, device_parameters, is_new_it_asset, api_to_ez_id_mapping[:ez_api_id])
    end

    format_json_result(api_service_result)
  rescue Exception => e
    Airbrake.notify(e, { error_class: 'CREATE IT ASSET API', parameters: { itam_company_id: @company.itam_company_id, device_info: device_parameters } })
    logger.info "\nError Occured :( \nITAM Company ID: #{@company.id}|\nMessage: #{e.message}|\nBacktrace: #{e.backtrace.join('\n')}|\nDevice_Parameters: #{device_parameters}\n"
    format_json_result({ error_message: e.message })
  end

  def update_it_asset(itam_hardware, device_parameters)
    api_service_result = {}
    logger             = Logger.new "#{Rails.root}/log/update_it_asset_via_api.log"
    itam_sync_service  = ItamSyncService.new(@company)
    device_parameters  = permitted_device_parameters_for_update(device_parameters)

    ActiveRecord::Base.transaction do
      update_itam_records!(itam_hardware, itam_sync_service, device_parameters)
      api_service_result = update_asset!(itam_hardware.api_asset_detail, itam_sync_service, device_parameters)
    end

    format_json_result(api_service_result)
  rescue Exception => e
    Airbrake.notify(e, { error_class: 'UPDATE IT ASSET API', parameters: { itam_company_id: @company.itam_company_id, asset_id: itam_hardware.id, device_info: device_parameters } })
    logger.info "\nError Occured :( \nITAM Company ID: #{@company.id}|\nMessage: #{e.message}|\nBacktrace: #{e.backtrace.join('\n')}|\nAsset ID: #{itam_hardware.id}|\nDevice_Parameters: #{device_parameters}\n"
    format_json_result({ error_message: e.message })
  end

  def mandatory_fields_absent?(device_parameters, api_service_result)
    return false if device_parameters.dig(:it_asset, :name).present? && device_parameters.dig(:it_asset, :group_id).present? && device_parameters.dig(:it_asset, :purchased_on).present? && device_parameters.dig(:computer_system_and_bios, :serial_number).present? && device_parameters[:network_adapters]&.detect { |network_adapter| network_adapter[:mac_address].present? }.present?

    missing_mandatory_fields = []
    missing_mandatory_fields << 'Name' if device_parameters.dig(:it_asset, :name).blank?
    missing_mandatory_fields << 'Group ID' if device_parameters.dig(:it_asset, :group_id).blank?
    missing_mandatory_fields << 'Purchased On' if device_parameters.dig(:it_asset, :purchased_on).blank?
    missing_mandatory_fields << 'BIOS Serial Number' if device_parameters.dig(:computer_system_and_bios, :serial_number).blank?
    missing_mandatory_fields << 'Network Mac Address' if device_parameters[:network_adapters]&.detect { |network_adapter| network_adapter[:mac_address].present? }.blank?

    api_service_result.merge!(error_message: I18n.t(:mandatory_field_error, missing_fields: missing_mandatory_fields.join(', ')), status_code: :unprocessable_entity)
    true
  end

  def invalid_parameters_for_index?(device_parameters, api_service_result)
    return false if device_parameters[:last_synced_with_main_instance_flag].blank? && device_parameters[:last_synced_with_main_instance_value].blank?

    invalid_parameters = []

    invalid_parameters << 'last_synced_with_main_instance_flag' unless LAST_SYNCED_FLAGS.key?(device_parameters[:last_synced_with_main_instance_flag])

    begin
      Time.zone.parse(device_parameters[:last_synced_with_main_instance_value])
    rescue
      invalid_parameters << 'last_synced_with_main_instance_value'
    end

    return false if invalid_parameters.blank?

    api_service_result.merge!(error_message: I18n.t(:invalid_parameters_error, invalid_parameters: invalid_parameters.join(', ')), status_code: :unprocessable_entity)
    true
  end

  def invalid_parameters?(device_parameters, api_service_result)
    invalid_parameters = []
    CLASSES_WITH_ARRAY_PARAMS.each do |class_with_array_params|
      next if (class_params = device_parameters[class_with_array_params]).blank?

      invalid_parameters << class_with_array_params unless class_params.is_a?(Array)
    end

    return false if invalid_parameters.blank?

    api_service_result.merge!(error_message: I18n.t(:invalid_parameters_error, invalid_parameters: invalid_parameters.join(', ')), status_code: :unprocessable_entity)
    true
  end

  def filter_itam_hardwares(device_parameters)
    query_arguments = ''

    unless device_parameters[:synced_with_assetsonar_main_instance].nil?
      null_condition = to_bool(device_parameters[:synced_with_assetsonar_main_instance]) ? 'IS NOT' : 'IS'
      query_arguments += "last_synced_with_main_instance #{null_condition} NULL"
    end

    if device_parameters[:last_synced_with_main_instance_flag].present? && device_parameters[:last_synced_with_main_instance_value].present?
      flag_value = LAST_SYNCED_FLAGS[device_parameters[:last_synced_with_main_instance_flag]] || '='
      last_synced_with_main_instance_value = Time.zone.parse(device_parameters[:last_synced_with_main_instance_value])
      sql_array = ["last_synced_with_main_instance #{flag_value} :last_synced_with_main_instance_value", { last_synced_with_main_instance_value: last_synced_with_main_instance_value }]

      query_arguments = "#{query_arguments} AND " if query_arguments.present?
      query_arguments += ActiveRecord::Base.send(:sanitize_sql_array, sql_array)
    end

    @company.itam_hardwares.where(query_arguments).paginate(page: device_parameters[:page], per_page: PER_PAGE_SIZE)
  end

  def create_and_update_itam_record!(itam_sync_service, device_parameters, device_primary_details, api_to_ez_id_mapping)
    parameterized_data = parameterize_data_for_create(device_parameters)
    itam_sync_service.create_and_update_records!(CLASSES_FOR_IT_ASSET, parameterized_data, api_to_ez_id_mapping, device_primary_details, source_device_id: :ez_api_id, device_type: @device_type)
  end

  def create_and_update_asset!(itam_sync_service, device_parameters, is_new_it_asset, device_hardware_id)
    asset_params = extract_asset_params_for_create(device_parameters, device_hardware_id)
    asset = itam_sync_service.create_and_update_asset!(asset_params, is_new_it_asset, device_hardware_id)

    if asset.persisted?
      success_message = is_new_it_asset ? I18n.t(:asset_created_notice) : I18n.t(:it_asset_updated_notice)
      { successful: true, api_response: { success_message: success_message, device_hardware_id: asset.hardware_id } }
    else
      error_message = asset.errors.present? ? asset.errors.full_messages.join(',') : I18n.t(:failed_to_create_it_asset)
      { successful: false, error_message: error_message }
    end
  end

  def update_itam_records!(itam_hardware, itam_sync_service, device_parameters)
    parameterized_data = parameterize_data_for_update(device_parameters)
    itam_sync_service.update_itam_records!(itam_hardware, parameterized_data, CLASSES_FOR_IT_ASSET)
  end

  def update_asset!(asset, itam_sync_service, device_parameters)
    asset_params = extract_asset_params_for_update(asset, device_parameters)
    asset.update!(asset_params)

    if asset.valid?
      { successful: true, api_response: { success_message: I18n.t(:it_asset_updated_notice), device_hardware_id: asset.hardware_id } }
    else
      error_message = asset.errors.present? ? asset.errors.full_messages.join(',') : I18n.t(:failed_to_update_it_asset)
      { successful: false, error_message: error_message }
    end
  end

  def parameterize_data_for_create(device_parameters)
    parameterized_data = {}

    CLASSES_FOR_IT_ASSET.each do |class_name|
      parameterized_data[class_name] = send("create_params_for_#{class_name.downcase}", device_parameters)
    end
    parameterized_data
  end

  def parameterize_data_for_update(device_parameters)
    parameterized_data = {}

    CLASSES_FOR_IT_ASSET.each do |class_name|
      parameterized_data[class_name] = send("update_params_for_#{class_name.downcase}", device_parameters)
    end
    parameterized_data
  end

  def extract_device_primary_details(device_parameters)
    { uuid: device_parameters.dig(:hardware_details, :uuid), ssn: device_parameters.dig(:computer_system_and_bios, :serial_number), mac_addresses: ((device_parameters[:network_adapters] || []).map { |network_adapter| network_adapter[:mac_address] }).compact }
  end

  def create_params_for_itamhardware(device_parameters)
    hardware_details = device_parameters[:hardware_details] || {}
    memory_and_cpu = device_parameters[:memory_and_cpu] || {}

    @device_type = to_bool(hardware_details[:is_mobile_device]) ? ItamSyncService::DEVICE_TYPES[:mobile_device] : ItamSyncService::DEVICE_TYPES[:computer]

    [{ description: hardware_details[:description],
       device_type: @device_type,
       winprodkey: hardware_details[:os_product_key],
       processorn: memory_and_cpu[:cpu_numbers],
       processort: memory_and_cpu[:cpu],
       processors: memory_and_cpu[:cpu_speed],
       osversion: hardware_details[:operating_system_version],
       workgroup: hardware_details[:workgroup],
       winprodid: hardware_details[:os_product_id],
       lastcome: Time.zone.now,
       memory: memory_and_cpu[:physical_memory],
       ipaddr: hardware_details[:ip_address],
       osname: hardware_details[:operating_system],
       userid: hardware_details[:last_logged_in_user],
       ipsrc: hardware_details[:external_ip_address],
       uuid: hardware_details[:uuid],
       name: ItamSyncService.asset_name_from_hardware(device_parameters.dig(:it_asset, :name)),
       swap: memory_and_cpu[:swap] }]
  end

  def create_params_for_itambios(device_parameters)
    computer_system_and_bios = device_parameters[:computer_system_and_bios] || {}

    [{ smanufacturer: computer_system_and_bios[:bios_manufacturer],
       bversion: computer_system_and_bios[:bios_version],
       smodel: computer_system_and_bios[:bios_model],
       bdate: computer_system_and_bios[:bios_date],
       ssn: computer_system_and_bios[:serial_number] }]
  end

  def create_params_for_itamdrive(device_parameters)
    device_drives = []
    disk_and_drives = device_parameters[:disk_and_drives] || {}

    disk_and_drives.each do |disk_and_drive|
      device_drives << {
        letter: disk_and_drive[:letter],
        volumn: disk_and_drive[:volume_name],
        total: disk_and_drive[:total_space],
        type: disk_and_drive[:type],
        free: disk_and_drive[:free_space]
      }
    end
    device_drives
  end

  def create_params_for_itamnetwork(device_parameters)
    device_network_adapters = []
    network_adapters = device_parameters[:network_adapters] || {}

    network_adapters.each do |network_adapter|
      device_network_adapters << {
        description: network_adapter[:name],
        ipgateway: network_adapter[:dhcp],
        ipaddress: network_adapter[:ip_address],
        macaddr: network_adapter[:mac_address],
        ipdhcp: network_adapter[:dhcp_server]
      }
    end
    device_network_adapters
  end

  def create_params_for_itamprinter(device_parameters)
    device_printers = []
    printers = device_parameters[:printers] || {}

    printers.each do |printer|
      device_printers << {
        driver: printer[:driver],
        name: printer[:name],
        port: printer[:port]
      }
    end
    device_printers
  end

  def create_params_for_itamstorage(device_parameters)
    device_storages = []
    physical_storages = device_parameters[:physical_storage] || {}

    physical_storages.each do |physical_storage|
      device_storages << {
        manufacturer: physical_storage[:manufacturer],
        description: physical_storage[:description],
        disksize: physical_storage[:size],
        firmware: physical_storage[:firmware],
        model: physical_storage[:model],
        type: physical_storage[:type],
        name: physical_storage[:name]
      }
    end
    device_storages
  end

  def create_params_for_itamcontroller(device_parameters)
    device_controllers = []
    controllers = device_parameters[:controllers] || {}

    controllers.each do |controller|
      device_controllers << {
        name: controller[:name],
        type: controller[:type]
      }
    end
    device_controllers
  end

  def create_params_for_itamcpu(device_parameters)
    memory_and_cpu = device_parameters[:memory_and_cpu] || {}

    [{ logical_cpus: memory_and_cpu[:logical_cpus],
       cores: memory_and_cpu[:number_of_cores] }]
  end

  def create_params_for_itaminput(device_parameters)
    device_inputs = []
    input_devices = device_parameters[:input_devices] || {}

    input_devices.each do |input_device|
      device_inputs << {
        caption: input_device[:name],
        type: input_device[:type]
      }
    end
    device_inputs
  end

  def create_params_for_itammemory(device_parameters)
    device_memory_slots = []
    memory_slots = device_parameters[:memory_slots] || {}

    memory_slots.each do |memory_slot|
      device_memory_slots << {
        description: memory_slot[:description],
        numslots: memory_slot[:number_of_slots],
        capacity: memory_slot[:capacity],
        caption: memory_slot[:name],
        purpose: memory_slot[:purpose],
        speed: memory_slot[:speed],
        type: memory_slot[:type]
      }
    end
    device_memory_slots
  end

  def create_params_for_itammonitor(device_parameters)
    device_monitors = []
    monitors = device_parameters[:monitors] || {}

    monitors.each do |monitor|
      device_monitors << {
        manufacturer: monitor[:manufacturer],
        description: monitor[:manufactured],
        caption: monitor[:name],
        serial: monitor[:serial_number],
        type: monitor[:type]
      }
    end
    device_monitors
  end

  def create_params_for_itamport(device_parameters)
    device_ports = []
    ports = device_parameters[:ports] || {}

    ports.each do |port|
      device_ports << {
        name: port[:name],
        type: port[:type]
      }
    end
    device_ports
  end

  def create_params_for_itamsound(device_parameters)
    device_audios = []
    multimedia = device_parameters[:multimedia] || {}

    multimedia.each do |media|
      media = media.slice(:audio)
      next if media.blank?

      device_audios << {
        name: media[:audio]
      }
    end
    device_audios
  end

  def create_params_for_itamvideo(device_parameters)
    device_videos = []
    multimedia = device_parameters[:multimedia] || {}

    multimedia.each do |media|
      media = media.slice(:video_card, :chipset)
      next if media.blank?

      device_videos << {
        name: media[:video_card],
        chipset: media[:chipset]
      }
    end
    device_videos
  end

  def create_params_for_itammobiledevicesecurity(device_parameters)
    mobile_security_information = device_parameters[:mobile_security_information] || {}
    
    [{ activation_lock_bypass_code: mobile_security_information[:activation_lock_bypass_code],
       compliance_state: mobile_security_information[:compliance_state],
       jailbroken: to_bool(mobile_security_information[:jailbroken]),
       supervised: to_bool(mobile_security_information[:supervised]),
       encrypted: to_bool(mobile_security_information[:encrypted]) }]
  end

  def create_params_for_itambitlockerstatus(device_parameters)
    device_bitlockerstatuses = []
    disk_and_drives = device_parameters[:disk_and_drives] || {}

    disk_and_drives.each do |disk_and_drive|
      conversionstatus = to_bool(disk_and_drive[:conversionstatus]) ? ItamBitlockerStatus::ENABLED : ItamBitlockerStatus::DISABLED
      protectionstatus = to_bool(disk_and_drive[:protectionstatus]) ? ItamBitlockerStatus::ENABLED : ItamBitlockerStatus::DISABLED

      device_bitlockerstatuses << {
        conversionstatus: conversionstatus,
        protectionstatus: protectionstatus,
        drive: disk_and_drive[:letter]
      }
    end
    device_bitlockerstatuses
  end

  def create_params_for_itamsecuritycenter(device_parameters)
    device_itam_security_centers = []
    security_informations = device_parameters[:security_information] || {}

    security_informations.each do |security_information|
      device_itam_security_centers << {
        uptodate: to_bool(security_information[:up_to_date]),
        category: security_information[:category],
        product: security_information[:product],
        enabled: to_bool(security_information[:enabled])
      }
    end
    device_itam_security_centers
  end

  def create_params_for_itamsoftware(device_parameters)
    device_apps = []
    installed_software = device_parameters[:installed_software] || {}
    installed_software.each do |software|
      device_apps << {
        software_type: ItamSoftware::API,
        publisher: software[:publisher],
        version: software[:version],
        name: software[:name]
      }
    end
    device_apps
  end

  def extract_asset_params_for_create(device_parameters, hardware_id)
    it_asset = device_parameters[:it_asset] || {}

    { last_source_sync_date: it_asset[:last_source_sync_date],
      sub_group_id: it_asset[:sub_group_id],
      purchased_on: it_asset[:purchased_on],
      hardware_id: hardware_id,
      location_id: it_asset[:location_id],
      identifier: it_asset[:identifier],
      group_id: it_asset[:group_id],
      name: ItamSyncService.asset_name_from_hardware(it_asset[:name]) }
  end

  def update_params_for_itamhardware(device_parameters)
    hardware_details = device_parameters[:hardware_details] || {}
    memory_and_cpu = device_parameters[:memory_and_cpu] || {}
    it_asset = device_parameters[:it_asset] || {}

    hardware_details_mappings = { operating_system_version: :osversion,
                                  last_logged_in_user: :userid,
                                  external_ip_address: :ipsrc,
                                  operating_system: :osname,
                                  os_product_key: :winprodkey,
                                  os_product_id: :winprodid,
                                  description: :description,
                                  ip_address: :ipaddr,
                                  workgroup: :workgroup,
                                  uuid: :uuid }

    memory_and_cpu_mappings = { physical_memory: :memory,
                                cpu_numbers: :processorn,
                                cpu_speed: :processors,
                                swap: :swap,
                                cpu: :processort }

    it_asset_mappings = { name: :name }
                          

    hardware_details_params = hardware_details.transform_keys { |key| hardware_details_mappings[key.to_sym] }
    hardware_details_params[:lastcome] = Time.zone.now
    memory_and_cpu_params = memory_and_cpu.slice(*memory_and_cpu_mappings.keys).transform_keys { |key| memory_and_cpu_mappings[key.to_sym] }
    it_asset_params = it_asset.slice(*it_asset_mappings.keys).transform_keys { |key| it_asset_mappings[key.to_sym] }

    [hardware_details_params.merge(memory_and_cpu_params).merge(it_asset_params)]
  end

  def update_params_for_itambios(device_parameters)
    computer_system_and_bios = device_parameters[:computer_system_and_bios] || {}

    computer_system_and_bios_mappings = { bios_manufacturer: :smanufacturer,
                                          serial_number: :ssn,
                                          bios_version: :bversion,
                                          bios_model: :smodel,
                                          bios_date: :bdate }

    [computer_system_and_bios.transform_keys { |key| computer_system_and_bios_mappings[key.to_sym] }]
  end

  def update_params_for_itamdrive(device_parameters)
    device_drives = []
    disk_and_drives = device_parameters[:disk_and_drives] || {}

    disk_and_drives_mappings = { volume_name: :volumn,
                                 total_space: :total,
                                 free_space: :free,
                                 letter: :letter,
                                 type: :type }

    disk_and_drives.each do |disk_and_drive|
      device_drives << disk_and_drive.slice(*disk_and_drives_mappings.keys).transform_keys { |key| disk_and_drives_mappings[key.to_sym] }
    end
    device_drives
  end

  def update_params_for_itamnetwork(device_parameters)
    device_network_adapters = []
    network_adapters = device_parameters[:network_adapters] || {}

    network_adapters_mappings = { ip_address: :ipaddress,
                                  mac_address: :macaddr,
                                  dhcp_server: :ipdhcp,
                                  name: :description,
                                  dhcp: :ipgateway }

    network_adapters.each do |network_adapter|
      device_network_adapters << network_adapter.transform_keys { |key| network_adapters_mappings[key.to_sym] }
    end
    device_network_adapters
  end

  def update_params_for_itamprinter(device_parameters)
    device_printers = []
    printers = device_parameters[:printers] || {}

    printers.each do |printer|
      device_printers << printer
    end
    device_printers
  end

  def update_params_for_itamstorage(device_parameters)
    device_storages = []
    physical_storages = device_parameters[:physical_storage] || {}

    physical_storages_mappings = { manufacturer: :manufacturer,
                                   description: :description,
                                   firmware: :firmware,
                                   model: :model,
                                   size: :disksize,
                                   type: :type,
                                   name: :name }

    physical_storages.each do |physical_storage|
      device_storages << physical_storage.transform_keys { |key| physical_storages_mappings[key.to_sym] }
    end
    device_storages
  end

  def update_params_for_itamcontroller(device_parameters)
    device_controllers = []
    controllers = device_parameters[:controllers] || {}

    controllers.each do |controller|
      device_controllers << controller
    end
    device_controllers
  end

  def update_params_for_itamcpu(device_parameters)
    memory_and_cpu = device_parameters[:memory_and_cpu] || {}

    memory_and_cpu_mappings = { number_of_cores: :cores,
                                logical_cpus: :logical_cpus }

    [memory_and_cpu.slice(*memory_and_cpu_mappings.keys).transform_keys { |key| memory_and_cpu_mappings[key.to_sym] }]
  end

  def update_params_for_itaminput(device_parameters)
    device_inputs = []
    input_devices = device_parameters[:input_devices] || {}

    input_devices_mappings = { name: :caption,
                               type: :type }

    input_devices.each do |input_device|
      device_inputs << input_device.transform_keys { |key| input_devices_mappings[key.to_sym] }
    end
    device_inputs
  end

  def update_params_for_itammemory(device_parameters)
    device_memory_slots = []
    memory_slots = device_parameters[:memory_slots] || {}

    memory_slots_mappings = { number_of_slots: :numslots,
                              description: :description,
                              capacity: :capacity,
                              purpose: :purpose,
                              name: :caption,
                              speed: :speed,
                              type: :type }

    memory_slots.each do |memory_slot|
      device_memory_slots << memory_slot.transform_keys { |key| memory_slots_mappings[key.to_sym] }
    end
    device_memory_slots
  end

  def update_params_for_itammonitor(device_parameters)
    device_monitors = []
    monitors = device_parameters[:monitors] || {}

    monitors_mappings = { serial_number: :serial,
                          manufacturer: :manufacturer,
                          manufactured: :description,
                          name: :caption,
                          type: :type }

    monitors.each do |monitor|
      device_monitors << monitor.transform_keys { |key| monitors_mappings[key.to_sym] }
    end
    device_monitors
  end

  def update_params_for_itamport(device_parameters)
    device_ports = []
    ports = device_parameters[:ports] || {}

    ports.each do |port|
      device_ports << port
    end
    device_ports
  end

  def update_params_for_itamsound(device_parameters)
    device_audios = []
    sounds = device_parameters[:multimedia] || {}

    sounds_mappings = { audio: :name }

    sounds.each do |sound|
      sound = sound.slice(*sounds_mappings.keys).transform_keys { |key| sounds_mappings[key.to_sym] }
      device_audios << sound if sound.present?
    end
    device_audios
  end

  def update_params_for_itamvideo(device_parameters)
    device_videos = []
    videos = device_parameters[:multimedia] || {}

    videos_mappings = { video_card: :name,
                        chipset: :chipset }

    videos.each do |video|
      video = video.slice(*videos_mappings.keys).transform_keys { |key| videos_mappings[key.to_sym] }
      device_videos << video if video.present?
    end
    device_videos
  end

  def update_params_for_itammobiledevicesecurity(device_parameters)
    mobile_security_information = device_parameters[:mobile_security_information] || {}

    [mobile_security_information.each { |key, value| mobile_security_information[key] = to_bool(value) if %i[jailbroken supervised encrypted].include?(key.to_sym) }]
  end

  def update_params_for_itambitlockerstatus(device_parameters)
    device_bitlockerstatuses = []
    disk_and_drives = device_parameters[:disk_and_drives] || {}

    disk_and_drives_mappings = { conversionstatus: :conversionstatus,
                                 protectionstatus: :protectionstatus,
                                 letter: :drive }

    disk_and_drives.each do |disk_and_drive|
      device_bitlockerstatus = disk_and_drive.slice(*disk_and_drives_mappings.keys).transform_keys { |key| disk_and_drives_mappings[key.to_sym] }
      device_bitlockerstatus.each { |key, value| device_bitlockerstatus[key] = to_bool(value) ? ItamBitlockerStatus::ENABLED : ItamBitlockerStatus::DISABLED if %i[conversionstatus protectionstatus].include?(key.to_sym) }
      device_bitlockerstatuses << device_bitlockerstatus
    end
    device_bitlockerstatuses
  end

  def update_params_for_itamsecuritycenter(device_parameters)
    device_itam_security_centers = []
    security_informations = device_parameters[:security_information] || {}

    security_information_mappigns = { up_to_date: :uptodate,
                                      category: :category,
                                      product: :product,
                                      enabled: :enabled }

    security_informations.each do |security_information|
      security_information = security_information.transform_keys { |key| security_information_mappigns[key.to_sym] }
      security_information.each { |key, value| security_information[key] = to_bool(value) if %i[uptodate enabled].include?(key.to_sym) }
      device_itam_security_centers << security_information
    end
    device_itam_security_centers
  end

  def update_params_for_itamsoftware(device_parameters)
    device_apps = []
    installed_software = device_parameters[:installed_software] || {}

    installed_software.each do |software|
      device_apps << software.merge(software_type: ItamSoftware::API)
    end
    device_apps
  end

  def extract_asset_params_for_update(asset, device_parameters)
    asset_params = device_parameters[:it_asset] || {}
    asset_params[:name] = ItamSyncService.asset_name_from_hardware(asset.itam_hardware.name)
    asset_params
  end

  def format_json_result(api_service_result)
    if api_service_result[:successful]
      { api_response: api_service_result[:api_response], status_code: :ok }
    else
      { api_response: { error_message: api_service_result[:error_message] }, status_code: api_service_result[:status_code] || :internal_server_error }
    end
  end

  def permitted_device_parameters_for_index(device_parameters)
    device_parameters.permit(
      :page,
      :synced_with_assetsonar_main_instance,
      :last_synced_with_main_instance_flag,
      :last_synced_with_main_instance_value
    ).to_unsafe_h
  end

  def permitted_device_parameters_for_create(device_parameters)
    device_parameters.permit({
      hardware_details: %i[
        description
        uuid
        ip_address
        external_ip_address
        operating_system
        operating_system_version
        is_mobile_device
        last_logged_in_user
        workgroup
        os_product_id
        os_product_key
      ]
    }.merge(shared_parameters_between_create_and_update)).to_unsafe_h
  end

  def permitted_device_parameters_for_update(device_parameters)
    device_parameters.permit({
      hardware_details: %i[
        description
        uuid
        ip_address
        external_ip_address
        operating_system
        operating_system_version
        last_logged_in_user
        workgroup
        os_product_id
        os_product_key
      ]
    }.merge(shared_parameters_between_create_and_update)).to_unsafe_h
  end

  def shared_parameters_between_create_and_update
    {
      it_asset: [
        :name,
        :group_id,
        :sub_group_id,
        :purchased_on,
        :last_source_sync_date,
        :location_id,
        :image_url,
        :identifier,
        { document_urls: [] }
      ],
      cust_attr: {},
      computer_system_and_bios: %i[
        serial_number
        bios_version
        bios_date
        bios_manufacturer
        bios_model
      ],
      memory_and_cpu: %i[
        physical_memory
        cpu
        cpu_speed
        cpu_numbers
        logical_cpus
        number_of_cores
        swap
      ],
      network_adapters: %i[
        ip_address
        mac_address
        name
        dhcp
        dhcp_server
      ],
      physical_storage: %i[
        name
        description
        manufacturer
        model
        firmware
        type
        size
      ],
      disk_and_drives: %i[
        volume_name
        letter
        type
        total_space
        free_space
        conversionstatus
        protectionstatus
      ],
      input_devices: %i[
        type
        name
      ],
      multimedia: %i[
        audio
        video_card
        chipset
      ],
      ports: %i[
        type
        name
      ],
      controllers: %i[
        type
        name
      ],
      memory_slots: %i[
        name
        number_of_slots
        description
        capacity
        purpose
        type
        speed
      ],
      printers: %i[
        name
        driver
        port
      ],
      monitors: %i[
        name
        type
        serial_number
        manufacturer
        manufactured
      ],
      security_information: %i[
        category
        product
        enabled
        up_to_date
      ],
      mobile_security_information: %i[
        jailbroken
        encrypted
        supervised
        activation_lock_bypass_code
        compliance_state
      ],
      installed_software: %i[
        name
        version
        publisher
      ]
    }
  end

end
