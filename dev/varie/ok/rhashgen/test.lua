do
  require("luascr/rluawfx")
  
  
  local function main()
    local out = false
    
    if (rfx_dotNetExist("3.5")) then
      out = rfx_exeCapture("\"C:\\temp\\sv\\rhashgen\\bin\\Release\\rhash gen.exe\" /MD5 /S ciao miao")
    end
  
    return out
  end  
  
  output:ClearAll()
  print(main())
 
end
 