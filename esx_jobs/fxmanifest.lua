fx_version 'cerulean'
games { 'gta5' }

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/br.lua',
  'locales/de.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'Config_esx_jobs.lua',
  'server/esx_jobs_sv.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/br.lua',
  'locales/de.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'Config_esx_jobs.lua',
  'jobs/casino.lua',
  --'jobs/diner.lua',
  -- 'jobs/mboubar.lua',
  --'jobs/liquordeli.lua',
  'jobs/chauffeur.lua',
  'jobs/armurerie.lua',
  'jobs/fisherman.lua',
  'jobs/fuel.lua',
  'jobs/beer.lua',
  'jobs/yellow.lua',
  -- 'jobs/tequi.lua',
  'jobs/comedy.lua',
  --'jobs/coffee.lua',
  --'jobs/nebevent.lua',
  'jobs/vigne.lua',
  'jobs/bahama.lua',
  'jobs/journaliste.lua',
  'jobs/bijoutier.lua',
  --'jobs/lost.lua',
  'jobs/tabac.lua',
  --'jobs/palace.lua',
  --'jobs/ambulance.lua',
  'jobs/event.lua',
  --'jobs/mecano.lua',
  'jobs/mecano2.lua',
  'jobs/epicerie.lua',
  'jobs/agriculteur.lua',
  'client/esx_jobs_cl.lua'
}