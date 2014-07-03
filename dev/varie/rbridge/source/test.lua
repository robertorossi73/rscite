
do
  c_test = package.loadlib("rbridge.dll","c_test")

print(c_test)

print(c_test())
end 
