class MeTest
  def me(req, root, mime_types)
    success = File.read("#{root}/header.txt") + "    
        <main>
        <h1>Mr. Alladin Sir What Will You're Pleasure Be!</h1>
          <img src=\"/images/Genie_Aladdin.png\" alt=\"Genie of the Lamp\">
        </main>
      </body> 
    </html>"
    [200, {"Content-type" => "text/html"}, [success]]
  end  
end