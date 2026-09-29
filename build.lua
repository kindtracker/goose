local PackagesPath = "/usr/local/share/lua/5.5/"

local Packages = {
	["lunar/vendors/json.lua"] = {
		Source = "vendors/lunar/package/vendors/json.lua",
		Install = PackagesPath .. "lunar/vendors/json.lua",
	},

	["lunar/vendors/url.lua"] = {
		Source = "vendors/lunar/package/vendors/url.lua",
		Install = PackagesPath .. "lunar/vendors/url.lua",
	},

	["lunar/vendors/pegasus/compress.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/compress.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/compress.lua",
	},

	["lunar/vendors/pegasus/log.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/log.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/log.lua",
	},

	["lunar/vendors/pegasus/response.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/response.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/response.lua",
	},

	["lunar/vendors/pegasus/handler.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/handler.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/handler.lua",
	},

	["lunar/vendors/pegasus/plugins/router.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/plugins/router.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/plugins/router.lua",
	},

	["lunar/vendors/pegasus/plugins/compress.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/plugins/compress.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/plugins/compress.lua",
	},

	["lunar/vendors/pegasus/plugins/downloads.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/plugins/downloads.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/plugins/downloads.lua",
	},

	["lunar/vendors/pegasus/plugins/files.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/plugins/files.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/plugins/files.lua",
	},

	["lunar/vendors/pegasus/plugins/tls.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/plugins/tls.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/plugins/tls.lua",
	},

	["lunar/vendors/pegasus/request.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/request.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/request.lua",
	},

	["lunar/vendors/pegasus/init.lua"] = {
		Source = "vendors/lunar/package/vendors/pegasus/init.lua",
		Install = PackagesPath .. "lunar/vendors/pegasus/init.lua",
	},

	["lunar/init.lua"] = {
		Source = "vendors/lunar/package/init.lua",
		Install = PackagesPath .. "lunar/init.lua",
	},

	["lunar/src/datatypes/color3.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/color3.lua",
		Install = PackagesPath .. "lunar/src/datatypes/color3.lua",
	},

	["lunar/src/datatypes/color4.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/color4.lua",
		Install = PackagesPath .. "lunar/src/datatypes/color4.lua",
	},

	["lunar/src/datatypes/udim2.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/udim2.lua",
		Install = PackagesPath .. "lunar/src/datatypes/udim2.lua",
	},

	["lunar/src/datatypes/cframe.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/cframe.lua",
		Install = PackagesPath .. "lunar/src/datatypes/cframe.lua",
	},

	["lunar/src/datatypes/udim.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/udim.lua",
		Install = PackagesPath .. "lunar/src/datatypes/udim.lua",
	},

	["lunar/src/datatypes/vector3.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/vector3.lua",
		Install = PackagesPath .. "lunar/src/datatypes/vector3.lua",
	},

	["lunar/src/datatypes/connection.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/connection.lua",
		Install = PackagesPath .. "lunar/src/datatypes/connection.lua",
	},

	["lunar/src/datatypes/signal.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/signal.lua",
		Install = PackagesPath .. "lunar/src/datatypes/signal.lua",
	},

	["lunar/src/datatypes/vector2.lua"] = {
		Source = "vendors/lunar/package/src/datatypes/vector2.lua",
		Install = PackagesPath .. "lunar/src/datatypes/vector2.lua",
	},

	["lunar/src/services/http-server.lua"] = {
		Source = "vendors/lunar/package/src/services/http-server.lua",
		Install = PackagesPath .. "lunar/src/services/http-server.lua",
	},

	["lunar/src/services/task.lua"] = {
		Source = "vendors/lunar/package/src/services/task.lua",
		Install = PackagesPath .. "lunar/src/services/task.lua",
	},

	["lunar/src/services/fs.lua"] = {
		Source = "vendors/lunar/package/src/services/fs.lua",
		Install = PackagesPath .. "lunar/src/services/fs.lua",
	},

	["lunar/src/services/http-client.lua"] = {
		Source = "vendors/lunar/package/src/services/http-client.lua",
		Install = PackagesPath .. "lunar/src/services/http-client.lua",
	},

	["lunar/src/services/time.lua"] = {
		Source = "vendors/lunar/package/src/services/time.lua",
		Install = PackagesPath .. "lunar/src/services/time.lua",
	},

	["lunar/src/services/run.lua"] = {
		Source = "vendors/lunar/package/src/services/run.lua",
		Install = PackagesPath .. "lunar/src/services/run.lua",
	},

	["lunar/src/services/console.lua"] = {
		Source = "vendors/lunar/package/src/services/console.lua",
		Install = PackagesPath .. "lunar/src/services/console.lua",
	},

	["lunar/src/services/error.lua"] = {
		Source = "vendors/lunar/package/src/services/error.lua",
		Install = PackagesPath .. "lunar/src/services/error.lua",
	},

	["lunar/src/services/libraries/lstring.lua"] = {
		Source = "vendors/lunar/package/src/services/libraries/lstring.lua",
		Install = PackagesPath .. "lunar/src/services/libraries/lstring.lua",
	},

	["lunar/src/services/libraries/ltable.lua"] = {
		Source = "vendors/lunar/package/src/services/libraries/ltable.lua",
		Install = PackagesPath .. "lunar/src/services/libraries/ltable.lua",
	},

	["lunar/src/services/libraries/lmath.lua"] = {
		Source = "vendors/lunar/package/src/services/libraries/lmath.lua",
		Install = PackagesPath .. "lunar/src/services/libraries/lmath.lua",
	},

	["lunar/src/services/json.lua"] = {
		Source = "vendors/lunar/package/src/services/json.lua",
		Install = PackagesPath .. "lunar/src/services/json.lua",
	},

	["lunar/src/services/plugin.lua"] = {
		Source = "vendors/lunar/package/src/services/plugin.lua",
		Install = PackagesPath .. "lunar/src/services/plugin.lua",
	},

	["lunar/src/services/http-shared.lua"] = {
		Source = "vendors/lunar/package/src/services/http-shared.lua",
		Install = PackagesPath .. "lunar/src/services/http-shared.lua",
	},

	["lunar/src/services/random.lua"] = {
		Source = "vendors/lunar/package/src/services/random.lua",
		Install = PackagesPath .. "lunar/src/services/random.lua",
	},

	["lunar/src/core/service.lua"] = {
		Source = "vendors/lunar/package/src/core/service.lua",
		Install = PackagesPath .. "lunar/src/core/service.lua",
	},

	["lunar/src/core/instance.lua"] = {
		Source = "vendors/lunar/package/src/core/instance.lua",
		Install = PackagesPath .. "lunar/src/core/instance.lua",
	},

	["lunar/src/init.lua"] = {
		Source = "vendors/lunar/package/src/init.lua",
		Install = PackagesPath .. "lunar/src/init.lua",
	},

	["luamimetypes/mimetypes.lua"] = {
		Source = "vendors/luamimetypes/mimetypes.lua",
		Install = PackagesPath .. "mimetypes.lua",
	},

	["luamimetypes/mimetypes/extensions.lua"] = {
		Source = "vendors/luamimetypes/mimetypes/extensions.lua",
		Install = PackagesPath .. "mimetypes/extensions.lua",
	},

	["luamimetypes/mimetypes/filenames.lua"] = {
		Source = "vendors/luamimetypes/mimetypes/filenames.lua",
		Install = PackagesPath .. "mimetypes/filenames.lua",
	},

	["luamimetypes/mimetypes/generated.lua"] = {
		Source = "vendors/luamimetypes/mimetypes/generated.lua",
		Install = PackagesPath .. "mimetypes/generated.lua",
	},

	["ltn12.lua"] = {
		Source = "vendors/luasocket/ltn12.lua",
		Install = PackagesPath .. "ltn12.lua",
	},

	["mime.lua"] = {
		Source = "vendors/luasocket/mime.lua",
		Install = PackagesPath .. "mime.lua",
	},

	["socket.lua"] = {
		Source = "vendors/luasocket/socket.lua",
		Install = PackagesPath .. "socket.lua",
	},

	["socket/ftp.lua"] = {
		Source = "vendors/luasocket/socket/ftp.lua",
		Install = PackagesPath .. "socket/ftp.lua",
	},

	["socket/headers.lua"] = {
		Source = "vendors/luasocket/socket/headers.lua",
		Install = PackagesPath .. "socket/headers.lua",
	},

	["socket/http.lua"] = {
		Source = "vendors/luasocket/socket/http.lua",
		Install = PackagesPath .. "socket/http.lua",
	},

	["socket/mbox.lua"] = {
		Source = "vendors/luasocket/socket/mbox.lua",
		Install = PackagesPath .. "socket/mbox.lua",
	},

	["socket/smtp.lua"] = {
		Source = "vendors/luasocket/socket/smtp.lua",
		Install = PackagesPath .. "socket/smtp.lua",
	},

	["socket/tftp.lua"] = {
		Source = "vendors/luasocket/socket/tftp.lua",
		Install = PackagesPath .. "socket/tftp.lua",
	},

	["socket/tp.lua"] = {
		Source = "vendors/luasocket/socket/tp.lua",
		Install = PackagesPath .. "socket/tp.lua",
	},

	["socket/url.lua"] = {
		Source = "vendors/luasocket/socket/url.lua",
		Install = PackagesPath .. "socket/url.lua",
	},

	["nekolib/neko.lua"] = {
		Source = "nekolua/neko.lua",
		Install = "/nekolib/neko.lua",
	},

	["nekolib/page.lua"] = {
		Source = "nekolua/page.lua",
		Install = "/nekolib/page.lua",
	},

	["nekolib/htmlelem.lua"] = {
		Source = "nekolua/htmlelem.lua",
		Install = "/nekolib/htmlelem.lua",
	},

	["nekolib/style.lua"] = {
		Source = "nekolua/style.lua",
		Install = "/nekolib/style.lua",
	},
}

local function Escape(String)
	return String:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\r", "\\r"):gsub("\n", "\\n"):gsub("\t", "\\t")
end

local Output = assert(io.open("web/nekol/packages.js", "w"))
Output:write("window.NekoPackages = {\n")

for FilePath, Package in pairs(Packages) do
	print(string.format("  GEN  %s", FilePath))

	local File = assert(io.open(Package.Source, "rb"), "Could not open " .. Package.Source)
	local FileContent = File:read("*a")
	File:close()
	Output:write("  [" .. string.format("%q", Package.Install) .. ']: "' .. Escape(FileContent) .. '",\n')
end

Output:write("};\n")
Output:close()

print("  BUNDLE web/nekol/packages.js")
