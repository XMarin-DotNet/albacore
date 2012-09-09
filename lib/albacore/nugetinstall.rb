# Albacore task for installing NuGet packages

require 'albacore/albacoretask'
require 'albacore/support/supportlinux'

class NuGetInstall
	include Albacore::Task
  	include Albacore::RunCommand
  	include SupportsLinuxEnvironment

  	attr_accessor	:command,
  					:package,
  					:output_directory,
  					:version,
  					:exclude_version,
  					:prerelease,
  					:no_cache

	attr_array		:sources

	def initialize(command="NuGet.exe")
		super()
		@sources = []
		@command = command
		@no_cache = false
		@prerelease = false
		@exclude_version = false
	end

	def execute
		fail_with_message 'package must be specified.' if @package.nil?

		params = []
		params << "install"
		params << package
		params << "-Version #{version}" unless @version.nil?
		params << "-OutputDirectory #{output_directory}" unless @output_directory.nil?
		params << "-ExcludeVersion" if @exclude_version
		params << "-NoCache" if @no_cache
		params << "-Prerelease" if @prerelease
		params << "-Source #{build_package_sources}" unless @sources.nil? || @sources.empty?

		merged_params = params.join(' ')

		@logger.debug "Build NuGet Install Command Line: #{merged_params}"
		result = run_command "NuGet", merged_params

		failure_message = "Nuget Install for package #{@package} failed. See Build log for details."
		fail_with_message failure_message if !result
	end

	def build_package_sources
		source_list = []
    	@sources.each do |value|
      		source_list << "\"#{value}\""
  		end
  		source_list.join(";")
	end
end