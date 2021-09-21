lspconfig = require'lspconfig'
require'lspconfig'.pylsp.setup{}
require'lspconfig'.terraformls.setup{}
lspconfig.tsserver.setup{}
lspconfig.rust_analyzer.setup{}

completion_callback = require'completion'.on_attach
lspconfig.tsserver.setup{on_attach=completion_callback}
lspconfig.rust_analyzer.setup{on_attach=completion_callback}
