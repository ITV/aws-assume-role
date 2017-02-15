require_relative "includes"
require_relative "../../runner"
require_relative "../../credentials/factories/default_chain_provider"

class AwsAssumeRole::Cli::Actions::Run < AwsAssumeRole::Cli::Actions::AbstractAction
    include AwsAssumeRole::Ui

    CommandSchema = proc do
        required(:profile).maybe
        optional(:region) { filled? > format?(REGION_REGEX) }
        optional(:serial_number) { filled? > format?(MFA_REGEX) }
        required(:role_arn).maybe
        required(:role_session_name).maybe
        required(:duration_seconds).maybe
        rule(role_specification: [:profile, :role_arn, :role_session_name, :duration_seconds]) do |p, r, s, d|
            (p.filled? | p.empty? & r.filled?) & (r.filled? > s.filled? & d.filled?)
        end
    end

    def act_on(config)
        credentials = try_for_credentials config.to_h
        unless config.args.empty?
            Runner.new(config.args,
                       environment: { "AWS_DEFAULT_REGION" => config.region },
                       credentials: credentials)
        end
    rescue KeyError, Aws::Errors::NoSuchProfileError
        error "Cannot find profile"
    end
end
