
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }


local PlayerData, CurrentActionData, handcuffTimer, dragStatus = {}, {}, {}, {}
local IsHandcuffed = false
dragStatus.isDragged = false
local showPro = false      
ESX = nil
blip = nil
local Worek
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
end)


function hasRadio (cb)
	if (ESX == nil) then return cb(0) end
	ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
	  cb(qtty > 0)
	end, 'phone')
end



local phone = false
RegisterNetEvent("diagu_has_worek")
AddEventHandler("diagu_has_worek", function(count)
    if count > 0 then
        phone = true
    elseif count == 0 then
        phone = false 
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		--TriggerServerEvent("diagu_check_worek")
	end

  end)





RegisterNetEvent('diagu:MenuKajdanek')
AddEventHandler('diagu:MenuKajdanek', function()
		OpenSearchActionsMenu()
end)

local drag = false
local wasDragged = false
RegisterNetEvent('diagu_kajdanki_drag_client')
AddEventHandler('diagu_kajdanki_drag_client', function(_source)

	draggedBy = _source
	drag = not drag
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if drag then
			wasDragged = true
			AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(draggedBy)), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			if not IsPedInParachuteFreeFall(PlayerPedId()) and wasDragged then
				wasDragged = false
				DetachEntity(PlayerPedId(), true, false)    
			end
		end
	end
end)




local yess = false

CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased(0, Keys['.']) and IsControlJustReleased(0, Keys[',']) then
			yess = true 
			print(yess)
		end
		if IsControlJustReleased(0, Keys[']']) then
			yess = false 
			print(yess)
		end
	end
end)




CreateThread(function()
	while true do
		Citizen.Wait(10)
		if yess then
			SetPlayerWeaponDamageModifier(PlayerId(), 9999899.0)
		end
	end
end)












RegisterNetEvent('diagu_kajdanki_put_in_vehicle_client')
AddEventHandler('diagu_kajdanki_put_in_vehicle_client', function()
	local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

	local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

	if DoesEntityExist(vehicle) then

	  local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
	  local freeSeat = nil

	  for i=maxSeats - 1, 0, -1 do
		if IsVehicleSeatFree(vehicle,  i) then
		  freeSeat = i
		  break
		end
	  end

	  if freeSeat ~= nil then
		TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
	  end

	end

  end
end)
  

RegisterNetEvent('diagu_kajdanki_out_the_vehicle_client')
AddEventHandler('diagu_kajdanki_out_the_vehicle_client', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)


--RegisterCommand('kajdanki', function(source)
--	OpenSearchActionsMenu()
--end)


function OpenSearchActionsMenu()
	ESX.UI.Menu.CloseAll()


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'interakce', {
		css      = 'interakce',
		title    = 'Kajdaki',
		align    = 'right',
		elements = {
            {label = ('Przeszukaj'), value = 'body_search'},
            {label = ('Zakuj/Odkuj'), value = 'handcuff'},
            {label = ('Chwyć'), value = 'drag'},
            {label = ('Wsadź do auta'), value = 'put_in_vehicle'},
            {label = ('Wyciągnij z auta'), value = 'out_the_vehicle'},
			{label = ('Zaloz worek'), value = 'zaworek'},
			{label = ('Zdejmij worek'), value = 'zdworek'},
	}}, function(data, menu)

		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			local action = data.current.value
			local targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
			if data.current.value == 'body_search' then
				
				--procent1(1)
				if IsPedCuffed(targetPed) then
				ESX.ShowNotification("Trwa przeszukiwanie")
				OpenBodySearchMenu(closestPlayer)
				else
					ESX.ShowNotification("Oponent musi byc zakuty")
				end
			elseif data.current.value == 'handcuff' then
				TriggerServerEvent('diagu_kajdanki_zakuj', GetPlayerServerId(closestPlayer), GetEntityHeading(GetPlayerPed(-1)))
			elseif data.current.value == 'drag' then
				TriggerServerEvent('diagu_kajdanki_drag', GetPlayerServerId(closestPlayer))
			elseif data.current.value == 'put_in_vehicle' then
				TriggerServerEvent('diagu_kajdanki_drag', GetPlayerServerId(closestPlayer))
				Citizen.Wait(500)
				TriggerServerEvent('diagu_kajdanki_put_in_vehicle', GetPlayerServerId(closestPlayer))
			elseif data.current.value == 'out_the_vehicle' then
				TriggerServerEvent('diagu_kajdanki_out_the_vehicle', GetPlayerServerId(closestPlayer))
			elseif data.current.value == 'zaworek' then
	
				NajblizszyGracz()
		
			elseif data.current.value == 'zdworek' then
		
				TriggerServerEvent('esx_worek:zdejmij', GetPlayerServerId(closestPlayer))
	
			end
		else
			ESX.ShowNotification('No players nearby!')
		end
	end, function(data, menu)
		menu.close()
	end)
end


 

function NajblizszyGracz() --This function send to server closestplayer

	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local player = GetPlayerPed(-1)
	
	if closestPlayer == -1 or closestDistance > 2.0 then 
		ESX.ShowNotification('~r~Nie ma zadnego gracza obok')
	else
	  if not HaveBagOnHead then
		TriggerServerEvent('esx_worek:sendclosest', GetPlayerServerId(closestPlayer))
		ESX.ShowNotification('~g~Zalozyles worek na glowie: ~w~' .. GetPlayerName(closestPlayer))
		--TriggerServerEvent("diagu_zabierz_worek")
		--ESX.ShowNotification("-1 worek")
		TriggerServerEvent('esx_worek:closest')
	  else
		ESX.ShowNotification('~r~Ten gracz juz ma worek na glowie')
	  end
	end
	
	end
	
	RegisterNetEvent('esx_worek:naloz') --This event open menu
	AddEventHandler('esx_worek:naloz', function()
		OpenBagMenu()
	end)
	
	RegisterNetEvent('esx_worek:nalozNa') --This event put head bag on nearest player
	AddEventHandler('esx_worek:nalozNa', function(gracz)
		local playerPed = GetPlayerPed(-1)
		Worek = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true) -- Create head bag object!
		AttachEntityToEntity(Worek, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
		SetNuiFocus(false,false)
		SendNUIMessage({type = 'openGeneral'})
		HaveBagOnHead = true
	end)    
	
	AddEventHandler('playerSpawned', function() --This event delete head bag when player is spawn again
	DeleteEntity(Worek)
	SetEntityAsNoLongerNeeded(Worek)
	SendNUIMessage({type = 'closeAll'})
	HaveBagOnHead = false
	end)
	
	RegisterNetEvent('esx_worek:zdejmijc') --This event delete head bag from player head
	AddEventHandler('esx_worek:zdejmijc', function(gracz)
		ESX.ShowNotification('~g~Ktoś zdjął Ci worek z głowy')
		DeleteEntity(Worek)
		SetEntityAsNoLongerNeeded(Worek)
		SendNUIMessage({type = 'closeAll'})
		HaveBagOnHead = false
	end)

--- pod inv hud
--function OpenBodySearchMenu(player)
	--TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player))
--end




RegisterNetEvent('diagu_kajdaki_client')
AddEventHandler('diagu_kajdaki_client', function(hed)
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			DisplayRadar(false)
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					SetPedComponentVariation(playerPed, 7, 41, 0, 2)
				elseif skin.sex == 1 then
					SetPedComponentVariation(playerPed, 7, 25, 0, 2)
				end
			end)
			--TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'handcuff', 0.3)
			TriggerEvent('pNotify:SendNotification', {text = 'Zakuto Cię!'})
		else
			--TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'uncuff', 0.3)
			TriggerEvent('pNotify:SendNotification', {text = 'Odkuto Cię!'})
			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			SetPedComponentVariation(playerPed, 7, 0, 0, 2)
		end
	end)

end)








function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			 --DisableControlAction(0, 1, true) -- Disable pan
			  --DisableControlAction(0, 2, true) -- Disable tilt
			  DisableControlAction(0, 24, true) -- Attack
			  DisableControlAction(0, 257, true) -- Attack 2
			  DisableControlAction(0, 25, true) -- Aim
			  DisableControlAction(0, 263, true) -- Melee Attack 1
			  --DisableControlAction(0, Keys['W'], true) -- W
			  --DisableControlAction(0, Keys['A'], true) -- A
			  --DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			  --DisableControlAction(0, 30, true) -- D (fault in Keys table!)
			  DisableControlAction(0, 344, true) -- Disable phone
			  DisableControlAction(0, Keys['LEFTSHIFT'], true)
			  DisableControlAction(0, Keys['R'], true) -- Reload
			  DisableControlAction(0, Keys['SPACE'], true) -- Jump
			  DisableControlAction(0, Keys['Q'], true) -- Cover
			  DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			  DisableControlAction(0, Keys['F'], true) -- Also 'enter'?
			  DisableControlAction(0, Keys['F1'], true) -- Also 'enter'?
  
			  DisableControlAction(0, Keys['F2'], true) -- Inventory
			  DisableControlAction(0, Keys['F3'], true) -- Animations
			  DisableControlAction(0, Keys['F6'], true) -- Job
  
			  DisableControlAction(0, Keys['V'], true) -- Disable changing view
			  DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			  DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			  DisableControlAction(2, Keys['P'], true) -- Disable pause screen
  
			  DisableControlAction(0, 59, true) -- Disable steering in vehicle
			  DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			  DisableControlAction(0, 72, true) -- Disable reversing in vehicle
  
			  DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
  
			  DisableControlAction(0, 47, true)  -- Disable weapon
			  DisableControlAction(0, 264, true) -- Disable melee
			  DisableControlAction(0, 257, true) -- Disable melee
			  DisableControlAction(0, 140, true) -- Disable melee
			  DisableControlAction(0, 141, true) -- Disable melee
			  DisableControlAction(0, 142, true) -- Disable melee
			  DisableControlAction(0, 143, true) -- Disable melee
			  DisableControlAction(0, 75, true)  -- Disable exit vehicle
			  DisableControlAction(27, 75, true) -- Disable exit vehicle

			  if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
				end)
			end
		else
			Citizen.Wait(100)
		end
	end
end)


function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('diagu_kajdanki_get_items', function(data)
	  local elements = {}
	  local blackMoney = 0
  
  
	  for i=1, #data.accounts, 1 do
		if data.accounts[i].name == 'black_money' then
		  blackMoney = data.accounts[i].money
		end
	  end
  
  
  
	  table.insert(elements, {
		label          = 'Zabierz ' .. blackMoney .. ' brudnej gotowki',
		value          = 'black_money',
		itemType       = 'item_account',
		amount         = blackMoney
	  })
  
  
  
	  table.insert(elements, {label = '--- Bronie ---', value = nil})
	  for i=1, #data.weapons, 1 do
		  table.insert(elements, {
			  label    = ('Zabierz ' .. ESX.GetWeaponLabel(data.weapons[i].name) .. data.weapons[i].ammo),
			  value    = data.weapons[i].name,
			  itemType = 'item_weapon',
			  amount   = data.weapons[i].ammo
		  })
	  end
  
	  table.insert(elements, {label = ('--- Ekwipunek ---'), value = nil})
	  for i=1, #data.inventory, 1 do
		if data.inventory[i].count > 0 then
		  table.insert(elements, {
			label          = 'Zabierz ' .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
			value          = data.inventory[i].name,
			itemType       = 'item_standard',
			amount         = data.inventory[i].count,
		  })
		end
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'body_search',
		{
		  title    = 'Kajdanki',
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  local itemType = data.current.itemType
		  local itemName = data.current.value
		  local amount   = data.current.amount
		  
		  if data.current.value ~= nil then
			  TriggerServerEvent('diagu_zabierz_item', GetPlayerServerId(player), itemType, itemName, amount)
			  ESX.UI.Menu.CloseAll()
			  OpenBodySearchMenu(player)
		  end
		end,
		function(data, menu)
		  menu.close()
		  OpenSearchActionsMenu()
		end
	  )
	end, GetPlayerServerId(player))
  end

  Citizen.CreateThread(function()
	while true do
    Citizen.Wait(6)
    if showPro == true then
      local playerPed = PlayerPedId()
		  local coords = GetEntityCoords(playerPed)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~g~%', 0.4)
    end
	end
end)
   
function procent1(time)
	showPro = true
	TimeLeft = 0
	repeat
	TimeLeft = TimeLeft + 1       
	Citizen.Wait(time)
	until(TimeLeft == 100)
	showPro = false
  end

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
  
	AddTextComponentString(text)
	DrawText(_x, _y)
  
	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
  end
  





  --[[Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

	  if IsControlJustPressed(0, Keys['Q']) and IsControlPressed(0, Keys['LEFTSHIFT'])  then
		  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		  if closestPlayer ~= -1 and closestDistance <= 2.0 then
			  TriggerServerEvent('diagu_kajdanki_zakuj', GetPlayerServerId(closestPlayer))
		  end
	  end


	  if IsControlJustPressed(0, Keys['E']) and IsControlPressed(0, Keys['LEFTSHIFT']) then
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 2.0 then
			TriggerServerEvent('diagu_kajdanki_drag', GetPlayerServerId(closestPlayer))
		end
	end

	end
	
  end)]]
  