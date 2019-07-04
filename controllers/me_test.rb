class MeTest
  def me(request, root, mime_types)
    success = File.read("#{root}/header.txt") + "    
        <main>
        <h1>Mr. Alladin Sir What Will You're Pleasure Be!</h1>
          <img src=\"/images/Genie_Aladdin.png\" alt=\"Genie of the Lamp\">
        </main>
      </body> 
    </html>"
    [200, {"Content-type" => "text/html", "class_name" => "MeTest", "method_name" => "me"}, [success]]
  end  
end