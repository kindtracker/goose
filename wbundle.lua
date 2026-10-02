local Lfs = require("lfs")

local WebFolder = "web" -- Or "public"

local function Escape(String)
	return String:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\r", "\\r"):gsub("\n", "\\n"):gsub("\t", "\\t")
end

local Output = assert(io.open(WebFolder .. "/nekol/project.json", "w"))
Output:write("{\n")

local FirstFile = true

local function Bundle(Folder, RelativePath)
	for FileName in Lfs.dir(Folder) do
		if FileName ~= "." and FileName ~= ".." then
			local Path = Folder .. "/" .. FileName
			local BundlePath = RelativePath ~= "" and (RelativePath .. "/" .. FileName) or FileName
			local Mode = Lfs.attributes(Path, "mode")

			if Mode == "directory" and BundlePath ~= "nekol" then
				Bundle(Path, BundlePath)
			elseif Mode == "file" and FileName:sub(-4) == ".lua" then
				local File = assert(io.open(Path, "r"), "Could not open " .. Path)
				local FileContent = File:read("*a")
				File:close()

				if not FirstFile then
					Output:write(",\n")
				end

				Output:write("  " .. string.format("%q", BundlePath) .. ': "' .. Escape(FileContent) .. '"')

				FirstFile = false
			end
		end
	end
end

Bundle(WebFolder, "")

Output:write("\n}")
Output:close()
