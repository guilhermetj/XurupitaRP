local cfg = {}

cfg.db = {
	driver = "ghmattimysql",
	host = "127.0.0.1",
	database = "vrp",
	user = "root",
	password = ""
}

cfg.whitelist = false -- Sem whitelist: false/ Com: true

return cfg