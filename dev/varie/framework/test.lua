
test = {}

function ciao ()
  print("ok")
end

test["prova"] = ciao

function test:prova2  ()
  print("ok2")
end

test:prova()
test:prova2()
