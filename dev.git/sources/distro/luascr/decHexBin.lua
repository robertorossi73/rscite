--[[
/*
 * Copyright (c) 2007 Tim Kelly/Dialectronics
 *
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"),  to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to permit 
 * persons to whom the Software is furnished to do so, subject to the 
 * following conditions:
 *
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
 * OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

--]]

local hex2bin = {
	["0"] = "0000",
	["1"] = "0001",
	["2"] = "0010",
	["3"] = "0011",
	["4"] = "0100",
	["5"] = "0101",
	["6"] = "0110",
	["7"] = "0111",
	["8"] = "1000",
	["9"] = "1001",
	["a"] = "1010",
        ["b"] = "1011",
        ["c"] = "1100",
        ["d"] = "1101",
        ["e"] = "1110",
        ["f"] = "1111"
	}

local bin2hex = {
	["0000"] = "0",
	["0001"] = "1",
	["0010"] = "2",
	["0011"] = "3",
	["0100"] = "4",
	["0101"] = "5",
	["0110"] = "6",
	["0111"] = "7",
	["1000"] = "8",
	["1001"] = "9",
	["1010"] = "A",
        ["1011"] = "B",
        ["1100"] = "C",
        ["1101"] = "D",
        ["1110"] = "E",
        ["1111"] = "F"
	}

-- These functions are big-endian and take up to 32 bits
-- Hex2Bin
-- Bin2Hex
-- Hex2Dec
-- Dec2Hex
-- Bin2Dec
-- Dec2Bin

function Hex2Bin(s)
-- s	-> hexadecimal string
local ret = ""
local i = 0

	for i in string.gfind(s, ".") do
		i = string.lower(i)
		ret = ret..hex2bin[i]
	end

	return ret
end

function Bin2Hex(s)
-- s 	-> binary string
local l = 0
local h = ""
local b = ""
local rem

l = string.len(s)
rem = l % 4
l = l-1
h = ""

	-- need to prepend zeros to eliminate mod 4
	if (rem > 0) then
		s = string.rep("0", 4 - rem)..s
	end

	for i = 1, l, 4 do
		b = string.sub(s, i, i+3)
		h = h..bin2hex[b]
	end

	return h
end

function Bin2Dec(s)
-- s	-> binary string
local num = 0
local ex = string.len(s) - 1
local l = 0

	l = ex + 1
	for i = 1, l do
		b = string.sub(s, i, i)
		if b == "1" then
			num = num + 2^ex
		end
		ex = ex - 1
	end

	return string.format("%u", num)
end

function Dec2Bin(s, num)
-- s	-> Base10 string
-- num  -> string length to extend to
local n

	if (num == nil) then
		n = 0
	else
		n = num
	end

	s = string.format("%x", s)
	s = Hex2Bin(s)

	while string.len(s) < n do
		s = "0"..s
	end

	return s
end

function Hex2Dec(s)
-- s	-> hexadecimal string
local s = Hex2Bin(s)

	return Bin2Dec(s)
end

function Dec2Hex(s)
-- s	-> Base10 string
	s = string.format("%x", s)

	return s
end

-- These functions are big-endian and will extend to 32 bits
-- BMAnd
-- BMNAnd
-- BMOr
-- BMXOr
-- BMNot

function BMAnd(v, m)
-- v	-> hex string to be masked
-- m	-> hex string mask
-- s	-> hex string as masked
-- bv	-> binary string of v
-- bm	-> binary string mask
local bv = Hex2Bin(v)
local bm = Hex2Bin(m)
local i = 0
local s = ""

	while (string.len(bv) < 32) do
		bv = "0000"..bv
	end

	while (string.len(bm) < 32) do
		bm = "0000"..bm
	end

	for i = 1, 32 do
		cv = string.sub(bv, i, i)
		cm = string.sub(bm, i, i)
		if cv == cm then
			if cv == "1" then
				s = s.."1"
			else
				s = s.."0"
			end
		else
			s = s.."0"
		end
	end

	return Bin2Hex(s)
end

function BMNAnd(v, m)
-- v	-> hex string to be masked
-- m	-> hex string mask
-- s	-> hex string as masked
-- bv	-> binary string of v
-- bm	-> binary string mask
local bv = Hex2Bin(v)
local bm = Hex2Bin(m)
local i = 0
local s = ""

	while (string.len(bv) < 32) do
		bv = "0000"..bv
	end

	while (string.len(bm) < 32) do
		bm = "0000"..bm
	end

	for i = 1, 32 do
		cv = string.sub(bv, i, i)
		cm = string.sub(bm, i, i)
		if cv == cm then
			if cv == "1" then
				s = s.."0"
			else
				s = s.."1"
			end
		else
			s = s.."1"
		end
	end

	return Bin2Hex(s)
end

function BMOr(v, m)
-- v	-> hex string to be masked
-- m	-> hex string mask
-- s	-> hex string as masked
-- bv	-> binary string of v
-- bm	-> binary string mask
local bv = Hex2Bin(v)
local bm = Hex2Bin(m)
local i = 0
local s = ""

	while (string.len(bv) < 32) do
		bv = "0000"..bv
	end

	while (string.len(bm) < 32) do
		bm = "0000"..bm
	end

	for i = 1, 32 do
		cv = string.sub(bv, i, i)
		cm = string.sub(bm, i, i)
		if cv == "1" then
				s = s.."1"
		elseif cm == "1" then
				s = s.."1"
		else
			s = s.."0"
		end
	end

	return Bin2Hex(s)
end

function BMXOr(v, m)
-- v	-> hex string to be masked
-- m	-> hex string mask
-- s	-> hex string as masked
-- bv	-> binary string of v
-- bm	-> binary string mask
local bv = Hex2Bin(v)
local bm = Hex2Bin(m)
local i = 0
local s = ""

	while (string.len(bv) < 32) do
		bv = "0000"..bv
	end

	while (string.len(bm) < 32) do
		bm = "0000"..bm
	end

	for i = 1, 32 do
		cv = string.sub(bv, i, i)
		cm = string.sub(bm, i, i)
		if cv == "1" then
			if cm == "0" then
				s = s.."1"
			else
				s = s.."0"
			end
		elseif cm == "1" then
			if cv == "0" then
				s = s.."1"
			else
				s = s.."0"
			end
		else
			-- cv and cm == "0"
			s = s.."0"
		end
	end

	return Bin2Hex(s)
end

function BMNot(v, m)
-- v	-> hex string to be masked
-- m	-> hex string mask
-- s	-> hex string as masked
-- bv	-> binary string of v
-- bm	-> binary string mask
local bv = Hex2Bin(v)
local bm = Hex2Bin(m)
local i = 0
local s = ""

	while (string.len(bv) < 32) do
		bv = "0000"..bv
	end

	while (string.len(bm) < 32) do
		bm = "0000"..bm
	end

	for i = 1, 32 do
		cv = string.sub(bv, i, i)
		cm = string.sub(bm, i, i)
		if cm == "1" then
			if cv == "1" then
				-- turn off
				s = s.."0"
			else
				-- turn on
				s = s.."1"
			end
		else
			-- leave untouched
			s = s..cv
		end
	end

	return Bin2Hex(s)
end

-- these functions shift right and left, adding zeros to lost or gained bits
-- returned values are 32 bits long
-- BShRight(v, nb)
-- BShLeft(v, nb)

function BShRight(v, nb)
-- v	-> hexstring value to be shifted
-- nb	-> number of bits to shift to the right
-- s	-> binary string of v
local s = Hex2Bin(v)

	while (string.len(s) < 32) do
		s = "0000"..s
	end

	s = string.sub(s, 1, 32 - nb)

	while (string.len(s) < 32) do
		s = "0"..s
	end

	return Bin2Hex(s)
end

function BShLeft(v, nb)
-- v	-> hexstring value to be shifted
-- nb	-> number of bits to shift to the right
-- s	-> binary string of v
local s = Hex2Bin(v)

	while (string.len(s) < 32) do
		s = "0000"..s
	end

	s = string.sub(s, nb + 1, 32)

	while (string.len(s) < 32) do
		s = s.."0"
	end

	return Bin2Hex(s)
end

--[[
Version : 1.0.2
Web     : http://www.redchar.net

Questo modulo consente la conversione di un numero, selezionato e/o inserito
con dialog, in una base differente. Le conversioni supportate sono :
Decimale - Esadecimale
Decimale - Binario
Esadecimale - Decimale
Esadecimale - Binario
Binario - Esadecimale
Binario - Decimale

Copyright (C) 2012-2013 Roberto Rossi 
*******************************************************************************
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
*******************************************************************************
]]
 
do

  --ritorna true se il numero (come stringa) passato è binario
  local function is_binary_number(num)
    local ch
    local i=string.len(num)
    local result = true
    
    while ((i > 0) and result) do
      ch = string.sub(num,i,i)
      if ((ch~="1") and (ch~="0")) then
        result = false
      end
      i = i - 1
    end
    
    return result
  end
  
  local function main()
    local scelta
    local lst
    local num
    local result
    
    num = editor:GetSelText()
    if (num=="") then
      num = "0"
    else
      num = tostring(tonumber(num))
    end
    
    -- num = rwfx_InputBox(num, "Numero da Convertire",
    --   "Specifica il numero da convertire : \r\n\r\n"..
    --   "Attenzione : la procedurà è in grado di gestie numeri fino a 32bit!"
    --   , rfx_FN())
    num = rwfx_InputBox(num, _t(215), _t(216), rfx_FN())
    if num then
      num = rfx_GF()
--~       lst = "da Decimale a Binario -> "..Dec2Bin(num).."|"..
--~             "da Decimale a Esadecimale -> "..Dec2Hex(num).."|"..
--~             "da Esadecimale a Decimale -> "..Hex2Dec(num).."|"..
--~             "da Esadecimale a Binario -> "..Hex2Bin(num)
      lst = _t(217).." -> "..Dec2Bin(num).."|"..
            _t(218).." -> "..Dec2Hex(num).."|"..
            _t(219).." -> "..Hex2Dec(num).."|"..
            _t(220).." -> "..Hex2Bin(num)
      if (is_binary_number(num)) then
        lst = lst.."|".._t(221).." -> "..Bin2Dec(num).."|"..
              _t(222).." -> "..Bin2Hex(num)
      end
      
      scelta = rwfx_ShowList(lst,_t(223).." "..num)
      if (scelta) then
        result = false
        if (scelta==0) then
          result = Dec2Bin(num)
        elseif (scelta==1) then
          result = Dec2Hex(num)
        elseif (scelta==2) then
          result = Hex2Dec(num)
        elseif (scelta==3) then
          result = Hex2Bin(num)
        elseif (scelta==4) then
          result = Bin2Dec(num)
        elseif (scelta==5) then
          result = Bin2Hex(num)
        end
        if (result) then
          editor:ReplaceSel(result)
        end
      end
    end
  end
  
  main()    

end
 
