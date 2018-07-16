RSpec.describe NATS::RPC do
  it "has a version number" do
    expect(NATS::RPC::VERSION).not_to be nil
  end

  describe "envs" do
    it 'uses NATS_RPC_SERVER_URLS and NATS_RPC_RECONNECT', slow:true do
      envs = {
        'NATS_RPC_SERVER_URLS' => 'nats://127.0.0.1:12345',
        'NATS_RPC_RECONNECT' => 'false'
      }

      wrap_env envs do
        expect {
          NATS::RPC::Client.new
        }.to raise_error Errno::ECONNREFUSED

        expect {
          NATS::RPC::Servant.new
        }.to raise_error Errno::ECONNREFUSED
      end
    end
  end

  describe "errors" do
    it do
      servant = NATS::RPC::Servant.new
      servant.serve "test" do |params|
        asdf
      end
      client = NATS::RPC::Client.new

      expect {
        client.request "test", {}, {}
      }.to raise_error NATS::RPC::RemoteError, /undefined local variable or method `asdf'/
    end

    it "has remote backtrace" do
      ENV["NATS_RPC_DEBUG"] = "true"

      servant = NATS::RPC::Servant.new
      servant.serve "test" do |params|
        asdf
      end
      client = NATS::RPC::Client.new

      rex = nil
      begin
        client.request "test", {}, {}
      rescue NATS::RPC::RemoteError => rex
      end
      expect(rex.to_s).to start_with "NameError (undefined local variable or method `asdf'"
      expect(rex.message).to start_with "NameError (undefined local variable or method `asdf'"
      expect(rex.remote_exception).to eq "NameError"
      expect(rex.backtrace[3]).to include "servant.rb"
    end
  end
end
