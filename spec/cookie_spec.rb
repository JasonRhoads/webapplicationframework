require 'spec_helper'

RSpec.describe Cookie do

  it "produces equivalent output when two cookies with the same data are serialized" do  
    cookie1 = Cookie.new("request", '_clarity_session={}')
    cookie2 = Cookie.new("request", '_clarity_session={}')
    cookie1["Name"] = "Jason"
    cookie1["NomNom"] = "Cookie"

    cookie2["Name"] = "Jason"
    cookie2["NomNom"] = "Cookie"

    expect(cookie1.serialize).to eq cookie2.serialize
  end

  it "produces equivalent output when one serialized cookie is used to produce a second cookie" do  
    cookie1 = Cookie.new("request", '_clarity_session={}')
    
    cookie1["Name"] = "Max"
    cookie1["NomNom"] = "Cookie"

    cookie2 = Cookie.new("request", cookie1.serialize)

    expect(cookie1.serialize).to eq cookie2.serialize
  end

end