require 'spec_helper'

describe PowProxy do

  describe '.new' do
    context 'defaults' do
      before do
        @proxy = PowProxy.new
      end

      it 'defaults the host to "127.0.0.1"' do
        @proxy.host.should eq('127.0.0.1')
      end

      it 'defaults the port to 3000' do
        @proxy.port.should eq(3000)
      end
    end

    context 'options' do
      before do
        @proxy = PowProxy.new(:host => 'localhost2', :port => 4242)
      end

      it 'sets the host to "localhost2"' do
        @proxy.host.should eq('localhost2')
      end

      it 'sets the port to 4242' do
        @proxy.port.should eq(4242)
      end
    end

    context 'ENV' do
      before do
        ENV['HOST'] = 'monk.local'
        ENV['PORT'] = '8080'
        @proxy = PowProxy.new
      end

      it 'defaults the host to "monk.local"' do
        @proxy.host.should eq('monk.local')
      end

      it 'defaults the port to 8080' do
        @proxy.port.should eq('8080')
      end
    end
  end

  describe 'integration' do
    before do
      @proxy = PowProxy.new(:host => 'app.local', :port => 2121)
    end

    it 'returns the requested content' do
      stub_request(:get, "http://app.local:2121/").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "abcdefg", :headers => {})

      env = { "REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/", "rack.input" => StringIO.new }
      response = @proxy.call(env)
      body = response.last.shift
      body.should eq('abcdefg')
    end

    it 'removes the transfer-encoding header from the response' do
      stub_request(:get, "http://app.local:2121/").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "abcdefg", :headers => { 'Transfer-Encoding' => 'chunked'})

      env = { "REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/", "rack.input" => StringIO.new }
      response = @proxy.call(env)
      headers = response[1]
      headers.should_not have_key('transfer-encoding')
    end

    it 'passes headers to the node server' do
      stub_request(:get, "http://app.local:2121/").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip,deflate,sdch', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "abcdefg", :headers => {})

      env = { "REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/", "rack.input" => StringIO.new, 'HTTP_ACCEPT_ENCODING' => "gzip,deflate,sdch" }
      response = @proxy.call(env)
      body = response.last.shift
      body.should eq('abcdefg')
    end

    it 'reports an error when it cannot request to the node server' do
      Rack::Request.stub(:new).and_raise(Errno::ECONNREFUSED)

      env = { "REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/", "rack.input" => StringIO.new }
      response = @proxy.call(env)
      response.first.should eq(500)
      body = response.last.shift
      body.should match(/Could not establish a connection/)
    end
  end

end