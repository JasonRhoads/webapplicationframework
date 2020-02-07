require 'spec_helper'

RSpec.describe Clarity do
  context "Routes" do
    context "GT /me" do
      let(:app)      { Clarity.new }
      let(:env)      { { "REQUEST_METHOD" => "GT", "PATH_INFO" => "/me", "HTTP_COOKIE" =>"_clarity_session=v+CoJ6sR6q/c5zCXRdiVLUt3/qh4NhazDcnVV7ZlzsBbeduCjhoTCQ==" } }
      let(:response) { app.call(env) }
      let(:response_code)     { response[0] }

      it "fails - GT /me returns a 404 HTTP response code" do
        expect(response_code).to eq 404
      end
    end

    context "GET /m" do
      let(:app)      { Clarity.new }
      let(:env)      { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/m", "HTTP_COOKIE" =>"_clarity_session=v+CoJ6sR6q/c5zCXRdiVLUt3/qh4NhazDcnVV7ZlzsBbeduCjhoTCQ==" } }
      let(:response) { app.call(env) }
      let(:response_code)     { response[0] }

      it "fails - GET /m returns a 404 HTTP response code" do
        expect(response_code).to eq 404
      end
    end
  end
end

RSpec.describe Routes do
  routes = Routes.new(File.expand_path(File.dirname(__FILE__)))
  it "http request and path call class and funciton correctly" do
    expect(routes["GET /me"]).to eq "me_test#me"
  end

  it  "bad http request and path call class and funciton" do
    expect(routes["GET /m"]).to eq "me_tet#m"
  end
end