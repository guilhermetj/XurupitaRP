local cfg = {}

cfg.groups = {
    ["donopaisana"] = { "paisanadono.permissao" },
	["dono"] = {
	    "supervisor.permissao",
		"admin.permissao",
		"dv.permissao",
		"owner.permissao",
		"wl.permissao",
		"owner.batman",
		"chamado.adm"
	},
	["dsupervisorpaisana"] = { "supervisorpaisana.permissao" },
	["dsupervisor"] = {
	    "supervisor.permissao",
		"admin.permissao",
		"dv.permissao",
		"owner.permissao",
		"wl.permissao",
		"owner.batman",
		"chamado.adm"	
	},
	["administradorpaisana"] = { "administradorpaisana.permissao" },
	["administrador"] = {
		"supervisor.permissao",
		"admin.permissao",
		"dv.permissao",
		"owner.permissao",
		"wl.permissao",
		"owner.batman",
		"chamado.adm"	
	},
	["moderadorpaisana"] = { "moderadorpaisana.permissao" },
	["moderador"] = {
		"supervisor.permissao",
		"admin.permissao",
		"dv.permissao",
		"owner.permissao",
		"wl.permissao",
		"owner.batman",
		"chamado.adm"
	},
	["suportepaisana"] = { "suportepaisana.permissao" },
	["suporte"] = {
		"wl.permissao",
		"limpar.permissao"
	},

	["Policia"] = {
		_config = {
			title = "Policia Militar",
			gtype = "job"
		},
		"pm.permissao",
		"dv.permissao",
		"policia.permissao",
		"xerife.permissao",
		"radiopolicia.permissao",
		"polpar.permissao"
	},
	["Forca"] = {
		_config = {
			title = "Força Nacional",
			gtype = "job"
		},
		"forcanacional.permissao",
		"policia.permissao",
		"xerife.permissao",
		"radiopolicia.permissao",
		"polpar.permissao"
	},
	["PaisanaForca"] = {
		_config = {
			title = "Paisana Força Nacional",
			gtype = "job"
		},
		"paisanaforcanacional.permissao"
	},
	["ROTA"] = {
		_config = {
			title = "ROTA",
			gtype = "job"
		},
		"rota.permissao",
		"policia.permissao",
		"xerife.permissao",
		"radiopolicia.permissao",
		"polpar.permissao"
	},
	["Paramedico"] = {
		_config = {
			title = "Paramedico",
			gtype = "job"
		},
		"paramedico.permissao",
		"membros.permissao",
		"dv.permissao",
		"polpar.permissao"
	},
	["Advogado"] = {
		_config = {
			title = "Advogado",
			gtype = "job"
		},
		"Advogado.permissao",
		"membros.permissao",
		"polpar.permissao"
	},
	["Instrutor"] = {
		_config = {
			title = "Instrutor",
			gtype = "job"
		},
		"instrutor.permissao"
	},
	["PaisanaPolicia"] = {
		_config = {
			title = "PaisanaPolicia",
			gtype = "job"
		},
		"paisanapolicia.permissao"
	},
	["PaisanaROTA"] = {
		_config = {
			title = "ROTApaisana",
			gtype = "job"
		},
		"paisanarota.permissao"
	},
	["PaisanaParamedico"] = {
		_config = {
			title = "PaisanaParamedico",
			gtype = "job"
		},
		"paisanaparamedico.permissao"
	},
	["Bennys"] = {
		_config = {
			title = "Bennys",
			gtype = "job"
		},
		"benny.permissao",
		"mecanico.permissao",
		"reparar.permissao"
	},
	["Mecanico"] = {
		_config = {
			title = "Mecanico",
			gtype = "job"
		},
		"mecanico.permissao",
		"reparar.permissao"
	},
	["PaisanaBennys"] = {
		_config = {
			title = "PaisanaBennys",
			gtype = "job"
		},
		"paisanabennys.permissao"
	},
	["Taxista"] = {
		_config = {
			title = "Taxista",
			gtype = "job"
		},
		"taxista.permissao"
	},
	["PaisanaTaxista"] = {
		_config = {
			title = "PaisanaTaxista",
			gtype = "job"
		},
		"paisanataxista.permissao"
	},
	["Alertas"] = {
		_config = {
			title = "Alertas"
		},
		"alertas.permissao"
	},

	["Vendedor"] = {
	    _config = {
		title = "Vendedor",
		gtype = "job"
	   },
	   "vendedor.permissao"
	},
	--------------------------------------------------------- VIP -----------------------------------------------------
	["Ouro"] = {
		_config = {
			title = "Vip Ouro",
			gtype = "vip"
		},
		"ouro.permissao",
		"conce.vip",
		"vip.permissao",
		"mochila.permissao"
	},	
	["Prata"] = {
		_config = {
			title = "Vip Prata",
			gtype = "vip"
		},
		"prata.permissao",
		"conce.vip",
		"vip.permissao",
		"mochila.permissao"
	},
	["Bronze"] = {
		_config = {
			title = "Vip Bronze",
			gtype = "vip"
		},
		"bronze.permissao",
		"conce.vip",
		"vip.permissao",
		"mochila.permissao"
    },
	["Diamante"] = {
		_config = {
			title = "Vip Diamante",
			gtype = "vip"
		},
		"Diamante.permissao",
		"conce.vip",
		"vip.permissao",
		"mochila.permissao"
	},
	["Ruby"] = {
		_config = {
			title = "Vip Ruby",
			gtype = "vip"
		},
		"Ruby.permissao",
		"conce.vip",
		"vip.permissao",
		"heli.permissao",
		"mochila.permissao"
	},	
	["Supremo"] = {
		_config = {
			title = "Vip Supremo",
			gtype = "vip"
		},
		"Supremo.permissao",
		"conce.vip",
		"vip.permissao",
		"heli.permissao",
		"mochila.permissao"
	},	
	-------------------------------------------------------------------------- FACÇOES ----------------------------------------------------------------------------
	["Motoclub"] = {
		_config = {
			title = "Motoclub",
			gtype = "job"
		},
		"motoclub.permissao",
		"entrada.permissao"
	},
	["P.C.C"] = {
		_config = {
			title = "P.C.C",
			gtype = "job"
		},
		"meta.permissao",
		"vermelhos.permissao",
		"trafico.permissao"
	},
	["Okaida"] = {
		_config = {
			title = "Okaida",
			gtype = "job"
		},
		"azul.permissao",
		"crack.permissao",
		"trafico.permissao"
	},
	["T.C.P"] = {
		_config = {
			title = "T.C.P",
			gtype = "job"
		},
		"cocaina.permissao",
		"amarelos.permissao",
		"trafico.permissao"
	},
	["C.V"] = {
		_config = {
			title = "C.V",
			gtype = "job"
		},
		"maconha.permissao",
		"verdes.permissao",
		"trafico.permissao"
	},
	["A.D.A"] = {
		_config = {
			title = "A.D.A",
			gtype = "job"
		},
		"lsd.permissao",
		"roxos.permissao"
	},
	["Mafia"] = {
		_config = {
			title = "Mafia",
			gtype = "job"
		},
		"mafia.permissao"
	},
	["Milicia"] = {
		_config = {
			title = "Milicia",
			gtype = "job"
		},
		"milicia.permissao"
	},
	["Vanilla"] = {
		_config = {
			title = "Vanilla",
			gtype = "job"
		},
		"vanilla.permissao"
	},
	-------------------------------------- YAKUZA --------------------------------------------------------------
	["Yakuza"] = {
	    _config = {
		title = "Mafia Yakuza",
		gtype = "job"
	    },
	    "yakuza.permissao",
	},
	["Carta"] = { },
	["Porte"] = { },
	["Lider"] = { },
	
	
	
	
	["2"] = { },
	["3"] = { },
	["4"] = { },
	["5"] = { },
	["6"] = { },
	["7"] = { },
	["8"] = { },
	["9"] = { },
	["10"] = { },
	["11"] = { },
	["12"] = { },
	["13"] = { },
	["14"] = { },
	["15"] = { },
	["16"] = { },
	
	
	
}


cfg.users = {
    [1] = { "dono" },
	[2] = { "dono" },
}

cfg.selectors = {}

return cfg