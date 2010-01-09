require 'albacore/support/albacore_helper'

class PLinkCommand
	include RunCommand
	include YAMLConfig
	include Logging

	attr_accessor :path_to_command, :host, :port, :user, :key , :commands, :verbose

	def initialize()
			super()
			@require_valid_command = false
			@port = 22
			@verbose = false
			@commands = []
	end

	def run()
		check_command
		return if @failed
    parameters = create_parameters
		result = run_command @path_to_command, parameters.join(" ")
		failure_message = 'Command Failed. See Build Log For Detail'
		fail_with_message failure_message if !result
	end
	
	def create_parameters
	  parameters = []
		parameters << "#{@user}@#{@host} -P #{@port} "
		parameters << build_parameter("i", @key) unless @key.nil?
		parameters << "-batch"
		parameters << "-v" if @verbose
		parameters << @commands
		@logger.debug "PLink Parameters" + parameters.join(" ")
		return parameters
  end

	def build_parameter(param_name, param_value)
		"-#{param_name} #{param_value}"
	end

	def check_command
		return if @path_to_command
		fail_with_message 'Plink.path_to_command cannot be nil.'
	end
end