local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local cfg = module("vrp","cfg/groups")
local groups = cfg.groups

local webhookadm = "SEUWEBHOOKAQ1"
local webhookcopom = "SEUWEBHOOKAQ2"
local webhookins = "SEUWEBHOOKAQ3"

local webponto = "SEUWEBHOOKAQ4"
local webhookwl = "SEUWEBHOOKAQ5"

local webhookcds = "SEUWEBHOOKAQ6"


function SendWebhookMessage(webhook,message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end
RegisterCommand('rcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"wl.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		
		local msg = "[] = x="..x..", y="..y..", z="..z..""
        SendWebhookMessage(webhookcds,msg)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			TriggerClientEvent('deletarveiculo',source,vehicle)
			local msg = "```[ADMINISTRAÇÃO] ["..source.."]["..user_id.."] "..identity.name.." "..identity.firstname.." deletou um veículo .```"
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEVEH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteveh")
AddEventHandler("trydeleteveh",function(index)
	TriggerClientEvent("syncdeleteveh",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteped")
AddEventHandler("trydeleteped",function(index)
	TriggerClientEvent("syncdeleteped",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
	TriggerClientEvent("syncdeleteobj",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNAR ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
local qtdAmmunition = 250
local itemlist = {
    ["WEAPON_COMBATPISTOL"] = { arg = "glock" },
    ["WEAPON_ASSAULTRIFLE"] = { arg = "ak" },
	["WEAPON_ASSAULTSMG"] = { arg = "asmg" },
	["WEAPON_SPECIALCARBINE"] = { arg = "parafal" }
}

RegisterCommand('arma',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"owner.permissao") then
        if args[1] then
            for k,v in pairs(itemlist) do
                if v.arg == args[1] then
                    result = k
                    vRPclient.giveWeapons(source,{[result] = { ammo = qtdAmmunition }})
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"owner.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			TriggerClientEvent('reparar',source,vehicle)
			
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." reparou um veículo .```"
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limparea',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"limpar.permissao") then
		TriggerClientEvent("syncarea",-1,x,y,z)
		local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." limpou area .```"
        SendWebhookMessage(webhookadm,msg)
		
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /TP OUTRA PESSOA PARA O TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptoway',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nuser_id = vRP.getUserSource(parseInt(args[1]))
    if vRP.hasPermission(user_id,"owner.permissao") then
        TriggerClientEvent('tptoway',nuser_id)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			local identity44 = vRP.getUserIdentity(parseInt(args[1]))
			if nplayer then
				vRPclient.killGod(nplayer)
				vRPclient.setHealth(nplayer, 400)
				local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." deu vida para ["..parseInt(args[1]).."]"..identity44.name.." "..identity44.firstname.." .```"
                SendWebhookMessage(webhookadm,msg)
			end
		else
			vRPclient.killGod(source)
			vRPclient.setHealth(source, 400)
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." recuperou sua vida .```"
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hash',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			TriggerClientEvent('vehash',source,vehicle)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"owner.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			TriggerClientEvent('vehtuning',source,vehicle)
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." tuning is vehicle .```"
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"wl.permissao")  then
		if args[1] then
		    local identity44 = vRP.getUserIdentity(args[1])
			vRP.setWhitelisted(parseInt(args[1]),true)
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." liberou whitlist do ID:"..parseInt(args[1]).."  .```"
            SendWebhookMessage(webhookwl,msg)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--/matar
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('matar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.setHealth(nplayer,1)
            end
        else
            vRPclient.setHealth(source,10)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--/dv para outra pessoa
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rdv',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nuser_id = vRP.getUserSource(parseInt(args[1]))
    if vRP.hasPermission(user_id,"admin.permissao") then
        local vehicle = vRPclient.getNearestVehicle(nuser_id,2)
        if vehicle then
            TriggerClientEvent('deletarveiculo',nuser_id,vehicle)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"wl.permissao") then
		if args[1] then
		    local identity44 = vRP.getUserIdentity(args[1])
			vRP.setWhitelisted(parseInt(args[1]),false)
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." bloqueou whitlist do ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```"
            SendWebhookMessage(webhookwl,msg)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao")  then
		if args[1] then
		    local identity44 = vRP.getUserIdentity(args[1])
			local id = vRP.getUserSource(parseInt(args[1]))
			if id then
				local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." kickou o ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```"
                SendWebhookMessage(webhookadm,msg)
				TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." kickou o ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname..".")
				vRP.kick(id,"Você foi expulso da cidade.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or  vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] then
		    local identity44 = vRP.getUserIdentity(args[1])
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." baniu o ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```"
            SendWebhookMessage(webhookadm,msg)
			
			TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." baniu o ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .")
			
			vRP.setBanned(parseInt(args[1]),true)
			
			vRP.kick(parseInt(args[1]),"Você foi banido da cidade.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),false)
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." desbaniu o ID "..args[1].." .```"
            SendWebhookMessage(webhookadm,msg)
			TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." desbaniu o ID "..args[1].." .")
			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"owner.permissao") then
	    if parseInt(args[1]) >= 1 and parseInt(args[1]) <= 10000 then
	        vRP.giveMoney(user_id,parseInt(args[1]))
	        local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." pegou R$"..args[1].." .```"
            SendWebhookMessage(webhookadm,msg)
			
		    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." pegou R$"..args[1].." .")
		end
	end
end)
RegisterCommand('mone',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"owner.permissao") then
	        vRP.giveMoney(user_id,parseInt(args[1]))
	        local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." pegou R$"..args[1].." .```"
            SendWebhookMessage(webhookadm,msg)
			
		    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." pegou R$"..args[1].." .")

	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"wl.permissao") then
		vRPclient.toggleNoclip(source)
		local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." Ativou/Desativou NoClip```"
        SendWebhookMessage(webhookadm,msg)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:",x..","..y..","..z)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
		    local identity44 = vRP.getUserIdentity(args[1])
			vRP.addUserGroup(parseInt(args[1]),args[2])
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." setou "..args[2].." para "..identity44.name.." "..identity44.firstname.." .```" 
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
			vRP.removeUserGroup(parseInt(args[1]),args[2])
		end
	end
end)
RegisterCommand('trazer',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao")  then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)
RegisterCommand('ir',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao")  then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adminevent',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local idjogador = vRP.prompt(source, "Qual id do jogador?", "")
		local titulo = vRP.prompt(source, "Titulo da mensagem que enviar para o mesmo?", "")
		local mensagem = vRP.prompt(source, "Mensagem que enviar para o mesmo?", "")
		local player = vRP.getUserSource(tonumber(idjogador))
		TriggerClientEvent('announce123', player, titulo, mensagem)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- cOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cobject',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"owner.permissao") then
		TriggerClientEvent('cobject',source,args[1],args[2])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"wl.permissao") then
		TriggerClientEvent('tptoway',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"supervisor.permissao") then
		if args[1] then
			TriggerClientEvent('spawnarveiculo',source,args[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		TriggerClientEvent('delnpcs',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(255,50,50,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 10%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: Administrador")
		SetTimeout(60000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)

RegisterCommand('tpall', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"supervisor.permissao") then
        local rusers = vRP.getUsers()
        for k,v in pairs(rusers) do
            local rsource = vRP.getUserSource(k)
            if rsource ~= source then
                vRPclient.teleport(rsource,x,y,z)
				local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." puxou todos até ele .```"
                SendWebhookMessage(webhookadm,msg)
            end
        end
    end
end)
RegisterCommand('reall', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"supervisor.permissao") then
        local rusers = vRP.getUsers()
        for k,v in pairs(rusers) do
            local rsource = vRP.getUserSource(k)
            vRPclient.setHealth(rsource, 200)
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." deu vida a todos online .```"
            SendWebhookMessage(webhookadm,msg)
        end
    end
end)
RegisterCommand('convida2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local groupv = vRPN.getUserGroupByType(user_id,"job")
	if args[1] and args[1] ~= user_id then
	    if vRP.hasGroup(user_id, "Lider")then
	        local ok = vRP.request(parseInt(args[1]),""..identity.name.." "..identity.firstname..""..identity.name.." "..identity.firstname.."te convidou para "..groupv.." , deseja aceitar ?",60)
		    if ok then
				vRP.addUserGroup(parseInt(args[1]), groupv)
			end
		end
	end
end)
RegisterCommand('convidar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local id = vRP.getUserSource(parseInt(args[1]))
	if id then
	    if vRP.hasPermission(user_id,"motoclub.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local aok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para MotoClub , deseja aceitar ?",60)
		    if aok then
				vRP.addUserGroup(parseInt(args[1]),"Motoclub")
			end
		end
		if vRP.hasPermission(user_id,"forcanacional.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local aok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Força Nacional , deseja aceitar ?",60)
		    if aok then
				vRP.addUserGroup(parseInt(args[1]),"Forca")
			end
		end
		if vRP.hasPermission(user_id,"vermelhos.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local bok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para P.C.C , deseja aceitar ?",60)
		    if bok then
	            vRP.addUserGroup(parseInt(args[1]),"P.C.C")
			end
		end
		if vRP.hasPermission(user_id,"azul.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local cok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Azul , deseja aceitar ?",60)
		    if cok then
	            vRP.addUserGroup(parseInt(args[1]),"Azul")
			end
		end
		if vRP.hasPermission(user_id,"amarelos.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local dok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para T.C.P , deseja aceitar ?",60)
		    if dok then
	            vRP.addUserGroup(parseInt(args[1]),"T.C.P")
			end
		end
		if vRP.hasPermission(user_id,"verdes.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local eok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para C.V , deseja aceitar ?",60)
		    if eok then
	            vRP.addUserGroup(parseInt(args[1]),"C.V")
			end
		end
		if vRP.hasPermission(user_id,"roxos.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local fok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para A.D.A , deseja aceitar ?",60)
		    if fok then
	            vRP.addUserGroup(parseInt(args[1]),"A.D.A")
			end
		end
		if vRP.hasPermission(user_id,"mafia.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local gok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Mafia , deseja aceitar ?",60)
		    if gok then
	            vRP.addUserGroup(parseInt(args[1]),"Mafia")
			end
		end
		if vRP.hasPermission(user_id,"milicia.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local gok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Milicia , deseja aceitar ?",60)
		    if gok then
	            vRP.addUserGroup(parseInt(args[1]),"Milicia")
			end
		end
		if vRP.hasPermission(user_id,"yakuza.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local hok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Yakuza , deseja aceitar ?",60)
		    if hok then
	            vRP.addUserGroup(parseInt(args[1]),"Yakuza")
			end
		end
		if vRP.hasPermission(user_id,"pm.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local iok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Policia Militar , deseja aceitar ?",60)
		    if iok then
	            vRP.addUserGroup(parseInt(args[1]),"Policia")
			end
		end
		if vRP.hasPermission(user_id,"rota.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local ok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para ROTA , deseja aceitar ?",60)
		    if ok then
	            vRP.addUserGroup(parseInt(args[1]),"ROTA")
			end
		end
		if vRP.hasPermission(user_id,"paramedico.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local ok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Medico , deseja aceitar ?",60)
		    if ok then
	            vRP.addUserGroup(parseInt(args[1]),"Paramedico")
			end
		end
		if vRP.hasPermission(user_id,"benny.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local ok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Bennys , deseja aceitar ?",60)
		    if ok then
	            vRP.addUserGroup(parseInt(args[1]),"Bennys")
			end
		end
		if vRP.hasPermission(user_id,"vanilla.permissao") and vRP.hasGroup(user_id, "Lider")then
	        local ok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para Vanilla , deseja aceitar ?",60)
		    if ok then
	            vRP.addUserGroup(parseInt(args[1]),"Vanilla")
			end
		end
	end
end)
RegisterCommand('retirar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if args[1] and args[1] ~= user_id then
	    if vRP.hasPermission(user_id,"motoclub.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"Motoclub")
		end
		if vRP.hasPermission(user_id,"forcanacional.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"Forca")
		end
		if vRP.hasPermission(user_id,"vermelhos.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"P.C.C")
		end
		if vRP.hasPermission(user_id,"azul.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"Azul")
		end
		if vRP.hasPermission(user_id,"amarelos.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"T.C.P")
		end
		if vRP.hasPermission(user_id,"verdes.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"C.V")
		end
		if vRP.hasPermission(user_id,"roxos.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"A.D.A")
		end
		if vRP.hasPermission(user_id,"mafia.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"Corleone")
		end
		if vRP.hasPermission(user_id,"pm.permissao") and vRP.hasGroup(user_id, "Lider")then
			vRP.removeUserGroup(parseInt(args[1]),"Policia")
		end
		if vRP.hasPermission(user_id,"rota.permissao") and vRP.hasGroup(user_id, "Lider")then
		    vRP.removeUserGroup(parseInt(args[1]),"ROTA")
		end
		if vRP.hasPermission(user_id,"vanilla.permissao") and vRP.hasGroup(user_id, "Lider")then
		    vRP.removeUserGroup(parseInt(args[1]),"Vanilla")
		end
		if vRP.hasPermission(user_id,"yakuza.permissao") and vRP.hasGroup(user_id, "Lider")then
		    vRP.removeUserGroup(parseInt(args[1]),"yakuza")
		end
		if vRP.hasPermission(user_id,"paramedico.permissao") and vRP.hasGroup(user_id, "Lider")then
		    vRP.removeUserGroup(parseInt(args[1]),"Paramedico")
		end
		if vRP.hasPermission(user_id,"benny.permissao") and vRP.hasGroup(user_id, "Lider")then
		    vRP.removeUserGroup(parseInt(args[1]),"Bennys")
		end
		if vRP.hasPermission(user_id,"milicia.permissao") and vRP.hasGroup(user_id, "Lider")then
		    vRP.removeUserGroup(parseInt(args[1]),"Bennys")
		end
	end
end)
RegisterCommand('corestabela',function(source,args,rawCommand)
    TriggerClientEvent('chatMessage',-1,"^1AA ^2BB ^3CC ^4DD ^5EE ^6FF ^7GG ^8HH ")
end)
RegisterCommand('darlider',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"supervisor.permissao") then
		if args[1] and args[2] then
		    local identity44 = vRP.getUserIdentity(args[1])
			vRP.addUserGroup(parseInt(args[1]),args[2])
			-----------vRP.addUserGroup(parseInt(args[1]),"Lider") ----------- Comando que tava colocando o player em um grupo inexistente chamado lider
			
			TriggerClientEvent('chatMessage',-1,"^7[ADMINISTRAÇÃO] Admin ^9"..identity.name.." "..identity.firstname.."^7 setou lider de ^9"..args[2].."^7 para ^9["..args[1].."]"..identity44.name.." "..identity44.firstname.." ^7.")
			
			local msg = "```[ADMINISTRAÇÃO] Admin ["..user_id.."] "..identity.name.." "..identity.firstname.." setou lider de "..args[2].." para ["..args[1]"]"..identity44.name.." "..identity44.firstname.." .```" 
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)
RegisterCommand('tirarlider',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
			vRP.removeUserGroup(parseInt(args[1]),args[2])
			vRP.removeUserGroup(parseInt(args[1]),"Lider")
		end
	end
end)
RegisterCommand('tirarcnh',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"instrutor.permissao") then
		if args[1] then
			vRP.removeUserGroup(parseInt(args[1]),"Carta")
		end
	end
end)
RegisterCommand('tirarporte',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		if args[1] then
			vRP.removeUserGroup(parseInt(args[1]),"Porte")
		end
	end
end)
RegisterCommand('cnh',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"instrutor.permissao") then
		if args[1] then
		    local identity44 = vRP.getUserIdentity(args[1])
			vRP.addUserGroup(parseInt(args[1]),"Carta")
			local msg = "```[CARTA] Instrutor ["..user_id.."] "..identity.name.." "..identity.firstname.." deu CNH para "..identity44.name.." "..identity44.firstname.." .```" 
            SendWebhookMessage(webhookins,msg)
		end
	end
end)
RegisterCommand('porte',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"policia.permissao") then
		if args[1] then
		    local identity44 = vRP.getUserIdentity(args[1])
			vRP.addUserGroup(parseInt(args[1]),"Porte")
			local msg = "```[PORTE] Policial ["..user_id.."] "..identity.name.." "..identity.firstname.." deu porte de armas para "..identity44.name.." "..identity44.firstname.." .```" 
            SendWebhookMessage(webhookcopom,msg)
		end
	end
end)
RegisterCommand('tpjesus',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		vRPclient.teleport(source,-198.86,-739.142,216.90)
	end
end)
RegisterCommand('convidaradmin',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"owner.permissao") then
	    local id = vRP.getUserSource(parseInt(args[1]))
		if args[1] then
			if id then
	        local ok = vRP.request(id,""..identity.name.." "..identity.firstname.." te convidou para ser administrador , deseja aceitar ?",60)
			if ok then
		        local identity44 = vRP.getUserIdentity(args[1])
			    vRP.addUserGroup(parseInt(args[1]),"suporte")
			    local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." setou suporte para ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```" 
                SendWebhookMessage(webhookadm,msg)
			    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." setou suporte para ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .")
		    end
			end
		end
	end
end)
RegisterCommand('promoveradmin',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"owner.permissao") then
		if args[1] then
		    local identity44 = vRP.getUserIdentity(args[1])
			if vRP.hasGroup(parseInt(args[1]), "suporte") or vRP.hasGroup(parseInt(args[1]), "suportepaisana")then
			    vRP.addUserGroup(parseInt(args[1]),"moderador")
				vRP.removeUserGroup(parseInt(args[1]),"suporte")
			    local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a moderador ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```" 
                SendWebhookMessage(webhookadm,msg)
				TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a moderador ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .")
			
			elseif vRP.hasGroup(parseInt(args[1]), "moderador") or vRP.hasGroup(parseInt(args[1]), "moderadorpaisana")then
			    vRP.addUserGroup(parseInt(args[1]),"administrador")
				vRP.removeUserGroup(parseInt(args[1]),"moderador")
			    local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a administrador ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```" 
                SendWebhookMessage(webhookadm,msg)
				TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a administrador ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .")
			
			elseif vRP.hasGroup(parseInt(args[1]), "administrador") or vRP.hasGroup(parseInt(args[1]), "administradorpaisana")then
			    vRP.addUserGroup(parseInt(args[1]),"dsupervisor")
				vRP.removeUserGroup(parseInt(args[1]),"administrador")
			    local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a supervisor ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```" 
                SendWebhookMessage(webhookadm,msg)
				TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a supervisor ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .")
			
			elseif vRP.hasGroup(parseInt(args[1]), "dsupervisor") or vRP.hasGroup(parseInt(args[1]), "dsupervisorpaisana")then
			    vRP.addUserGroup(parseInt(args[1]),"dono")
				vRP.removeUserGroup(parseInt(args[1]),"dsupervisor")
			    local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a dono ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .```" 
                SendWebhookMessage(webhookadm,msg)
				TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." promoveu a dono ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." .")
			end
		end
	end
end)
RegisterCommand('removeradmin',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"owner.permissao") then
		if args[1] then
		   local identity44 = vRP.getUserIdentity(parseInt(args[1]))
		   
		   vRP.removeUserGroup(parseInt(args[1]),"suporte")
		   vRP.removeUserGroup(parseInt(args[1]),"moderador")
		   vRP.removeUserGroup(parseInt(args[1]),"administrador")
		   vRP.removeUserGroup(parseInt(args[1]),"dsupervisor")
		   vRP.removeUserGroup(parseInt(args[1]),"dono")
		   
		   local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." removeu ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." da staff .```" 
           SendWebhookMessage(webhookadm,msg)
		   TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." removeu ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." da administração.")
		end
	end
end)
RegisterCommand('atendimentos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	------------------------------------------------------------------------------------------------------------------------------------------
	if vRP.hasGroup(user_id, "dono") then
	    vRP.addUserGroup(user_id,"donopaisana")
		vRP.removeUserGroup(user_id,"dono")
		
		local msg = "```[ADMINISTRAÇÃO] Dono ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Dono ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento.")
		
	elseif vRP.hasGroup(user_id, "donopaisana") then
	    vRP.addUserGroup(user_id,"dono")
		vRP.removeUserGroup(user_id,"donopaisana")
		
		local msg = "```[ADMINISTRAÇÃO] Dono ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Dono ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento.")
	end
	-----------------------------------------------------------------------------------------------------------------------------------------
	if vRP.hasGroup(user_id, "supervisor") then
	    vRP.addUserGroup(user_id,"supervisorpaisana")
		vRP.removeUserGroup(user_id,"supervisor")
		
		local msg = "```[ADMINISTRAÇÃO] Supervisor ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Supervisor ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento.")
		
	elseif vRP.hasGroup(user_id, "supervisorpaisana") then
	    vRP.addUserGroup(user_id,"supervisor")
		vRP.removeUserGroup(user_id,"supervisorpaisana")
		
		local msg = "```[ADMINISTRAÇÃO] Supervisor ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Supervisor ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento.")
	end
	-----------------------------------------------------------------------------------------------------------------------------------------
	if vRP.hasGroup(user_id, "administrador") then
	    vRP.addUserGroup(user_id,"administradorpaisana")
		vRP.removeUserGroup(user_id,"administrador")
		
		local msg = "```[ADMINISTRAÇÃO] Administrador ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Administrador ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento.")
		
	elseif vRP.hasGroup(user_id, "administradorpaisana") then
	    vRP.addUserGroup(user_id,"administrador")
		vRP.removeUserGroup(user_id,"administradorpaisana")
		
		local msg = "```[ADMINISTRAÇÃO] Administrador ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Administrador ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento.")
	end
	-----------------------------------------------------------------------------------------------------------------------------------------
	if vRP.hasGroup(user_id, "moderador") then
	    vRP.addUserGroup(user_id,"moderadorpaisana")
		vRP.removeUserGroup(user_id,"moderador")
		
		local msg = "```[ADMINISTRAÇÃO] Moderador ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Moderador ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento.")
		
	elseif vRP.hasGroup(user_id, "moderadorpaisana") then
	    vRP.addUserGroup(user_id,"moderador")
		vRP.removeUserGroup(user_id,"moderadorpaisana")
		
		local msg = "```[ADMINISTRAÇÃO] Moderador ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Moderador ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento.")
	end	
	-----------------------------------------------------------------------------------------------------------------------------------------
	if vRP.hasGroup(user_id, "suporte") then
	    vRP.addUserGroup(user_id,"suportepaisana")
		vRP.removeUserGroup(user_id,"suporte")
		
		local msg = "```[ADMINISTRAÇÃO] Suporte ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Suporte ["..user_id.."] "..identity.name.." "..identity.firstname.." terminou atendimento.")
		
	elseif vRP.hasGroup(user_id, "suportepaisana") then
	    vRP.addUserGroup(user_id,"suporte")
		vRP.removeUserGroup(user_id,"suportepaisana")
		
		local msg = "```[ADMINISTRAÇÃO] Suporte ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento . ```" 
        SendWebhookMessage(webponto,msg)
	    TriggerClientEvent('chatMessage',-1,"[ADMINISTRAÇÃO] Suporte ["..user_id.."] "..identity.name.." "..identity.firstname.." iniciou atendimento.")
	end	
	
end)	
RegisterCommand('darvale',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if args[1] and args[2] then
	    if vRP.hasPermission(user_id,"owner.permissao") then
	        TriggerClientEvent("Notify",source,"sucesso","Voçê deu vale para um jogador")
	        TriggerClientEvent("Notify",args[1],"sucesso","Voçê recebeu vale de um jogador")
		    vRP.giveInventoryItem(parseInt(args[1]),"vale",parseInt(args[2]))
		
		    local identity44 = vRP.getUserIdentity(args[1])
		
		    local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." deu para ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." "..args[2].." vale(s)```" 
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)	

RegisterCommand('limparinv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if args[1]  then
	    if vRP.hasPermission(user_id,"owner.permissao") then
		    
		    vRP.clearInventory(parseInt(args[1]))
			
			TriggerClientEvent("Notify",source,"sucesso","Limpou inventario do jogador.")
	        TriggerClientEvent("Notify",parseInt(args[1]),"sucesso","Limparam seu inventario")
		    local identity44 = vRP.getUserIdentity(args[1])
		
		    local msg = "```[ADMINISTRAÇÃO] ["..user_id.."] "..identity.name.." "..identity.firstname.." limpou inventario de ["..parseInt(args[1]).."] "..identity44.name.." "..identity44.firstname.." ```" 
            SendWebhookMessage(webhookadm,msg)
		end
	end
end)
RegisterCommand('debug',function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"owner.permissao") or vRP.hasPermission(user_id,"owner.permissao") then
            TriggerClientEvent("ToggleDebug",player)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Ver roupas
-----------------------------------------------------------------------------------------------------------------------------------------


local player_customs = {}

RegisterCommand('vroupas',function(source,args,rawCommand)
    local custom = vRPclient.getCustomization(source)
    if player_customs[source] then -- hide
      player_customs[source] = nil
      vRPclient._removeDiv(source,"customization")
    else -- show
      local content = ""
    for k,v in pairs(custom) do
        content = content..k.." => "..json.encode(v).."<br />" 
      end
        player_customs[source] = true
      vRPclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content)
 end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local presets = {
	["ROTA1"] = {
	    [1885233650] = {
		    [3] = {0,0,0},
		    [4] = {31,2,0},
		    [6] = {24,0,0},
		    [7] = {1,0,0},
		    [8] = {129,0,0},
		    [9] = {7,0,0},
		    [10] = {0,0,0},
		    [11] = {93,1,0},
		    ["p0"] = {28,1,0},
		    ["p6"] = {-1,0}
		}
	},
	["ROTA2"] = {
	    [1885233650] = {
		    [3] = {6,0,0},
		    [4] = {59,9,0},
		    [5] = {0,0,0},
		    [6] = {24,0,0},
		    [7] = {1,0,0},
		    [8] = {74,3,0},
		    [10] = {0,0,0},
		    [11] = {76,1,0},
		    ["p6"] = {-1,0},
		}
	},
	["FN"] = {
	    [1885233650] = {
		    [3] = {30,0,0},
		    [4] = {84,0,0},
		    [6] = {33,0,0},
		    [7] = {1,0,0},
		    [8] = {97,0,0},
		    [11] = {186,0,0},			
		    ["p2"] = {1,0,0}
		}
	},
	["Policia"] = {
	    [1885233650] = {
		    [3] = {0,0,0},
		    [4] = {25,1,0},
		    [5] = {0,0,0},
		    [6] = {51,0,0},
		    [7] = {1,0,0},
		    [8] = {129,0,0},
	    	[9] = {11,0,2},
		    [10] = {0,0,0},
		    [11] = {93,0,0},
		    ["p0"] = {114,0,0},
		    ["p6"] = {-1,0}
		}
	},
	["PMCOMANDANTE"] = {
	    [1885233650] = {
	        [3] = {0,0,0},
		    [4] = {31,2,0},
		    [5] = {0,0,0},
		    [6] = {24,0,0},
		    [7] = {1,0,0},
		    [8] = {16,0,0},
		    [10] = {0,0,0},
		    [11] = {93,0,0},
		    ["p0"] = {28,2,0},
		    ["p6"] = {-1,0}
		}
    }
}

RegisterCommand('preset',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"pm.permissao") or vRP.hasPermission(user_id,"owner.permissao") then
		if args[1] then
			local custom = presets[tostring(args[1])]
			if custom then
				local old_custom = vRPclient.getCustomization(source)
				local idle_copy = {}

				idle_copy = vRP.save_idle_custom(source,old_custom)
				idle_copy.modelhash = nil

				for l,w in pairs(custom[old_custom.modelhash]) do
					idle_copy[l] = w
				end
				vRPclient._setCustomization(source,idle_copy)
			end
		else
			vRP.removeCloak(source)
		end
	end
end)
