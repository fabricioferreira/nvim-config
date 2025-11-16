local project_root = vim.fs.root(0, { "gradlew", ".git", "mvnw", "pom.xml" })
if project_root == "" then
  return
end

local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(project_root, ":p:h:t")
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local jdtls_cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.idl",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xms1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  "-jar", mason_path .. "/plugins/org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar",
  "-configuration", mason_path .. "/config_mac",
  "-data", workspace_dir,
}

local config = {
	name = "jdtls",
	cmd = jdtls_cmd,
	root_dir = project_root,
	settings = {
		java = {
      configuration = { updateBuildConfiguration = "interactive" },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
      completion = { favoriteStaticMembers =  {
        "org.springframework.util.Assert.*",
        "org.springframework.beans.factory.annotation.*"
      } },
      contentProvider = { preferred = "fernflower" },
    },
	},
	init_options = {
		bundles = {},
	},
}
require("jdtls").start_or_attach(config)
