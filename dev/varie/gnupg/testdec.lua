do
  require("luascr/rluawfx")

  --decripta file
  output:ClearAll()  
  res = rfx_exeCapture("gpg\\GPG --cipher-algo AES -d --passphrase \"roberto\" \"test-test.txt.gpg\"")
  print(res)
  
  scite.Open("");
  editor:AddText(output:GetText())
  output:ClearAll()  
  --print("\nFile Decodificato correttamente.")
end
