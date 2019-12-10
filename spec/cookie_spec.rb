require 'spec_helper'

RSpec.describe Cookie do

  it "validates cookie serialization" do  
    cookie1 = Cookie.new("request", '_clarity_session={}')
    cookie2 = Cookie.new("request", '_clarity_session={}')
    cookie1["Name"] = "Jason"
    cookie1["NomNom"] = "Cookie"

    cookie2["Name"] = "Jason"
    cookie2["NomNom"] = "Cookie"

    expect(cookie1.serialize).to eq "#{cookie2.serialize}"
  end

end