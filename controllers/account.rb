require_relative '..\cookie'
require_relative '..\database'
require 'sequel'
require 'sqlite3'

class Account
  def account(request, directory, mime_types)
    	    
  db = Database.db_connect()
  puts "account class"
  puts $cookie
	id = $cookie["Id"]
	user = db['SELECT * FROM users WHERE id = ?', id].first
  
  puts user
	
	
	encountersArr = db['SELECT e.name AS Encounter
                     FROM encounters e, users_encounters ue 
                     WHERE e.id = ue.encounter_id AND ue.user_id = ?', id]
            
  encounters ="<table><th>Encounters</th>"
	
	encountersArr.each do |e|
	  encounters += "<tr><td>#{e[:Encounter]}</td></tr>"
	end

	encounters += "</table>"


	success = File.read("#{directory}/header.txt") + "    
        <main>
        <h1>Mr. #{user[:first_name]} Sir What Will You're Pleasure Be!</h1>
          <section>
            <h2>Encounters</h2>
              #{encounters}
          <img src=\"/images/Genie_Aladdin.png\" alt=\"Genie of the Lamp\">
          </section>
        </main>
      </body> 
    </html>"
    [200, {"Content-type" => "text/html", "class_name" => "Account", "method_name" => "account"}, [success]]
  end  
end
