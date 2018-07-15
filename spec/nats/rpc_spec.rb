RSpec.describe NATS::RPC do
  it "has a version number" do
    expect(NATS::RPC::VERSION).not_to be nil
  end

  it do
    ENV['NATS_RPC_SERVER_URLS'] = "nats://127.0.0.1:12345"
    ENV['NATS_RPC_RECONNECT'] = "false"

    expect {
      client = NATS::RPC::Client.new
    }.to raise_error Errno::ECONNREFUSED
  end
end
