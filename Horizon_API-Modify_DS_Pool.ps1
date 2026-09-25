# Bypass cert validation (PS 5.1 & 7 compatible fallback)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$BaseUrl = "https://[connection server]/rest"

# Construct credentials body for initial login
$Body = @{
    "username" = "api_admin"
    "password" = "SecretPassword"
    "domain"   = "YOURDOMAIN"} | ConvertTo-Json
    
# Request the login token
$LoginResponse = Invoke-RestMethod -Uri "$BaseUrl/login" -Method Post -Body $Body -ContentType "application/json"

# Capture the Bearer token (Horizon returns access_token)
$BearerToken = $LoginResponse.access_token

# Define standard headers for future calls
$Headers = @{
    "Authorization" = "Bearer $BearerToken"
    "Accept"        = "application/json"}

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^The above is from Horizon_API-Connection.ps1 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

$AccessGroups = Invoke-RestMethod -Uri "$BaseUrl/config/v1/local-access-groups" -Method Get -Headers $Headers 

$AccessGroups.id

$DSpoolID = $DSPoolList.id

#update the pool
# The following is a schema from Swagger and should be modified for your environment. 
#create payload
$UpdateDSPoolPayload = @{
  "access_group_id" = $AccessGroups.id
  "allow_multiple_user_assignments" = true
  "allow_rds_pool_multi_session_per_user" = false
  "automatic_user_assignment" = false
  "category_folder_name" = "dir1"
  "cloud_assigned" = false
  "cloud_brokered" = false
  "cloud_managed" = false
  "cs_restriction_tags" = @(
    "CS1_TAG1"
  )
  "customization_settings" = @{
    "ad_container_rdn" = "CN=Computers"
    "cloneprep_customization_settings" = @{
      "priming_computer_account" = "priming"
    }
    "customization_type" = "CLONE_PREP"
    "do_not_power_on_vms_after_creation" = false
    "instant_clone_domain_account_id" = "6f85b3a5-e7d0-4ad6-a1e3-37168dd1ed51"
    "reuse_pre_existing_accounts" = false
    "sysprep_customization_spec_id" = "a219420d-4799-4517-8f78-39c74c7c4efc"
  }
  "description" = "Desktop Pool Description"
  "display_assigned_machine_name" = false
  "display_machine_alias" = true
  "display_name" = "pool"
  "display_protocol_settings" = @{
    "allow_users_to_choose_protocol" = true
    "default_display_protocol" = "PCOIP"
    "max_number_of_monitors" = 2
    "max_resolution_of_any_one_monitor" = "WUXGA"
    "renderer3d" = "DISABLED"
    "session_collaboration_enabled" = false
    "vram_size_mb" = 64
  }
  "enable_client_restrictions" = false
  "enable_provisioning" = true
  "enabled" = true
  "nics" = @(
    @{
      "network_interface_card_id" = "c9896e51-48a2-4d82-ae9e-a0246981b473"
      "network_label_assignment_specs" = @(
        @{
          "enabled" = true
          "max_label" = 1
          "max_label_type" = "LIMITED"
          "network_label_name" = "vm-network"
        }
      )
    }
  )
  "pattern_naming_settings" = @{
    "max_number_of_machines" = 100
    "min_number_of_machines" = 10
    "naming_pattern" = "vm-{n}-sales"
    "number_of_spare_machines" = 10
    "provisioning_time" = "ON_DEMAND"
  }
  "provisioning_settings" = @{
    "host_or_cluster_id" = "domain-s425"
    "im_stream_id" = "6f85b3a5-e7d0-4ad6-a1e3-37168dd1ed51"
    "im_tag_id" = "6f85b3a5-e7d0-4ad6-a1e3-37168dd1ed51"
    "resource_pool_id" = "resgroup-1"
    "vm_template_id" = "vm-1"
  }
  "session_settings" = @{
    "allow_multiple_sessions_per_user" = false
    "allow_users_to_reset_machines" = false
    "delete_or_refresh_machine_after_logoff" = "NEVER"
    "disconnected_session_timeout_minutes" = 5
    "disconnected_session_timeout_policy" = "NEVER"
    "empty_session_timeout_minutes" = 5
    "empty_session_timeout_policy" = "AFTER"
    "logoff_after_timeout" = false
    "power_policy" = "ALWAYS_POWERED_ON"
    "pre_launch_session_timeout_minutes" = 10
    "pre_launch_session_timeout_policy" = "AFTER"
    "refresh_os_disk_after_logoff" = "NEVER"
    "refresh_period_days_for_replica_os_disk" = 20
    "refresh_threshold_percentage_for_replica_os_disk" = 30
    "session_timeout_policy" = "DEFAULT"
  }
  "session_type" = "DESKTOP"
  "shortcut_locations_v2" = @(
    "DESKTOP"
  )
  "specific_naming_settings" = @{
    "num_unassigned_machines_kept_powered_on" = 1
    "specified_names" = @(
      @{
        "name" = "machine1"
        "user_id" = "S-1-1-1-3965912346-1012345398-3123456564-123"
      }
    )
    "start_machines_in_maintenance_mode" = false
  }
  "stop_provisioning_on_error" = true
  "storage_settings" = @{
    "datastores" = @(
      @{
        "datastore_id" = "datastore-1"
        "sdrs_cluster" = false
      }
    )
    "reclaim_vm_disk_space" = false
    "reclamation_threshold_mb" = 1024
    "replica_disk_datastore_id" = "datastore-1"
    "use_separate_datastores_replica_and_os_disks" = false
    "use_vsan" = false
  }
  "transparent_page_sharing_scope" = "VM"
  "view_storage_accelerator_settings" = @{
    "blackout_times" = @(
      @{
        "days" = @(
          "MONDAY"
          "TUESDAY"
        )
        "end_time" = "22:00"
        "start_time" = "10:00"
      }
    )
    "regenerate_view_storage_accelerator_days" = 7
    "use_view_storage_accelerator" = false
  }
}

#convert payload
$ConvertedDSPool = $UpdateDSPoolPayload | ConvertTo-json -depth 5 #Depending on your schema, you may need to use -InputObject for proper JSON format of single item arrays

#$ConvertedDSPool 
"$BaseUrl/$DSpoolPath/$DSpoolID"

$DSPoolSpecs = Invoke-RestMethod -Uri "$BaseUrl/$DSpoolPath/$DSpoolID" -Method Get -Headers $Headers
$TestSpec = $DSPoolSpecs | ConvertTo-json

#Use a Try/Catch to figure out what schema items are/arent needed
try {
	$DSPoolUpdate = Invoke-RestMethod -Uri "$BaseUrl/$DSpoolPath/$DSpoolID" -Method Put -Headers $Headers -Body $ConvertedDSPool -contenttype "application/json"
}
catch [system.net.webexception] {
$reader = new-object system.io.streamreader($_.exception.response.getresponsestream())
$ResponseText = $reader.readtoend()

write-error "HTTP Status: $_.exception.response.statuscode"
write-error "Server Response: $ResponseText"
}
