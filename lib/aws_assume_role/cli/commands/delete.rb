require_relative "../actions/delete_profile"

module AwsAssumeRole::Cli
    desc t "commands.delete.desc"
    command :delete do |c|
        c.flag [:p, "profile"], desc: t("options.profile_name"), default: proc { nil }
        c.action do |global_options, options, args|
            AwsAssumeRole::Cli::Actions::DeleteProfile.new(global_options, options, args)
        end
    end
end
