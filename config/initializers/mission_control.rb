# frozen_string_literal: true

MissionControl::Jobs.http_basic_auth_enabled = true
MissionControl::Jobs.http_basic_auth_user = ENV.fetch('MISSION_CONTROL_USERNAME', nil)
MissionControl::Jobs.http_basic_auth_password = ENV.fetch('MISSION_CONTROL_PASSWORD', nil)
