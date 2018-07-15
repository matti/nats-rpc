require "bundler/setup"
require "nats/rpc"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def wrap_env(envs = {})
  original_envs = ENV.select{ |k, _| envs.has_key? k }
  envs.each{ |k, v| ENV[k] = v }

  yield
ensure
  envs.each{ |k, _| ENV.delete k }
  original_envs.each{ |k, v| ENV[k] = v }
end
