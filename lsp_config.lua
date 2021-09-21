lspconfig = require'lspconfig'
require'lspconfig'.pylsp.setup{}
require'lspconfig'.terraformls.setup{ filetypes = {"terraform", "tf"}}
require'lspconfig'.tsserver.setup{}

completion_callback = require'completion'.on_attach
