require 'spec_helper'

RSpec.describe Clarity do
  context "Static route dispatcher" do
    context "GET /images/Genie_Aladdin.png" do
      let(:app)      { Clarity.new }
      let(:env)      { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/images/Genie_Aladdin.png", "HTTP_COOKIE" =>"_clarity_session=v+CoJ6sR6q/c5zCXRdiVLUt3/qh4NhazDcnVV7ZlzsBbeduCjhoTCQ==" } }
      let(:response) { app.call(env) }
      let(:response_code)     { response[0] }

      it "works - /images/Genie_Aladdin.png returns a 200 HTTP response code" do
        expect(response_code).to eq 200
      end
    end
  end
end