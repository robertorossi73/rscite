do
  require("luascr/rluawfx")

  --decripta file
  output:ClearAll()  
  res = rfx_exeCapture("gpg\\GPG --cipher-algo AES -c --passphrase \"roberto\" --armor --output \"test-test.txt.gpg\" \"test.txt\"")
  print(res)
  
  --scite.Open("");
  --editor:AddText(output:GetText())
  --output:ClearAll()  
  print("\nFile Codificato correttamente.")
end
