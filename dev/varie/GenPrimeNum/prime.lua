--local number = 200
--local number = io.read("*n")
--local isPrime = true

function isPrimeNumber (number)
  local i
  local isPrime = true
  
  for i = 2, math.sqrt(number) do
    if number % i == 0 then
      isPrime = false
      break
    end
  end

  if isPrime then
    return true
    --print(tostring(number).." Is prime!") 
  else
    return false
    --print(tostring(number).." Isn't prime!")
  end
end

function checkPrime(min, max)
  local i
  local time1
  local time2
  local used

  print("\nElaborazione in corso...("..
        tostring(min)..","..tostring(max)..")")
  time1 = os.time()
  i = min
  while (i < max) do
    if (isPrimeNumber(i)) then
      print(i)
    end
    i = i + 1
  end
  time2 = os.time()
  
  print ("\nConcluso ("..tostring(time2-time1).."s)")
end
                    
function main()
  checkPrime(1, 1000000)
end

main()
