ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent("diagu_check_worek")
AddEventHandler("diagu_check_worek", function()
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer ~= nil then
    local phone = xPlayer.getInventoryItem('worek').count

    if phone > 0 then
      TriggerClientEvent("diagu_has_worek", source, 1)
    else
      TriggerClientEvent("diagu_has_worek", source, 0)
    end
  else
    return
  end
end)



RegisterServerEvent("diagu_zabierz_worek")
AddEventHandler("diagu_zabierz_worek", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('worek', 1)
end)


RegisterServerEvent("diagu_daj_worek")
AddEventHandler("diagu_daj_worek", function()
	local player = ESX.GetPlayerFromId(source)
    player.addInventoryItem("worek", 1)
end)



ESX.RegisterServerCallback('diagu_kajdanki_get_items', function(source, cb, target)

	if Config.EnableESXIdentity then

		local xPlayer = ESX.GetPlayerFromId(target)

		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end

	else

		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)

	end

end)



RegisterServerEvent('esx_worek:closest')
AddEventHandler('esx_worek:closest', function()
    local name = GetPlayerName(najblizszy)
    TriggerClientEvent('esx_worek:nalozNa', najblizszy)
end)

RegisterServerEvent('esx_worek:sendclosest')
AddEventHandler('esx_worek:sendclosest', function(closestPlayer)
    najblizszy = closestPlayer
end)

RegisterServerEvent('esx_worek:zdejmij')
AddEventHandler('esx_worek:zdejmij', function(xxdd)
    TriggerClientEvent('esx_worek:zdejmijc', xxdd)
end)



ESX.RegisterUsableItem('handcuffs', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('diagu:MenuKajdanek', _source)
end)


RegisterServerEvent('diagu_kajdanki_zakuj')
AddEventHandler('diagu_kajdanki_zakuj', function(target, head)
	local xPlayer = ESX.GetPlayerFromId(source)		

	TriggerClientEvent('diagu_kajdaki_client', target, head)
end)



RegisterServerEvent('diagu_kajdanki_drag')
AddEventHandler('diagu_kajdanki_drag', function(target)
	TriggerClientEvent('diagu_kajdanki_drag_client', target, source)
	
	TriggerClientEvent('esx:showNotification', source, 'Eskorta ('..target..')')
	TriggerClientEvent('esx:showNotification', target, 'Eskorta przez ('..source..')')
end)


RegisterServerEvent('diagu_kajdanki_put_in_vehicle')
AddEventHandler('diagu_kajdanki_put_in_vehicle', function(target)
	TriggerClientEvent('diagu_kajdanki_put_in_vehicle_client', target)
	
	TriggerClientEvent('esx:showNotification', source, 'Wsadzasz do pojazdu ('..target..')')
	TriggerClientEvent('esx:showNotification', target, 'Zostałeś/aś wrzycony/a do pojazdu przez ('..source..')')
end)



RegisterServerEvent('diagu_kajdanki_out_the_vehicle')
AddEventHandler('diagu_kajdanki_out_the_vehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	
	TriggerClientEvent('diagu_kajdanki_out_the_vehicle_client', target)

	TriggerClientEvent('esx:showNotification', source, 'Wyciągasz z pojazdu ('..target..')')
	TriggerClientEvent('esx:showNotification', target, 'Zostałeś/aś wyciągnięty/a z pojazdu przez ('..source..')')
end)



RegisterServerEvent('diagu_zabierz_item')
AddEventHandler('diagu_zabierz_item', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	TriggerClientEvent('esx:showNotification', target, "-".. " " .. amount .." " .. itemName .." "..  "(id".. " " .. source .. ")"  )
	TriggerClientEvent('esx:showNotification', source, "+".. " " .. amount .." " .. itemName .." "..  "(id".. " " .. target .. ")"  )

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
	


		if targetItem.count > 0 and targetItem.count <= amount then
		
	
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then

			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				

			end
		else
		
		end

	elseif itemType == 'item_account' then
		TriggerClientEvent('esx:showNotification', target, "test")
		TriggerClientEvent('esx:showNotification',target, "-" .. itemName)
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

	

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		TriggerClientEvent('esx:showNotification', target, "test")
		TriggerClientEvent('esx:showNotification', target, "-" .. itemName)
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

	
	end
end)




