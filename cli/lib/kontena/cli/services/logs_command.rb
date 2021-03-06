require_relative 'services_helper'
require_relative '../helpers/log_helper'

module Kontena::Cli::Services
  class LogsCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Cli::Helpers::LogHelper
    include ServicesHelper

    parameter "NAME", "Service name"
    option ["-i", "--instance"], "INSTANCE", "Show only given instance specific logs"

    def execute
      require_api_url

      query_params = {}
      query_params[:container] = "#{name}-#{instance}" if instance

      show_logs("services/#{parse_service_id(name)}/container_logs", query_params) do |log|
        show_log(log)
      end
    end

    def show_log(log)
      color = color_for_container(log['name'])
      instance_number = log['name'].match(/^.+-(\d+)$/)[1]
      name = instance_number.nil? ? log['name'] : instance_number
      prefix = "#{log['created_at']} [#{name}]:".colorize(color)
      puts "#{prefix} #{log['data']}"
    end
  end
end
